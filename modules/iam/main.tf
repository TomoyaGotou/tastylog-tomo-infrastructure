#------------------------
# iam
#------------------------
#fargateタスクの実行に必要なIAMロールとポリシーを定義。タスクがAWSリソースにアクセスするための権限を付与。 
resource "aws_iam_role" "fagate_task_execution" {
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

#awsリソース参照　
#：ECRからイメージをプル　：CloudWatch Logsにログを出力　：Secrets Managerからシークレットを取得　：S3からファイルを取得　：RDSに接続する権限
resource "aws_iam_role_policy_attachment" "fagate_task_execution_role_poricy" {
  role = aws_iam_role.fagate_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
