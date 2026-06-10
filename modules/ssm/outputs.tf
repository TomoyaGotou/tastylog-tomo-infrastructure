
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

output "db_port_arn" {
  value = aws_ssm_parameter.db_port.arn
}

output "app_key_arn" {
  value = aws_ssm_parameter.app_key.arn
}

output "app_url_arn" {
  value = aws_ssm_parameter.app_url.arn
}
