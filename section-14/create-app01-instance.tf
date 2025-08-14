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
            set -e
            sudo apt update
            sudo apt upgrade -y
            sudo apt install -y openjdk-17-jdk tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git unzip curl
            # Install AWS CLI v2
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip awscliv2.zip
            sudo ./aws/install
            # Download WAR from S3 and deploy to Tomcat
            aws s3 cp s3://las-artifacts-vanith/vprofile-v2.war /tmp/vprofile-v2.war
            sudo systemctl stop tomcat10.service
            sudo rm -rf /var/lib/tomcat10/webapps/ROOT
            sudo cp /tmp/vprofile-v2.war /var/lib/tomcat10/webapps/ROOT.war
            sudo systemctl start tomcat10.service
            ls -l /var/lib/tomcat10/webapps/
            EOF
}	

resource "aws_route53_record" "app01-instance" {
        zone_id = aws_route53_zone.vanith_online.zone_id
        name = "app01-instance.vanith.online"
        type = "A"
        ttl = 300
        records = [aws_instance.app01-instance.private_ip]
        }
