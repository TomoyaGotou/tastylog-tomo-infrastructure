#--------------
#security group
#--------------
#ALB security group
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

resource "aws_security_group_rule" "alb_sg_in_https" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
}

resource "aws_security_group_rule" "alb_sg_out_tcp3000" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  source_security_group_id = aws_security_group.ecs_sg.id
}

#ecs security group
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

resource "aws_security_group_rule" "ecs_sg_in_tcp3000" {
  security_group_id        = aws_security_group.ecs_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "ecs_sg_out_https" {
  security_group_id = aws_security_group.ecs_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

#db security group
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


resource "aws_security_group_rule" "db_sg_in_mysql" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ecs_sg.id
}

#CLB prefix list
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}