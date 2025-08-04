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


resource "aws_instance" "app01-instance" {
	ami = "ami-020cba7c55df1f615" # Ubuntu Server 24.04 LTS
	instance_type = "t3.micro" # Free Tire
	subnet_id = data.aws_subnets.default.ids[0] # Select any 1st subnet
	vpc_security_group_ids = [aws_security_group.app-sg.id]
	iam_instance_profile = aws_iam_instance_profile.s3_admin_profile.name

	key_name = "virginia"
	
	tags = {
		Name = "app01-instance"
		Environment = "Staging"
	}
	
	user_data = <<-EOF
		#!/bin/bash
		sudo apt update
		sudo apt upgrade -y
		sudo apt install openjdk-17-jdk -y
		sudo apt install tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git -y

		EOF
}

resource "aws_route53_record" "app01-instance" {
        zone_id = aws_route53_zone.vanith_online.zone_id
        name = "app01-instance.vanith.online"
        type = "A"
        ttl = 300
        records = [aws_instance.app01-instance.private_ip]
        }
