#------------------------
# iam role
#------------------------
# Fargate タスク実行時に必要な iam ロール
resource "aws_iam_role" "fargate_task_execution" {
  name = "${var.project}-${var.environment}-fargate-execution-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ecs exer用タスクロール
resource "aws_iam_role" "fargate_task_role" {
  name = "${var.project}-${var.environment}-fargate-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ecs exerタスクポリシー
resource "aws_iam_role_policy" "fargate_task_exec_policy" {
  name = "${var.project}-${var.environment}-fargate-task-exec-policy"
  role = aws_iam_role.fargate_task_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project}-${var.environment}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "codebuild_role" {
  name = "${var.project}-${var.environment}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

#------------------------
# iam policy 
#------------------------
# build用　DockerイメージをECRへpush/pull・実行ログを出力・パラメータを取得・CodePipelineのArtifactを取得/保存・
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.project}-${var.environment}-codebuild-policy"
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = "*"
      },
      # CICD でタスク実行用
      {
        Effect = "Allow"
        Action = [
          "ecs:RunTask",
          "ecs:DescribeTasks"
        ]
        Resource = "*"
      },
      # ECS Exec用（障害調査・緊急対応）
      {
        Effect = "Allow"
        Action = [
          "ecs:ExecuteCommand"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.project}-${var.environment}-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

#------------------------
# iam policy attachment
#------------------------
#awsリソース参照　task定義のポリシー
#：ECRからイメージをプル　：CloudWatch Logsにログを出力　：Secrets Managerからシークレットを取得　：S3からファイルを取得　：RDSに接続する権限
resource "aws_iam_role_policy_attachment" "fargate_task_execution_role_policy" {
  role       = aws_iam_role.fargate_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECSタスク起動時にSSM Parameter Storeの値を取得するため
resource "aws_iam_role_policy" "fargate_execution_ssm_policy" {
  name = "${var.project}-${var.environment}-fargate-execution-ssm-policy"
  role = aws_iam_role.fargate_task_execution.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = "*"
      }
    ]
  })
}
