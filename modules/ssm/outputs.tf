
output "db_host_arn" {
  value = aws_ssm_parameter.db_host.arn
}

output "db_database_arn" {
  value = aws_ssm_parameter.db_database.arn
}

output "db_username_arn" {
  value = aws_ssm_parameter.db_username.arn
}

output "db_password_arn" {
  value = aws_ssm_parameter.db_password.arn
}
