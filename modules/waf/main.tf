#--------------
#waf module
#--------------
#waf ACL作成。cloudfrontに関連付ける。デフォルトアクションはブロック。ルールは、日本からのアクセスを許可するルール。
#devは特定のIPアドレスからのアクセスを許可するルールを作成。
resource "aws_wafv2_web_acl" "waf_acl" {
  provider    = aws.virginia
  name        = var.waf_name
  description = var.waf_description

  scope = "CLOUDFRONT"

  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project}-${var.environment}-waf"
    sampled_requests_enabled   = true
  }

  ######################## 
  ###ーー本番ーーコメントイン
  ########################
  rule {
    name     = "AllowJapan"
    priority = 1

    action {
      allow {}
    }

    statement {
      geo_match_statement {
        country_codes = ["JP"]
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project}-${var.environment}-allow-japan"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AllowSpecificIP"
    priority = 2

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allow_ip.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project}-${var.environment}-allow-specific-ip"
      sampled_requests_enabled   = true
    }
  }
}


#--------------
#waf IPセット(dev) 
#--------------
#特定のIPアドレスを許可するIPセットを作成。CloudFrontディストリビューションに関連付けることで、指定したIPアドレスからのアクセスを許可することができる。
resource "aws_wafv2_ip_set" "allow_ip" {
  provider = aws.virginia

  name  = "${var.project}-${var.environment}-allow-ip"
  scope = "CLOUDFRONT"

  ip_address_version = "IPV4"

  addresses = var.allowed_ip_addresses # 後藤 home IP address　動的IP注意

}
