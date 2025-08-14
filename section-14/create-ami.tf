resource  "aws_ami_from_instance" "app01_ami" {
	name = "app01-ami"
	source_instance_id = aws_instance.app01-instance.id
	snapshot_without_reboot = true

	tags = {
		Name = "app01-ami"
		Environment = "Staging"
	}
}
