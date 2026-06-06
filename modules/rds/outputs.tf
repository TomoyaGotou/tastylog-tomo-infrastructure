#db_endpointという名前で、aws_db_instance.db_instance.endpointの値を出力する。
#laravelの.envファイルにDB_ENDPOINTとして設定する
output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

#db_nameという名前で、var.db_nameの値を出力する。
output "db_name" {
  value = var.db_name
}

output "db_host" {
  value = aws_db_instance.db_instance.address
}

output "db_username" {
  value = aws_db_instance.db_instance.username
}

output "db_password" {
  value     = random_string.db_password.result
  sensitive = true
}
