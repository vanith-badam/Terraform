resource "aws_autoscaling_group" "app01_asg" {
  name                      = "app01-asg"
  launch_template {
    id      = aws_launch_template.app01_lt.id
    version = "$Latest"
  }
  min_size                  = 1
  desired_capacity          = 2
  max_size                  = 3
  vpc_zone_identifier       = data.aws_subnets.default.ids

  target_group_arns         = [aws_lb_target_group.app01_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "app01-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "app01_asg_alb" {
  autoscaling_group_name = aws_autoscaling_group.app01_asg.name
  lb_target_group_arn    = aws_lb_target_group.app01_tg.arn
}

