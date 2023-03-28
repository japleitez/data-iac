data "aws_route53_zone" "main" {
  zone_id = "Z08783571RQ4KN5Z6MXXC"
}

module "wihp_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "${var.vpc_name}_${var.environment}"
  cidr = var.vpc_cidr[var.environment]

  azs             = var.availability_zones
  private_subnets = [for index in range(local.available_subnet) : cidrsubnet(var.vpc_cidr[var.environment], 8, index)]
  public_subnets  = [for index in range(length(var.availability_zones)) : cidrsubnet(var.vpc_cidr[var.environment], 8, local.available_subnet + index)]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true

  tags = local.default_tags
}

resource "aws_route" "r" {
  count                     = var.enable_vpc_peering_connection[var.environment]
  route_table_id            = module.wihp_vpc.private_route_table_ids[0]
  destination_cidr_block    = local.datalab_cidr_block
  vpc_peering_connection_id = var.vpc_peering_connection_id[var.environment]
}

module "ecs_task_execution_role" {
  source      = "./ecs_task_execution_role"
  environment = var.environment
  tags        = local.default_tags
}

module "elastic_search" {
  source           = "./elasticsearch"
  environment      = var.environment
  private_subnets  = module.wihp_vpc.private_subnets
  tags             = local.default_tags
  vpc_id           = module.wihp_vpc.vpc_id
  https_cidr_block = local.elastic_search_https_cidr_block[var.environment]
  ssh_cidr_block   = local.elastic_search_ssh_cidr_block[var.environment]
}

module "dashboard" {
  source                                 = "./dashboard"
  private_subnets                        = module.wihp_vpc.private_subnets
  public_subnets                         = module.wihp_vpc.public_subnets
  vpc_id                                 = module.wihp_vpc.vpc_id
  vpc_cidr_block                         = module.wihp_vpc.vpc_cidr_block
  tags                                   = local.default_tags
  environment                            = var.environment
  aws_route53_zone_id                    = data.aws_route53_zone.main.zone_id
  domain_name                            = data.aws_route53_zone.main.name
  access_ips                             = local.access_ips[var.environment]
  elasticsearch_endpoint                 = module.elastic_search.endpoint
  selenium_address                       = module.selenium.selenium_address
  ecs_task_execution_role                = module.ecs_task_execution_role.arn
  auth_domain                            = var.oauth_auth_domain[var.environment]
  dashboard_client_id                    = var.oauth_dashboard_client_id[var.environment]
  data_acquisition_service_client_id     = var.oauth_data_acquisition_service_client_id[var.environment]
  data_acquisition_service_client_secret = var.oauth_data_acquisition_service_client_secret[var.environment]
  playground_service_client_id           = var.oauth_playground_service_client_id[var.environment]
  playground_service_client_secret       = var.oauth_playground_service_client_secret[var.environment]
  pool_id                                = var.oauth_pool_id[var.environment]
  postgres_secrets                       = local.postgres_secrets_tf
  postgres_snapshot_identifier           = var.db_snapshot_identifier
  data_acquisition_service_tag           = var.data_acquisition_service_tag
  playground_service_tag                 = var.playground_service_tag
  data_acquisition_dashboard_tag         = var.data_acquisition_dashboard_tag
}

module "storm_cluster" {
  source      = "./aws_fargate"
  name        = "storm-${var.environment}"
  environment = var.environment
  tags        = local.default_tags
}

module "storm_cloudwatch" {
  source      = "./aws_cloudwatch"
  group_name  = "${var.storm_log_group_name}-${var.environment}"
  stream_name = "${var.storm_log_stream_prefix}-${var.environment}"
  tags        = local.default_tags
}

module "zookeeper" {
  source                  = "./zookeeper"
  vpc_id                  = module.wihp_vpc.vpc_id
  vpc_cidr_block          = module.wihp_vpc.vpc_cidr_block
  ecs_task_execution_role = module.ecs_task_execution_role.arn
  environment             = var.environment
  private_subnets         = module.wihp_vpc.private_subnets
  cluster_id              = module.storm_cluster.cluster_id
  zookeeper_log_group     = module.storm_cloudwatch.cloudwatch_name
  zookeeper_stream_prefix = module.storm_cloudwatch.cloudwatch_stream_name
  tags                    = local.default_tags
  depends_on              = [module.dashboard]
}

module "storm" {
  source                  = "./storm"
  vpc_id                  = module.wihp_vpc.vpc_id
  vpc_cidr_block          = module.wihp_vpc.vpc_cidr_block
  aws_route53_zone_name   = data.aws_route53_zone.main.name
  cluster_id              = module.storm_cluster.cluster_id
  ecs_task_execution_role = module.ecs_task_execution_role.arn
  environment             = var.environment
  private_subnets         = module.wihp_vpc.private_subnets
  storm_log_group         = module.storm_cloudwatch.cloudwatch_name
  storm_stream_prefix     = module.storm_cloudwatch.cloudwatch_stream_name
  zookeeper_hostname      = module.zookeeper.zookeeper_hostname
  tags                    = local.default_tags
  depends_on              = [module.zookeeper]
  access_ips              = local.access_ips[var.environment]
  public_subnets          = module.wihp_vpc.public_subnets
}

module "selenium" {
  source                  = "./selenium"
  access_ips              = local.access_ips[var.environment]
  ecs_task_execution_role = module.ecs_task_execution_role.arn
  environment             = var.environment
  public_subnets          = module.wihp_vpc.public_subnets
  private_subnets         = module.wihp_vpc.private_subnets
  tags                    = local.default_tags
  vpc_id                  = module.wihp_vpc.vpc_id
  vpc_cidr_block          = module.wihp_vpc.vpc_cidr_block
}

module "bastion_key_pair" {
  source         = "./aws_key"
  key_name       = "bastion_${var.environment}"
  ssh_public_key = local.bastions_key[var.environment]
  tags           = local.default_tags
}


module "bastion" {
  source = "git::https://git.fpfis.eu/datateam/ecdp-infra/aws/bastion.git//?ref=master"

  subnet          = module.wihp_vpc.public_subnets[0]
  vpc_id          = module.wihp_vpc.vpc_id
  security_groups = module.dashboard.alb_security_group_ids

  project     = "WIHP"
  environment = var.environment
  name        = "WIHP_Bastion_${var.environment}"
  key_name    = module.bastion_key_pair.aws_key_pair_name
  ssh_user    = "ec2-user"

  depends_on = []
}

module "mwaa" {
  source                        = "./modules/mwaa"
  environment                   = var.environment
  vpc_id                        = module.wihp_vpc.vpc_id
  access_ips                    = local.access_ips[var.environment]
  public_subnets                = module.wihp_vpc.public_subnets
  private_subnets               = slice(module.wihp_vpc.private_subnets, 0, 2)
  tags                          = local.default_tags
  client_id                     = var.mwaa_client_ids[var.environment]
  client_secret                 = var.mwaa_client_secrets[var.environment]
  data_acquisition_service_host = module.dashboard.data_acquisition_service_host
  data_acquisition_service_port = module.dashboard.data_acquisition_service_port
  oauth_host                    = var.oauth_auth_domain[var.environment]
  oauth_port                    = 443
}
