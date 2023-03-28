resource "aws_service_discovery_private_dns_namespace" "storm_discovery_namespace" {
  name        = local.storm_dns_zone
  description = "Discovery namespace for storm"
  vpc         = var.vpc_id
  tags        = var.tags
}

data "aws_region" "current" {}

module "nimbus" {
  source                    = "./nimbus"
  cluster_id                = var.cluster_id
  ecs_task_execution_role   = var.ecs_task_execution_role
  environment               = var.environment
  private_subnets           = var.private_subnets
  storm_discovery_namespace = aws_service_discovery_private_dns_namespace.storm_discovery_namespace
  storm_dns_zone            = local.storm_dns_zone
  storm_log_group           = var.storm_log_group
  storm_stream_prefix       = var.storm_stream_prefix
  storm_security_group      = module.security_group.security_group
  storm_image               = var.storm_image
  zookeeper_hostname        = var.zookeeper_hostname
  tags                      = var.tags
}

module "ui" {
  source                    = "./ui"
  cluster_id                = var.cluster_id
  ecs_task_execution_role   = var.ecs_task_execution_role
  environment               = var.environment
  private_subnets           = var.private_subnets
  storm_discovery_namespace = aws_service_discovery_private_dns_namespace.storm_discovery_namespace
  storm_dns_zone            = local.storm_dns_zone
  storm_log_group           = var.storm_log_group
  storm_stream_prefix       = var.storm_stream_prefix
  storm_security_group      = module.security_group.security_group
  storm_image               = var.storm_image
  zookeeper_hostname        = var.zookeeper_hostname
  tags                      = var.tags
  public_subnets            = var.public_subnets
  vpc_id                    = var.vpc_id
  access_ips                = var.access_ips
}

module "supervisor" {
  source                    = "./supervisor"
  cluster_id                = var.cluster_id
  ecs_task_execution_role   = var.ecs_task_execution_role
  environment               = var.environment
  private_subnets           = var.private_subnets
  storm_discovery_namespace = aws_service_discovery_private_dns_namespace.storm_discovery_namespace
  storm_dns_zone            = local.storm_dns_zone
  storm_log_group           = var.storm_log_group
  storm_stream_prefix       = var.storm_stream_prefix
  storm_security_group      = module.security_group.security_group
  storm_image               = var.storm_image
  zookeeper_hostname        = var.zookeeper_hostname
  tags                      = var.tags
}

module "security_group" {
  source          = "./security_group"
  nimbus_port     = module.nimbus.port
  supervisor_port = module.supervisor.port
  ui_port         = module.ui.port
  worker1_port    = module.supervisor.worker_port1
  worker2_port    = module.supervisor.worker_port2
  worker3_port    = module.supervisor.worker_port3
  worker4_port    = module.supervisor.worker_port4
  vpc_id          = var.vpc_id
  vpc_cidr_block  = var.vpc_cidr_block
  tags            = var.tags
}
