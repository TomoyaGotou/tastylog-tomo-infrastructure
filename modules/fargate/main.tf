#------------------------
# ecs cluster
#------------------------
# Fargateタスクを実行するための、ECSクラスタ。
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#------------------------
# task definition
#------------------------
# Fargateタスクの定義。ECRリポジトリからイメージを取得し、リソースや設定を指定。
resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.project}-${var.environment}-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.project}-${var.environment}-app-container"
      image     = "${var.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      # #cloudwatchlogs への出力・エラー用
      # logConfiguration = {
      #   logDriver = "awslogs"
      #   options = {
      #     awslogs-group         = aws_cloudwatch_log_group.ecs.name
      #     awslogs-region        = var.aws_region
      #     awslogs-stream-prefix = "ecs"
      #   }
      # }

      #SSMから取ってくる
      secrets = [
        {
          name      = "DB_HOST"
          valueFrom = var.db_host_arn
        },
        {
          name      = "DB_DATABASE"
          valueFrom = var.db_database_arn
        },
        {
          name      = "DB_USERNAME"
          valueFrom = var.db_username_arn
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = var.db_password_arn
        },
        {
          name      = "DB_PORT"
          valueFrom = var.db_port_arn
        },
        {
          name      = "APP_KEY"
          valueFrom = var.app_key_arn
        }
      ]
    }
  ])
}

#------------------------
# Service
#------------------------
# Fargateサービスの定義。ALBと連携してトラフィックを分散。
resource "aws_ecs_service" "app_service" {
  name                   = "${var.project}-${var.environment}-app-service"
  cluster                = aws_ecs_cluster.ecs_cluster.id
  task_definition        = aws_ecs_task_definition.app_task.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [
      var.ecs_sg_id
    ]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "${var.project}-${var.environment}-app-container"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}
