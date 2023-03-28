data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "data_collection_dashboard_log_group" {
  #checkov:skip=CKV_AWS_158:No integration with KMS yet
  name              = local.name
  retention_in_days = 1
  tags              = local.tags
}

module "security_group" {
  source         = "./security_group"
  vpc_id         = var.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  environment    = var.environment
  tags           = var.tags
}

resource "aws_ecs_cluster" "selenium_cluster" {
  name = "${local.name}-cluster"
  #Default for security reasons
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = var.tags
}

module "selenium_hub" {
  source                  = "./hub"
  selenium_cluster        = aws_ecs_cluster.selenium_cluster
  security_group_id       = module.security_group.id
  access_ips              = var.access_ips
  ecs_task_execution_role = var.ecs_task_execution_role
  environment             = var.environment
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  tags                    = local.tags
  vpc_id                  = var.vpc_id
  log_group               = aws_cloudwatch_log_group.data_collection_dashboard_log_group.name
}

module "selenium_nodes" {
  source                  = "./node"
  selenium_cluster        = aws_ecs_cluster.selenium_cluster
  security_group_id       = module.security_group.id
  ecs_task_execution_role = var.ecs_task_execution_role
  environment             = var.environment
  private_subnets         = var.private_subnets
  tags                    = local.tags
  vpc_id                  = var.vpc_id
  log_group               = aws_cloudwatch_log_group.data_collection_dashboard_log_group.name
  se_event_bus_host       = module.selenium_hub.selenium_hub_dns_zone
}
