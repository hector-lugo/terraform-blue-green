resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.deployment_name}-instance-profile"
  role = aws_iam_role.instance_role.name
}

resource "aws_launch_template" "main" {
  name = "${var.deployment_name}-launch-template"

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  image_id = var.ami_id

  instance_type = var.instance_type

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance_profile.arn
  }

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      var: {
        deployment_name =var.deployment_name
      }
    })
  )
}

resource "aws_autoscaling_group" "main" {
  name = "${var.deployment_name}-asg"
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  count = (var.enabled) ? 1 : 0

  vpc_zone_identifier = var.server_subnets

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.alb_tg[0].arn]
}