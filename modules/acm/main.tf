#------------------------
# Certificate
#------------------------
# dev環境で証明書を発行(東京リージョン)　
resource "aws_acm_certificate" "tokyo_dev_acm_cert" {
  domain_name       = var.record_domain
  validation_method = "DNS"

  tags = {
    name        = "${var.project}-${var.environment}-dev-acm-cert"
    Project     = var.project
    Environment = var.environment
  }
  lifecycle {
    create_before_destroy = true
  }
}

#cloudfrontで使用するACM証明書のDNS検証用レコードをRoute53に登録する
resource "aws_acm_certificate" "cloudfront_dev_acm_cert" {
  provider = aws.virginia

  domain_name       = var.record_domain
  validation_method = "DNS"

  tags = {
    name        = "${var.project}-${var.environment}-cloudfront-dev-acm-cert"
    Project     = var.project
    Environment = var.environment
  }
  lifecycle {
    create_before_destroy = true
  }
}

#------------------------
# ACMのDNS検証用レコード
#------------------------
# Route53のホストゾーンを取得
data "aws_route53_zone" "main" {
  name         = var.zone_domain
  private_zone = false
}

# ACMのDNS検証用レコードをRoute53に登録する
resource "aws_route53_record" "route53_acm_dns_resolve" {
  for_each = {
    for dvo in aws_acm_certificate.tokyo_dev_acm_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.main.id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 600
}

#検証/ 証明書のDNS検証を実行する(東京リージョン)
resource "aws_acm_certificate_validation" "tokyo_dev_acm_cert_valid" {
  certificate_arn         = aws_acm_certificate.tokyo_dev_acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_acm_dns_resolve : record.fqdn]
}

# ACMのDNS検証用レコードをRoute53に登録する(バージニアリージョン)
resource "aws_route53_record" "route53_cloudfront_acm_dns_resolve" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront_dev_acm_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.main.id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 600
}

#検証/ 証明書のDNS検証を実行する(バージニアリージョン)
#cloudfrontで使用するACM証明書。バージニアリージョンで発行したACM証明書を検証するため、プロバイダーをaws.virginiaに指定。
resource "aws_acm_certificate_validation" "cloudfront_dev_acm_cert_valid" {
  provider                = aws.virginia
  certificate_arn         = aws_acm_certificate.cloudfront_dev_acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_cloudfront_acm_dns_resolve : record.fqdn]
}
