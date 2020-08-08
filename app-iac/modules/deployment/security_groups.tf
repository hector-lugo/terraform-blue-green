resource "aws_security_group" "alb_sg" {
  name        = "${var.deployment_name}-alb-security-group"
  description = "Security group for the load balancer for deployment ${var.deployment_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_sg" {
  name = "${var.deployment_name}-instance-sg"
  description = "Security group to attach to instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}