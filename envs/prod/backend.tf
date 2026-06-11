#-----------------
# Backend S3
#-----------------

terraform {
  backend "s3" {
    bucket  = "tastylog-tomo-terraform-state-575393967412"
    key     = "envs/prod/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform-tomo"
    encrypt = true
  }
}
