#-----------------
# Local variables
#-----------------
locals {
  #プロジェクト名
  project = "tastylog-tomo"

  #環境名
  environment = "dev"

  #domain
  zone_domain   = "gotomo-lab.click"
  record_domain = "dev.gotomo-lab.click"

  ecs_service_name   = "${local.project}-${local.environment}-app-service"
  ecs_log_group_name = "/ecs/${local.project}-${local.environment}-app"
}
