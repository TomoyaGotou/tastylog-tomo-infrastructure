output "execution_role_arn" {
  value = aws_iam_role.fargate_task_execution.arn
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "task_role_arn" {
  value = aws_iam_role.fargate_task_role.arn
}
