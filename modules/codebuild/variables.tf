variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "codebuild_role_arn" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "container_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "private_subnet_id_1" {
  type = string
}

variable "private_subnet_id_2" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}

variable "migration_task_definition" {
  type = string
}
