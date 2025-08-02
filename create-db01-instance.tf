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


resource "aws_instance" "db01-instance" {
	ami = "ami-0cbbe2c6a1bb2ad63" # Amazon Linux 2023
	instance_type = "t3.micro" # Free Tire
	subnet_id = data.aws_subnets.default.ids[0] # Select any 1st subnet
	vpc_security_group_ids = [aws_security_group.backend-sg.id]

	key_name = "virginia"
	
	tags = {
		Name = "db01-instance"
		Environment = "Staging"
	}
	
	user_data = <<-EOF
		#!/bin/bash
		DATABASE_PASS='admin123'
		sudo dnf update -y
		sudo dnf install git zip unzip -y
		sudo dnf install mariadb105-server -y
		# starting & enabling mariadb-server
		sudo systemctl start mariadb
		sudo systemctl enable mariadb
		cd /tmp/
		git clone -b main https://github.com/hkhcoder/vprofile-project.git
		#restore the dump file for the application
		sudo mysqladmin -u root password "$DATABASE_PASS"
		sudo mysql -u root -p"$DATABASE_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DATABASE_PASS'"
		sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
		sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
		sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
		sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
		sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
		sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
		sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
		sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
		sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

		EOF

}

resource "aws_route53_record" "db01-instance" {
        zone_id = aws_route53_zone.vanith_online.zone_id
        name = "db01-instance.vanith.online"
        type = "A"
        ttl = 300
        records = [aws_instance.db01-instance.private_ip]
}
