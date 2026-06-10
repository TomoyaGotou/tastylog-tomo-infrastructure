#------------------------
# Terraform　configuration
#------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "terraform-tomo"
  region  = "ap-northeast-1"
}

#cloudfrontのACM証明書はバージニアリージョンで発行する必要があるため、プロバイダを追加
provider "aws" {
  alias   = "virginia"
  profile = "terraform-tomo"
  region  = "us-east-1"
}

#------------------------
# Network
#------------------------
# VPCとサブネットを作成 azの工夫必要
module "vpc" {
  source = "../../modules/network"

  project                             = local.project
  environment                         = local.environment
  vpc_cidr_block                      = "10.0.0.0/16"
  public_subnet_1a_cidr_block         = "10.0.1.0/24"
  public_subnet_1c_cidr_block         = "10.0.2.0/24"
  public_subnet_1a_availability_zone  = "ap-northeast-1a"
  public_subnet_1c_availability_zone  = "ap-northeast-1c"
  private_subnet_1a_cidr_block        = "10.0.3.0/24"
  private_subnet_1c_cidr_block        = "10.0.4.0/24"
  private_subnet_1a_availability_zone = "ap-northeast-1a"
  private_subnet_1c_availability_zone = "ap-northeast-1c"
  region                              = "ap-northeast-1"
  #vpc_endpoint_sg_id                 = ${module.security_group.vpce_sg_id}
}

#------------------------
# security group
#------------------------
module "security_group" {
  source = "../../modules/security_group"

  project     = local.project
  environment = local.environment
  vpc_id      = module.vpc.vpc_id
}

#------------------------
# Route53
#------------------------
module "route53" {
  source = "../../modules/Route53"

  project       = local.project
  environment   = local.environment
  zone_domain   = local.zone_domain
  record_domain = local.record_domain
}

#------------------------
# ACM
#------------------------
# ACMはALBのSSL証明書に使用。Route53でドメインを管理しているため、DNS検証を使用して証明書を発行。
module "acm" {
  source = "../../modules/ACM"

  providers = {
    aws          = aws
    aws.virginia = aws.virginia
  }

  project       = local.project
  environment   = local.environment
  record_domain = "dev.gotomo-lab.click"
  zone_domain   = "gotomo-lab.click"
  depends_on    = [module.route53]
}

#------------------------
# rds
#------------------------
# RDSはAurora MySQLを使用。プライベートサブネットに配置し、セキュリティグループでアクセスを制限。
module "rds" {
  source = "../../modules/rds"

  project     = local.project
  environment = local.environment
  vpc_id      = module.vpc.vpc_id

  db_sg_id = module.security_group.db_sg_id
  subnet_ids = [
    module.vpc.private_subnet_1a_id,
    module.vpc.private_subnet_1c_id
  ]
  db_name     = "tastylogdb"
  db_username = "admin"
}

#------------------------
# SSM
#------------------------
module "ssm" {
  source = "../../modules/ssm"

  project       = local.project
  environment   = local.environment
  record_domain = local.record_domain

  db_host     = module.rds.db_host
  db_database = module.rds.db_name
  db_password = module.rds.db_password
  db_username = module.rds.db_username

  app_key = var.app_key
  app_url = "https://${local.record_domain}"
}

#------------------------
# ecs fargate
#------------------------
# FargateはECSのサーバーレスコンテナサービス。ALBと連携して、インターネットからアクセス可能なアプリケーションをホスト。
module "fargate" {
  source = "../../modules/fargate"

  project              = local.project
  environment          = local.environment
  repository_url       = module.ecr.repository_url
  vpc_id               = module.vpc.vpc_id
  ecs_sg_id            = module.security_group.ecs_sg_id
  alb_target_group_arn = module.alb.target_group_arn
  execution_role_arn   = module.iam.execution_role_arn
  task_role_arn        = module.iam.task_role_arn
  db_host_arn          = module.ssm.db_host_arn
  db_database_arn      = module.ssm.db_database_arn
  db_username_arn      = module.ssm.db_username_arn
  db_password_arn      = module.ssm.db_password_arn
  db_port_arn          = module.ssm.db_port_arn
  app_key_arn          = module.ssm.app_key_arn
  app_url_arn          = module.ssm.app_url_arn

  aws_region         = "ap-northeast-1"
  ecs_log_group_name = local.ecs_log_group_name

  private_subnet_ids = [
    module.vpc.private_subnet_1a_id,
    module.vpc.private_subnet_1c_id
  ]

  depends_on = [
    module.rds
  ]
}

#------------------------
# ecr
#------------------------
# ECRはコンテナイメージのレジストリサービス。Fargateタスクで使用するアプリケーションのイメージを格納。
module "ecr" {
  source = "../../modules/ecr"

  project     = local.project
  environment = local.environment
}

#------------------------
# alb
#------------------------
#Cloudfront→ALB。ACMで発行したSSL証明書を使用してHTTPS通信を提供。
module "alb" {
  source = "../../modules/alb"

  project     = local.project
  environment = local.environment
  vpc_id      = module.vpc.vpc_id

  alb_sg_id           = module.security_group.alb_sg_id
  acm_certificate_arn = module.acm.certificate_arn

  public_subnet_ids = [
    module.vpc.public_subnet_1a_id,
    module.vpc.public_subnet_1c_id
  ]
  depends_on = [module.route53]
}

#------------------------
# iam
#------------------------
module "iam" {
  source = "../../modules/iam"

  project     = local.project
  environment = local.environment
}

#------------------------
# CloudFront
#------------------------
#
module "cloudfront" {
  source = "../../modules/cloudfront"

  project     = local.project
  environment = local.environment

  record_domain = local.record_domain
  zone_domain   = local.zone_domain
  origin_id     = "${local.project}-${local.environment}-alb-origin"

  alb_dns_name        = module.alb.dns_name
  acm_certificate_arn = module.acm.cloudfront_certificate_arn
  waf_acl_arn         = module.waf.web_acl_arn
}

#------------------------
# route53 record
#------------------------
# CloudFrontのドメインをRoute53のAレコードとして登録するモジュール。
module "route53_record" {
  source = "../../modules/route53_record"

  project     = local.project
  environment = local.environment

  record_domain             = local.record_domain
  zone_domain               = local.zone_domain
  cloudfront_domain_name    = module.cloudfront.domain_name
  cloudfront_hosted_zone_id = module.cloudfront.hosted_zone_id
  alb_dns_name              = module.alb.dns_name
  alb_zone_id               = module.alb.zone_id
}

#------------------------
# waf
#------------------------
# WAFはAWSのWeb Application Firewallサービス。CloudFrontディストリビューションに
module "waf" {
  source = "../../modules/waf"

  providers = {
    aws.virginia = aws.virginia
  }

  project         = local.project
  environment     = local.environment
  waf_name        = "${local.project}-${local.environment}-waf"
  waf_description = "${local.project}-${local.environment}-waf-acl"
}

#------------------------
# S3
#------------------------
#artifact-bucket用　
module "s3" {
  source = "../../modules/s3"

  bucket_name = "${local.project}-${local.environment}-pipeline-artifact-bucket"
}


#------------------------
# codebuild 
#------------------------
#
module "codebuild" {
  source = "../../modules/codebuild"

  project            = local.project
  environment        = local.environment
  codebuild_role_arn = module.iam.codebuild_role_arn
  repository_url     = module.ecr.repository_url
  container_name     = "${local.project}-${local.environment}-app-container"
  ecs_cluster_name   = module.fargate.ecs_cluster_name

  private_subnet_id_1       = module.vpc.private_subnet_1a_id
  private_subnet_id_2       = module.vpc.private_subnet_1c_id
  ecs_sg_id                 = module.security_group.ecs_sg_id
  migration_task_definition = "${local.project}-${local.environment}-app-task"
}

#------------------------
# codepipeline
#------------------------

module "codepipeline" {
  source = "../../modules/codepipeline"

  project                  = local.project
  environment              = local.environment
  github_repository_name   = "tastylog-tomo-app"
  github_branch_name       = "dev"
  codepipeline_role_arn    = module.iam.codepipeline_role_arn
  codebuild_project_name   = module.codebuild.codebuild_project_name
  pipeline_artifact_bucket = module.s3.bucket_name
  ecs_cluster_name         = module.fargate.ecs_cluster_name
  ecs_service_name         = module.fargate.ecs_service_name
}


#------------------------
# cloudwatch
#------------------------
module "cloudwatch" {
  source = "../../modules/cloudwatch"

  project     = local.project
  environment = local.environment

  alarm_email = "n0m3298m0n@gmail.com"

  ecs_cluster_name = module.fargate.cluster_name
  ecs_service_name = local.ecs_service_name

  alb_arn_suffix = module.alb.alb_arn_suffix

  cloudfront_distribution_id = module.cloudfront.distribution_id
}
