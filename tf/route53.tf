locals {
  flat_zones = flatten([
      for zone in var.zones: [
          zone.name,
          [
            for subzone in coalesce(zone.subzones, []): "${subzone}.${zone.name}"
          ]
      ]
  ])

  subdomains = flatten([
    for zone in var.zones: ([
        for sub in coalesce(zone.subzones, []): {
          domain = sub
          zone = zone.name
        }
      ]
    )
  ])
}

resource "aws_route53domains_registered_domain" "this" {
  domain_name = var.domain
  transfer_lock = false

  dynamic name_server {
    for_each = toset(aws_route53_zone.this[var.domain].name_servers)

    content {
      name = name_server.value
    }
  }
// tags = var.tags
}

resource "aws_route53_zone" "this" {
  for_each = toset(local.flat_zones)

  name = each.value
// tags = var.tags
}

resource "aws_route53_record" "ns" {
  for_each = {
      for subdomain in local.subdomains: "${subdomain.domain}.${subdomain.zone}" => subdomain.zone
  }

  zone_id = aws_route53_zone.this[each.value].zone_id
  name    = each.key
  type    = "NS"
  ttl     = 172800
  records = toset(aws_route53_zone.this[each.key].name_servers)
}

/*
resource "aws_route53_record" "root-a" {
  zone_id = aws_route53_zone.main.zone_id
  name = var.domain
  type = "A"
}

resource "aws_route53_record" "www-a" {
  zone_id = aws_route53_zone.main.zone_id
  name = "www.${var.domain}"
  type = "A"
}
*/