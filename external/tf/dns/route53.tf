resource "aws_route53domains_registered_domain" "this" {
  domain_name = var.domain
  transfer_lock = false

  dynamic name_server {
    for_each = toset(aws_route53_zone.sld.name_servers)

    content {
      name = name_server.value
    }
  }
}

resource "aws_route53_zone" "sld" {
  name = var.domain
}

resource "aws_route53_zone" "home" {
  name = "home.${var.domain}"
}

resource "aws_route53_record" "home_ns" {
  zone_id = aws_route53_zone.sld.zone_id
  name    = aws_route53_zone.home.name
  type    = "NS"
  ttl     = "300"

  records = aws_route53_zone.home.name_servers
}