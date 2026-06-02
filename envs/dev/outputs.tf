#------------------------
# VPC
#------------------------
output "vpc_id" {
  value = module.vpc.vpc_id
}

#------------------------
# ALB
#------------------------
output "alb_dns_name" {
  value = module.alb.dns_name
}

output "alb_zone_id" {
  value = module.alb.zone_id
}

#------------------------
# ECS
#------------------------
output "ecs_cluster_name" {
  value = module.fargate.ecs_cluster_name
}

#------------------------
# ECR
#------------------------
output "ecr_repository_url" {
  value = module.ecr.repository_url
}

#------------------------
# RDS
#------------------------
output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "db_name" {
  value = module.rds.db_name
}

