# Create IAM Access and Secret Keys
resource "aws_iam_access_key" "s3_admin_acct_keys" {
	user = aws_iam_user.s3_admin_acct.name
}

# Output the keys 
output "s3_admin_acct_access_key" {
	value = aws_iam_access_key.s3_admin_acct_keys.secret
	sensitive = true
}
