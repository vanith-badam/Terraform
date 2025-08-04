resource "aws_s3_bucket" "las-artifacts-vanith" {
	bucket = "las-artifacts-vanith"

	tags = { 
		Name = "las-artifacts-vanith"
		Environment = "Staging"
	}
}
