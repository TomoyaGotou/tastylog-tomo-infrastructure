#-----------------------
# backend s3
#-----------------------
#tfstateファイル用　S3Bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tastylog-tomo-terraform-state-575393967412"

  tags = {
    Name        = "tastylog-tomo-terraform-state"
    Project     = "tastylog-tomo"
    Environment = "shared"
    ManagedBy   = "Terraform"
  }
}

# 過去バージョンに戻せるように
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 暗号化で保存
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#tfstateは絶対に公開してはいけない
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
