#--------------
#Route53
#--------------
#Route53のホストゾーンを作成するモジュール。ホストゾーンは、ドメイン名とDNSレコードを管理する。AWS Route53でドメインを管理するために必要。
resource "aws_route53_zone" "route53_zone" {
  name          = var.zone_domain
  force_destroy = false

  tags = {
    name        = "${var.project}-${var.environment}-route53-zone"
    Project     = var.project
    Environment = var.environment
  }
}
