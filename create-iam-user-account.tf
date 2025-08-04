# Create IAM User Account

resource "aws_iam_user" "s3_admin_acct" {
	name = "s3_admin_acct"
	tags = {
		Name = "s3_admin_acct"
		Environment = "Staging"
	}
}

# Create and Attach the inline policy to the user
resource "aws_iam_user_policy" "s3_full_access_inline" {
	name = "s3_full_access_inline"
	user = aws_iam_user.s3_admin_acct.name
	
	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
			Action = "s3:*"
			Effect = "Allow"
			Resource = "*"
			}
		]
  	})
}
