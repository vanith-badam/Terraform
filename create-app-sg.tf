resource "aws_security_group" "app-sg" {
        name = "app-sg"
        description = "Security Group for App server"
        vpc_id = "vpc-0e15358781b7d4bce" # Default VPC
        tags = {
                Name = "spp-sg"
        }

        ingress {
                description = "Allow Custom TCP 8080 from ELB-SG"
                from_port = 8080
                to_port = 8080
                protocol = "tcp"
                security_groups = [aws_security_group.elb-sg.id] # Reference ELB-SG
        }
        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
                ipv6_cidr_blocks = ["::/0"]
        }
        ingress {
                description = "Allow SSH Potocol from anywhere"
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
}
