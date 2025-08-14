#Application Load Balancer
resource "aws_lb" "app01_alb" {
	name = "app01-alb"
	internal = false
	load_balancer_type ="application"
	security_groups = [aws_security_group.elb-sg.id]
	subnets = data.aws_subnets.default.ids

	tags = {
		Name = "app01-alb"
		Environment = "Staging"
	}
	
}

# Lister for ALB
resource "aws_lb_listener" "app01_listener" {
	load_balancer_arn = aws_lb.app01_alb.arn
	port = 80
	protocol = "HTTP"

	default_action {
	type = "forward"
	target_group_arn = aws_lb_target_group.app01_tg.arn

	}	
}

# HTTP listener to redirect to HTTPS
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.app01_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener with ACM cert
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app01_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.app01_cert_validation_complete.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app01_tg.arn
  }
}

