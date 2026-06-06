#------------------------
# CodePipeline
#------------------------
# GitHubからのソースコードを取得し、CodeBuildでビルドを実行するCI/CDパイプラインを構築
resource "aws_codepipeline" "pipeline" {
  name     = "${var.project}-${var.environment}-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.pipeline_artifact_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceOutput"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codeconnection.arn
        FullRepositoryId = "TomoyaGotou/${var.github_repository_name}"
        BranchName       = var.github_branch_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "BuildAction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildOutput"]
      version         = "1"

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.ecs_service_name
        FileName    = "imagedefinitions.json"
      }
    }
  }

  tags = {
    Name        = "${var.project}-${var.environment}-pipeline"
    Project     = var.project
    Environment = var.environment
  }
}

#------------------------
# CodeStar Connection
#------------------------
# GitHubリポジトリへの接続を確立するためのリソース
resource "aws_codestarconnections_connection" "codeconnection" {
  name          = "${var.project}-${var.environment}-github"
  provider_type = "GitHub"

  tags = {
    Name        = "${var.project}-${var.environment}-github"
    Project     = var.project
    Environment = var.environment
  }
}
