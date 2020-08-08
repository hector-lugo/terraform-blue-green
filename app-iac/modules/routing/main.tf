resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.dns_record
  type    = "A"
  set_identifier = var.set_identifier

  weighted_routing_policy {
    weight = var.weight
  }

  alias {
    name                   = var.load_balancer_dns
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}

data "aws_route53_zone" "zone" {
  name = var.hosted_zone
}