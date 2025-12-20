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
