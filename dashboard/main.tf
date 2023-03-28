resource "aws_route53_record" "www" {
  zone_id = var.aws_route53_zone_id
  name    = var.environment
  type    = "A"
  alias {
    name                   = module.load_balancer.dns_name
    zone_id                = module.load_balancer.zone_id
    evaluate_target_health = true
  }
}


module "load_balancer" {
  source                       = "../aws_alb"
  name                         = "${var.dashboard_name}-${var.environment}"
  playground_health_check_path = var.playground_health_check_path
  das_health_check_path        = var.das_health_check_path
  dashboard_health_check_path  = var.dashboard_health_check_path
  subnets                      = var.public_subnets
  vpc_id                       = var.vpc_id
  internal                     = false
  access_ips                   = var.access_ips
  tags                         = var.tags
  domain_name                  = var.domain_name
}

resource "aws_security_group_rule" "inbound" {
  description       = "Access to ECS Data Acquisition Service"
  protocol          = "tcp"
  from_port         = "8081"
  to_port           = "8081"
  cidr_blocks       = var.access_ips
  security_group_id = element(tolist(module.load_balancer.alb_security_group_ids), 0)
  type              = "ingress"
}

module "dashboard_security_group" {
  source               = "../aws_security"
  description          = "Allow inbound access from the ALB only"
  inbound_description  = "Allow inbound at port at dashboard port"
  outbound_description = "Allow all outbound"
  security_group_name  = "${var.dashboard_name}-${var.environment}-ecs"
  vpc_id               = var.vpc_id
  ingress_from_port    = module.dashboard_ecs_service.port
  ingress_to_port      = module.dashboard_ecs_service.port
  ingress_cidr_blocks  = [var.vpc_cidr_block]
  tags                 = var.tags
}

module "das_security_group" {
  source               = "../aws_security"
  description          = "Allow inbound access from the ALB only"
  inbound_description  = "Allow inbound at port at dashboard port"
  outbound_description = "Allow all outbound"
  security_group_name  = "${var.das_name}-${var.environment}-ecs"
  vpc_id               = var.vpc_id
  ingress_from_port    = module.das_ecs_service.port
  ingress_to_port      = module.das_ecs_service.port
  ingress_cidr_blocks  = [var.vpc_cidr_block]
  tags                 = var.tags
}

module "playground_security_group" {
  source               = "../aws_security"
  description          = "Allow inbound access from the ALB only"
  inbound_description  = "Allow inbound at port at dashboard port"
  outbound_description = "Allow all outbound"
  security_group_name  = "${var.playground_name}-${var.environment}-ecs"
  vpc_id               = var.vpc_id
  ingress_from_port    = module.playground_ecs_service.port
  ingress_to_port      = module.playground_ecs_service.port
  ingress_cidr_blocks  = [var.vpc_cidr_block]
  tags                 = var.tags
}

module "data_acquisition_db_sg" {
  source               = "../aws_security"
  description          = "Allow ECS access to DB"
  inbound_description  = "Allow inbound at port at dashboard port"
  outbound_description = "Allow all outbound"

  security_group_name = "das-${var.environment}-postgres"
  vpc_id              = var.vpc_id
  ingress_from_port   = "5432"
  ingress_to_port     = "5432"
  ingress_cidr_blocks = [var.vpc_cidr_block]
  tags                = var.tags
}

module "cloudwatch" {
  source      = "../aws_cloudwatch"
  group_name  = "${var.cloudwatch_group_name}-${var.environment}"
  stream_name = "${var.cloudwatch_stream_name}-${var.environment}"
  tags        = var.tags
}

module "fargate" {
  source      = "../aws_fargate"
  name        = "${var.cluster_name}-${var.environment}"
  environment = var.environment
  tags        = var.tags
}

module "dashboard_ecs_service" {
  source                        = "../aws_ecs_service"
  name                          = "${var.dashboard_name}-${var.environment}"
  ecs_security_group_ids        = [module.dashboard_security_group.aws_security_group_id]
  image                         = "${var.data_acquisition_dashboard_image}:${var.data_acquisition_dashboard_tag}"
  load_balancer_listener        = module.load_balancer.dashboard_listener
  load_balancer_target_group_id = module.load_balancer.dashboard_target_group_id
  private_subnets               = slice(var.private_subnets, 0, 2)
  tags                          = var.tags
  log_group                     = "${var.cloudwatch_group_name}-${var.environment}"
  stream_prefix                 = "${var.cloudwatch_stream_name}-${var.environment}"
  environment                   = var.environment
  cluster_id                    = module.fargate.cluster_id
  ecs_task_execution_role       = var.ecs_task_execution_role
  template                      = "./dashboard/templates/wihp_app.json.tpl"
  elasticsearch_endpoint        = var.elasticsearch_endpoint
  selenium_address              = "http://${var.selenium_address}"
  vpc_id                        = var.vpc_id
  auth_domain                   = var.auth_domain
  client_id                     = var.dashboard_client_id
  pool_id                       = var.pool_id
  client_secret                 = ""
}

module "das_ecs_service" {
  source                        = "../aws_ecs_service"
  port                          = 8081
  name                          = "${var.das_name}-${var.environment}"
  ecs_security_group_ids        = [module.das_security_group.aws_security_group_id]
  image                         = "${var.data_acquisition_service_image}:${var.data_acquisition_service_tag}"
  load_balancer_listener        = module.load_balancer.dashboard_listener
  load_balancer_target_group_id = module.load_balancer.das_target_group_id
  private_subnets               = slice(var.private_subnets, 0, 2)
  tags                          = var.tags
  log_group                     = "${var.cloudwatch_group_name}-${var.environment}"
  stream_prefix                 = "${var.cloudwatch_stream_name}-${var.environment}"
  environment                   = var.environment
  cluster_id                    = module.fargate.cluster_id
  ecs_task_execution_role       = var.ecs_task_execution_role
  template                      = "./dashboard/templates/data_acquisition_service.json.tpl"
  fargate_cpu                   = "1024"
  fargate_memory                = "2048"
  db_address                    = aws_db_instance.dataAcquisitionService.address
  spring_liquibase_contexts     = var.spring_liquibase_contexts[var.environment]
  db_name                       = local.db_name
  db_password                   = var.postgres_secrets[var.environment]
  elasticsearch_endpoint        = var.elasticsearch_endpoint
  selenium_address              = "http://${var.selenium_address}"
  vpc_id                        = var.vpc_id
  auth_domain                   = var.auth_domain
  client_id                     = var.data_acquisition_service_client_id
  pool_id                       = var.pool_id
  client_secret                 = var.data_acquisition_service_client_secret
  playground_host               = module.playground_ecs_service.service_host_name
  playground_port               = module.playground_ecs_service.port
}

module "playground_ecs_service" {
  source                        = "../aws_ecs_service"
  port                          = 8082
  name                          = "${var.playground_name}-${var.environment}"
  ecs_security_group_ids        = [module.playground_security_group.aws_security_group_id]
  image                         = "${var.playground_service_image}:${var.playground_service_tag}"
  load_balancer_listener        = module.load_balancer.dashboard_listener
  load_balancer_target_group_id = module.load_balancer.playground_target_group_id
  private_subnets               = slice(var.private_subnets, 0, 2)
  tags                          = var.tags
  log_group                     = "${var.cloudwatch_group_name}-${var.environment}"
  stream_prefix                 = "${var.cloudwatch_stream_name}-${var.environment}"
  environment                   = var.environment
  cluster_id                    = module.fargate.cluster_id
  ecs_task_execution_role       = var.ecs_task_execution_role
  template                      = "./dashboard/templates/playground_service.json.tpl"
  fargate_cpu                   = "1024"
  fargate_memory                = "2048"
  vpc_id                        = var.vpc_id
  auth_domain                   = var.auth_domain
  client_id                     = var.data_acquisition_service_client_id
  pool_id                       = var.pool_id
  client_secret                 = var.data_acquisition_service_client_secret
  selenium_address              = "http://${var.selenium_address}"
}

module "autoscaling" {
  source                  = "../aws_autoscaling"
  autoscaling_policy_name = "${var.dashboard_name}-${var.environment}"
  cluster_name            = module.fargate.cluster_name
  service_name            = module.dashboard_ecs_service.service_name
  tags                    = merge(var.tags, { Name : local.db_name })
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group_${var.environment}"
  subnet_ids = slice(var.private_subnets, 2, 4)
}

resource "aws_db_instance" "dataAcquisitionService" {
  name                        = local.db_name
  username                    = "dataAcquisitionService"
  password                    = var.postgres_secrets[var.environment]
  port                        = "5432"
  engine                      = "postgres"
  engine_version              = "12.10"
  instance_class              = var.instance_class_postgres[var.environment]
  allocated_storage           = var.allocated_storage_postgres[var.environment]
  storage_encrypted           = var.storage_encrypted_postgres[var.environment]
  vpc_security_group_ids      = [module.data_acquisition_db_sg.aws_security_group_id]
  db_subnet_group_name        = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name        = "default.postgres12"
  multi_az                    = var.multi_az_postgres[var.environment]
  publicly_accessible         = false
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  apply_immediately           = true
  storage_type                = var.storage_type_postgres[var.environment]
  skip_final_snapshot         = var.skip_final_snapshot_postgres[var.environment]
  final_snapshot_identifier   = "dataAcquisitionService-${var.environment}-backup-${local.timestamp_cleaned}"
  backup_retention_period     = var.backup_retention_period_postgres[var.environment]
  backup_window               = var.backup_window_postgres[var.environment]
  copy_tags_to_snapshot       = true
  snapshot_identifier         = var.postgres_snapshot_identifier

  tags = merge(var.tags, { Name : "postgresDB-${var.environment}" })
}

locals {
  db_name = "dataAcquisitionService_${var.environment}"
}
