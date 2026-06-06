variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "github_repository_name" {
  type = string
}

variable "github_branch_name" {
  type = string
}

variable "codebuild_project_name" {
  type = string
}

variable "pipeline_artifact_bucket" {
  type = string
}

variable "codepipeline_role_arn" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}
