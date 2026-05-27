#--------------
#Route53
#--------------
resource "aws_route53_zone" "route53_zone" {
  name          = var.zone_domain
  force_destroy = false

  tags = {
    name        = "${var.project}-${var.environment}-route53-zone"
    Project     = var.project
    Environment = var.environment
  }
}
