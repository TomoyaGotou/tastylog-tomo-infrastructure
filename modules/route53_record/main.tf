#--------------
#Route53 record
#--------------
#CloudFrontのドメインをRoute53のAレコードとして登録するモジュール。CloudFrontディストリビューションのドメイン名とホストゾーンIDを指定してエイリアスレコードを作成。
#Route53のホストゾーンは、modules/route53/main.tfで作成したものを参照している。ホストゾーンIDは、aws_route53_zone.route53_zone.zone_idで取得。
data "aws_route53_zone" "main" {
  name = var.zone_domain
}

resource "aws_route53_record" "cloudfront_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.record_domain
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
