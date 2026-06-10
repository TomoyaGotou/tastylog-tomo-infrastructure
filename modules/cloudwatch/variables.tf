variable "project" {
  type = string
}

variable "environment" {
  type = string
}


variable "alarm_email" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "cloudfront_distribution_id" {
  type = string
}
