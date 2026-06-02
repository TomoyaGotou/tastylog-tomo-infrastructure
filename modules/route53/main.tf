#--------------
#Route53
#--------------
#Route53のホストゾーン。ホストゾーンは、ドメイン名とDNSレコードを管理する。AWS Route53でドメインを管理。
resource "aws_route53_zone" "route53_zone" {
  name          = var.zone_domain
  force_destroy = false

  tags = {
    Name        = "${var.project}-${var.environment}-route53-zone"
    Project     = var.project
    Environment = var.environment
  }
}
