# Get default VPC
#data "aws_vpc" "default" {
#	default = true
#}
#
#
## Get one subnet from the default VPC
#data "aws_subnets" "default" {
#	filter {
#		name = "vpc-id"
#		values = [data.aws_vpc.default.id]
#	}
#}


resource "aws_instance" "rmq01-instance" {
	ami = "ami-0cbbe2c6a1bb2ad63" # Amazon Linux 2023
	instance_type = "t3.micro" # Free Tire
	subnet_id = data.aws_subnets.default.ids[0] # Select any 1st subnet
	vpc_security_group_ids = [aws_security_group.backend-sg.id]

	key_name = "virginia"
	
	tags = {
		Name = "rmq01-instance"
		Environment = "Staging"
	}
	
	user_data = <<-EOF
		#!/bin/bash
		## primary RabbitMQ signing key
		rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc'
		## modern Erlang repository
		rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key'
		## RabbitMQ server repository
		rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key'
		curl -o /etc/yum.repos.d/rabbitmq.repo https://raw.githubusercontent.com/hkhcoder/vprofile-project/refs/heads/awsliftandshift/al2023rmq.repo
		dnf update -y
		## install these dependencies from standard OS repositories
		dnf install socat logrotate -y
		## install RabbitMQ and zero dependency Erlang
		dnf install -y erlang rabbitmq-server
		systemctl enable rabbitmq-server
		systemctl start rabbitmq-server
		sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
		sudo rabbitmqctl add_user test test
		sudo rabbitmqctl set_user_tags test administrator
		rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

		sudo systemctl restart rabbitmq-server

		
		EOF

}
resource "aws_route53_record" "rmq01-instance" {
        zone_id = aws_route53_zone.vanith_online.zone_id
        name = "rmq01-instance.vanith.online"
        type = "A"
        ttl = 300
        records = [aws_instance.rmq01-instance.private_ip]
        }
