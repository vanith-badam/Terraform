# Create IAM Role
resource "aws_iam_role" "s3_admin_role" {
	name = "s3_admin_role"
	
	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
			Effect = "Allow"
			Principal = {
				Service = "ec2.amazonaws.com"
			}
			Action = "sts:AssumeRole"
			}
		]
	})
}

resource "aws_iam_role_policy_attachment" "s3_access_attach" {
	role = aws_iam_role.s3_admin_role.name
	policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "s3_admin_profile" {
	name = "s3_admin_profile"
	role = aws_iam_role.s3_admin_role.name
}

