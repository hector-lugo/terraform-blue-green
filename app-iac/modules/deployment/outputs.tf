output "load_balancer_dns" {
  value = aws_lb.alb.dns_name
}

output "load_balancer_zone_id" {
  value = aws_lb.alb.zone_id
}