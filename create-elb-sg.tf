provider "aws" {
        region = "us-east-1"
}
resource "aws_security_group" "elb-sg" {
        name = "elb-sg"
        description = "Security group for ELB allowing HTTP & HTTPS access"
        vpc_id = "vpc-0e15358781b7d4bce" # Default VPC

        tags = {
                Name = "elb-sg"
        }

        ingress {
                description = "Allow HTTP from anywhere (IPv4)"
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
                description = "Allow HTTP from anywhere (IPv6)"
                from_port = 80
                to_port = 80
                protocol = "tcp"
                ipv6_cidr_blocks = ["::/0"]
        }

        ingress {
                description = "Allow HTTPS from anywhere (IPv4)"
                from_port = 443
                to_port = 443
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
                description = "Allow HTTPS from anywhere (IPv6)"
                from_port = 443
                to_port = 443
                protocol = "tcp"
                ipv6_cidr_blocks = ["::/0"]
        }

        egress {
                description = "Allow all in outbound rules"
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
                ipv6_cidr_blocks = ["::/0"]
        }
}
