resource "aws_security_group" "backend-sg" {
	name = "backend-sg"
	description = "Security group for MySQL, Memcache and RabbitMQ allowed from tomcat app server"
	vpc_id = "vpc-0e15358781b7d4bce" # Default VPC
	
	tags = {
		Name = "backend-sg"
	}

	ingress {
		description = "Allow MySQL/Aurora from app-sg"
 		from_port = 3306
		to_port	= 3306
		protocol = "tcp"
		security_groups = [aws_security_group.app-sg.id]
	}
	
	ingress {
		description = "Allow custom TCP port 5672"
		from_port = 5672
		to_port = 5672
		protocol = "tcp"
		security_groups = [aws_security_group.app-sg.id]
	}

	ingress {
		description = "Allow custom TCP port 11211"
		from_port = 11211
		to_port = 11211
		protocol = "tcp"
		security_groups = [aws_security_group.app-sg.id]
	}

	ingress {
		description = "Allow SSH from any where"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
 	}

	
	egress {
		description = "Outbound rules"
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		ipv6_cidr_blocks = ["::/0"]
	}

	ingress {
		description = "Allow app01"
		from_port = 0
  		to_port = 0
		protocol = "-1"
		security_groups = [aws_security_group.app-sg.id]
 	}

}



