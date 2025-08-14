resource "aws_s3_bucket" "las_artifacts_vanith" {
  bucket = "las-artifacts-vanith"

  tags = {
    Name        = "las-artifacts-vanith"
    Environment = "Staging"
  }
}

# Upload file to the bucket
resource "aws_s3_object" "uploaded_file" {
  bucket = aws_s3_bucket.las_artifacts_vanith.bucket
  key    = "vprofile-v2.war" # Path inside S3 bucket
  source = "/tmp/vprofile-v2.war"                 # Local file path
  etag   = filemd5("/tmp/vprofile-v2.war")        # Ensures upload only if file changes
}

