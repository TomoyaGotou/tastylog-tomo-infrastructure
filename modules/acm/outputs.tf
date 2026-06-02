#acm moduleのアウトプット
output "certificate_arn" {
  value = aws_acm_certificate_validation.tokyo_dev_acm_cert_valid.certificate_arn
}

#cloudfront moduleのアウトプット
output "cloudfront_certificate_arn" {
  value = aws_acm_certificate_validation.cloudfront_dev_acm_cert_valid.certificate_arn
}
