#--------------
# Cloudwatch ECS
#--------------
#ECSコンテナのログ出力場所
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project}-${var.environment}-app"
  retention_in_days = 14

  #   lifecycle {
  #     prevent_destroy = true　　　devはなし
  #   }

  tags = {
    Name        = "${var.project}-${var.environment}-ecs-log-group"
    Project     = var.project
    Environment = var.environment
  }
}



