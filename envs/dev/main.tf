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
module "vpc" {
  source = "../../modules/network"

  project                             = "tastylog-tomo"
  environment                         = "dev"
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

  project     = "tastylog-tomo"
  environment = "dev"
  vpc_id      = module.vpc.vpc_id
}

#------------------------
# Route53
#------------------------
module "route53" {
  source = "../../modules/Route53"

  project       = "tastylog-tomo"
  environment   = "dev"
  zone_domain   = "gotomo-lab.click"
  record_domain = "dev.gotomo-lab.click"
}

#------------------------
# ACM
#------------------------
module "acm" {
  source = "../../modules/ACM"

  project       = "tastylog-tomo"
  environment   = "dev"
  record_domain = "dev.gotomo-lab.click"
  zone_domain   = "gotomo-lab.click"
  depends_on    = [module.route53]
}

#------------------------
# rds
#------------------------
module "rds" {
  source = "../../modules/rds"

  project     = "tastylog-tomo"
  environment = "dev"
  vpc_id      = module.vpc.vpc_id

  db_sg_id = module.security_group.db_sg_id
  subnet_ids = [
    module.vpc.private_subnet_1a_id,
    module.vpc.private_subnet_1c_id
  ]
  db_name = "tastylogdb"
}
