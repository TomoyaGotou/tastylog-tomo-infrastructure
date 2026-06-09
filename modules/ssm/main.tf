#
# Parameter
#
resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.project}/${var.environment}/app/DB_HOST"
  type  = "String"
  value = var.db_host
}

resource "aws_ssm_parameter" "db_database" {
  name  = "/${var.project}/${var.environment}/app/DB_DATABASE"
  type  = "String"
  value = var.db_database
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.project}/${var.environment}/app/DB_USERNAME"
  type  = "SecureString"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.project}/${var.environment}/app/DB_PASSWORD"
  type  = "SecureString"
  value = var.db_password
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/${var.project}/${var.environment}/app/DB_PORT"
  type  = "String"
  value = 3306
}

resource "aws_ssm_parameter" "app_key" {
  name  = "/${var.project}/${var.environment}/app/APP_KEY"
  type  = "SecureString"
  value = var.app_key
}
