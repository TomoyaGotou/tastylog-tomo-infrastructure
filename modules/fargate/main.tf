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

  container_definitions = jsonencode([
    {
      name      = "app-container"
      image     = "${var.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
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
  name            = "${var.project}-${var.environment}-app-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [
      var.ecs_sg_id
    ]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app-container"
    container_port   = 80
  }
}
