# Get default VPC
# data "aws_vpc" "default" {
#	default = true
#}


## Get one subnet from the default VPC
#data "aws_subnets" "default" {
#	filter {
#		name = "vpc-id"
#		values = [data.aws_vpc.default.id]
#	}
#}


resource "aws_instance" "mc01-instance" {
	ami = "ami-0cbbe2c6a1bb2ad63" # Amazon Linux 2023
	instance_type = "t3.micro" # Free Tire
	subnet_id = data.aws_subnets.default.ids[0] # Select any 1st subnet
	vpc_security_group_ids = [aws_security_group.backend-sg.id]

	key_name = "virginia"
	
	tags = {
		Name = "mc01-instance"
		Environment = "Staging"
	}
	
	user_data = <<-EOF
		#!/bin/bash
		DATABASE_PASS='admin123'
		sudo dnf install memcached -y
		sudo systemctl start memcached
		sudo systemctl enable memcached
		sudo systemctl status memcached
		sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
		sudo systemctl 	restart memcached
		sudo memcached -p 11211 -U 11111 -u memcached -d
		EOF
}
