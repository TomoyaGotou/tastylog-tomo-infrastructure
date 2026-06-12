#------------------------
# CloudFront 
#-----------------------
# CloudFrontディストリビューションを作成する
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_200"
  web_acl_id      = var.waf_acl_arn

  aliases = [var.record_domain]

  origin {
    domain_name = "alb.${var.record_domain}"
    origin_id   = "${var.project}-${var.environment}-alb-origin"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      headers = ["Host"] # laravel側の設定でホストヘッダーを明示的に指定しない限りは送信元(この場合ALB)になる仕様となっていたため設定

      cookies {
        forward = "all"
      }
    }

    target_origin_id       = "${var.project}-${var.environment}-alb-origin"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-cloudfront"
    Project     = var.project
    Environment = var.environment
  }
}
