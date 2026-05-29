#------------------------
# ECR
#------------------------
resource "aws_ecr_repository" "app_repository" {
  name = "${var.project}-${var.environment}-app-repository"
}
