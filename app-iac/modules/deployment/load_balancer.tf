resource "aws_lb" "alb" {
  name               = "${var.deployment_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.alb_subnets

  count = (var.enabled) ? 1 : 0

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.deployment_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  count = (var.enabled) ? 1 : 0
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  count = (var.enabled) ? 1 : 0

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg[0].arn
  }
}
