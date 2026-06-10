#--------------
# SNS topic
#--------------
resource "aws_sns_topic" "alarm" {
  name = "${var.project}-${var.environment}-alarm-topic"

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarm.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}
