#
# S3
#
resource "aws_s3_bucket" "pipeline" {
  bucket = var.bucket_name
  acl    = "private"
}
