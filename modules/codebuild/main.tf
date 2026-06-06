#------------------------
# Codebuild 
#------------------------
resource "aws_codebuild_project" "codebuild" {
  name         = "${var.project}-${var.environment}-codebuild-project"
  description  = "${var.project}-${var.environment}-codebuild-project"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "REPOSITORY_URI"
      value = var.repository_url
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }

    environment_variable {
      name  = "ECS_CLUSTER_NAME"
      value = var.ecs_cluster_name
    }

    environment_variable {
      name  = "SUBNET_ID_1"
      value = var.private_subnet_id_1
    }

    environment_variable {
      name  = "SUBNET_ID_2"
      value = var.private_subnet_id_2
    }

    environment_variable {
      name  = "SECURITY_GROUP_ID"
      value = var.ecs_sg_id
    }

    environment_variable {
      name  = "MIGRATION_TASK_DEFINITION"
      value = var.migration_task_definition
    }
  }
}
