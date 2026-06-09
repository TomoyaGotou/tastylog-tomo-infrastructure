#--------------
#Route53 record
#--------------

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project}-${var.environment}-app"
  retention_in_days = 14
}
