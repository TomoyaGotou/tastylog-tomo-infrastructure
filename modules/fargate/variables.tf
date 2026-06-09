variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "alb_target_group_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "db_host_arn" {
  type = string
}

variable "db_database_arn" {
  type = string
}

variable "db_username_arn" {
  type = string
}

variable "db_password_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "db_port_arn" {
  type = string
}

variable "app_key_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

