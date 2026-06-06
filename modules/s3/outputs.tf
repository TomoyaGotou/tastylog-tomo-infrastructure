output "bucket_name" {
  value = aws_s3_bucket.pipeline.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.pipeline.arn
}
