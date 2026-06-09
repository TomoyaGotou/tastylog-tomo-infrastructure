#--------------
#security group
#--------------
#ALB security group
#albはインターネットからのHTTPSトラフィックを受け入れ、ECSセキュリティグループへのアウトバウンドルール
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.environment}-alb-sg"
  vpc_id      = var.vpc_id
  description = "ALB role security group"

  tags = {
    Name        = "${var.project}-${var.environment}-alb-sg"
    project     = var.project
    environment = var.environment
  }
}

#ALBSGのインバウンドルールは、CFのプレフィックスリストを使用してHTTPSトラフィックを許可。
resource "aws_security_group_rule" "alb_sg_in_https" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
}

# # 動作確認用：自分のIPからの HTTPS を一時許可
# resource "aws_security_group_rule" "alb_sg_in_https_myip" {
#   security_group_id = aws_security_group.alb_sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_blocks       = ["180.196.159.64/32"]
# }

#ALBSGのアウトバウンドルールは、ECSセキュリティグループへのHTTPトラフィックを許可。
resource "aws_security_group_rule" "alb_sg_out_tcp80" {
  security_group_id        = aws_security_group.alb_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.ecs_sg.id
}

#ecs security group
#ECSSGは、ALBSGからのHTTPトラフィックを許可するインバウンドルールと、インターネットへのHTTPSトラフィックを許可するアウトバウンドルールを持つ。
resource "aws_security_group" "ecs_sg" {
  name        = "${var.project}-${var.environment}-ecs-sg"
  vpc_id      = var.vpc_id
  description = "ECS role security group"

  tags = {
    Name        = "${var.project}-${var.environment}-ecs-sg"
    project     = var.project
    environment = var.environment
  }
}

#ECSSGのインバウンドルールは、ALBSGからのHTTPトラフィックを許可。
resource "aws_security_group_rule" "ecs_sg_in_tcp80" {
  security_group_id        = aws_security_group.ecs_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.alb_sg.id
}

# ECSからRDS(MySQL)へのアウトバウンドを許可
resource "aws_security_group_rule" "ecs_sg_out_mysql" {
  security_group_id        = aws_security_group.ecs_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.db_sg.id
}

#ECSSGのアウトバウンドルールは、インターネットへのHTTPSトラフィックを許可。
resource "aws_security_group_rule" "ecs_sg_out_https" {
  security_group_id = aws_security_group.ecs_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

#db security group
#DBSGは、ECSSGからのMySQLトラフィックを許可するインバウンドルール
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  vpc_id      = var.vpc_id
  description = "Database security group"

  tags = {
    Name        = "${var.project}-${var.environment}-db-sg"
    project     = var.project
    environment = var.environment
  }
}

#mysqlのポート3306をECSSGから許可するインバウンドルール。
resource "aws_security_group_rule" "db_sg_in_mysql" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ecs_sg.id
}

#CloudFront prefix list
#CloudFrontのプレフィックスリストを使用して、ALBSGのインバウンドルールでHTTPSトラフィックを許可。
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

#-----------------
#Interface Endpoint security group
#-----------------
#ECS exer
resource "aws_security_group" "vpce_sg" {
  name        = "${var.project}-${var.environment}-vpce-sg"
  vpc_id      = var.vpc_id
  description = "VPC Endpoint security group"

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    description     = "HTTPS from ECS tasks"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-vpce-sg"
    project     = var.project
    environment = var.environment
  }
}
