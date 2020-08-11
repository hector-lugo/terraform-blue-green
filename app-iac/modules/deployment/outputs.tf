output "load_balancer_dns" {
  value = (var.enabled ? aws_lb.alb[0].dns_name : "")
}

output "load_balancer_zone_id" {
  value = (var.enabled ? aws_lb.alb[0].zone_id : "")
}