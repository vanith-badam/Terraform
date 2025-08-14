resource "aws_launch_template" "app01_lt" {
	name_prefix = "app01-lt-"
	image_id = aws_ami_from_instance.app01_ami.id
	instance_type = "t3.micro"
	key_name = "virginia"

	iam_instance_profile {
		name = aws_iam_instance_profile.s3_admin_profile.name
	}

	network_interfaces {
		associate_public_ip_address =true
		security_groups = [aws_security_group.app-sg.id]
	}

	tag_specifications {
		resource_type = "instance"
		tags = {
			Name = "app01-instance"
			Environment = "Staging"
		}
	}



}




