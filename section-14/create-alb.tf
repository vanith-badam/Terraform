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


