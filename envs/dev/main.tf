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
  db_name = "tastylogdb"
}

#------------------------
# ecs fargate
#------------------------
# FargateはECSのサーバーレスコンテナサービス。ALBと連携して、インターネットからアクセス可能なアプリケーションをホスト。
module "fargate" {
  source = "../../modules/fargate"

  project              = local.project
  environment          = local.environment
  vpc_id               = module.vpc.vpc_id
  ecs_sg_id            = module.security_group.ecs_sg_id
  alb_target_group_arn = module.alb.target_group_arn
  execution_role_arn   = module.iam.execution_role_arn

  private_subnet_ids = [
    module.vpc.private_subnet_1a_id,
    module.vpc.private_subnet_1c_id
  ]

  depends_on     = [module.rds]
  repository_url = module.ecr.repository_url

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