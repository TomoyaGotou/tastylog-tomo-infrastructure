# --------------
# RDS parameter group
# --------------
#RDSのパラメーターグループを作成するモジュール。MySQL8.0用のパラメーターグループを作成。RDSインスタンスで使用
resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${var.project}-${var.environment}-db-parameter-group"
  family = "mysql8.0"

  # 文字コード（utf8mb4絵文字も使える）
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  # サーバーの文字コード(デフォルト)
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  # クライアントの文字コード（接続してくるアプリ側から）
  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
  # 照合順序（collation 大文字小文字の区別や略称を照合し扱う）
  parameter {
    name  = "collation_server"
    value = "utf8mb4_general_ci"
  }

  # タイムゾーン(日本時間に設定)
  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-db-parameter-group"
    project     = var.project
    environment = var.environment
  }
}

# --------------
# RDS option group
# --------------
#RDSのオプショングループを作成するモジュール。MySQL8.0用のオプショングループを作成。RDSインスタンスで使用
resource "aws_db_option_group" "db_option_group" {
  name                 = "${var.project}-${var.environment}-db-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# --------------
# RDS subnet group
# --------------
#RDSインスタンスを配置するサブネットを指定。プライベートサブネットを指定。
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project}-${var.environment}-db-subnet-group"
    project     = var.project
    environment = var.environment
  }
}

# --------------
# RDS instance
# --------------
#Aurora MySQLを使用。マルチAZ構成。バックアップやメンテナンスウィンドウも設定。
resource "random_string" "db_password" {
  length  = 16
  special = true
}

resource "aws_db_instance" "db_instance" {
  engine         = "mysql"
  engine_version = "8.0"

  identifier = "${var.project}-${var.environment}-db-instance"

  username = var.db_username
  password = random_string.db_password.result

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp2"

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.db_sg_id]
  publicly_accessible    = false
  port                   = 3306

  db_name              = var.db_name
  parameter_group_name = aws_db_parameter_group.db_parameter_group.name
  option_group_name    = aws_db_option_group.db_option_group.name

  backup_window              = "03:00-04:00"
  backup_retention_period    = 7
  maintenance_window         = "sun:05:00-sun:06:00"
  auto_minor_version_upgrade = true

  deletion_protection = false
  skip_final_snapshot = true

  apply_immediately = true

  tags = {
    Name        = "${var.project}-${var.environment}-db-instance"
    project     = var.project
    environment = var.environment
  }
}
