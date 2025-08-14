#Target Group
resource "aws_lb_target_group" "app01_tg" {
	name = "app01-tg"
	port = 8080
	protocol = "HTTP"
	target_type = "instance"
	vpc_id = data.aws_vpc.default.id
	
	health_check {
		path = "/"
		protocol = "HTTP"
		matcher = "200"
		interval = 30
		timeout = 5
		healthy_threshold = 2
		unhealthy_threshold =2
	}
	tags = {
		Name = "app01-target-group"
		Environment = "Staging"
		}
}

# Attach app01 instance to target group
resource "aws_lb_target_group_attachment" "app01-attachment" {
	target_group_arn = aws_lb_target_group.app01_tg.arn
	target_id = aws_instance.app01-instance.id
	port = 8080
}
