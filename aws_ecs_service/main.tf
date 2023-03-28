data "aws_region" "current" {}

module "service_discovery" {
  source = "./service_discovery"

  environment = var.environment
  tags        = merge(var.tags, { Name : "${var.name}-discovery" })
  vpc_id      = var.vpc_id
  module_name = var.name
}

data "template_file" "wihp_app" {
  template = file(var.template)

  vars = {
    name                      = var.name
    app_image                 = var.image
    app_port                  = var.port
    fargate_cpu               = var.fargate_cpu
    fargate_memory            = var.fargate_memory
    aws_region                = data.aws_region.current.name
    log_group                 = var.log_group
    stream_prefix             = var.stream_prefix
    db_address                = var.db_address
    db_name                   = var.db_name
    db_password               = var.db_password
    spring_liquibase_contexts = var.spring_liquibase_contexts
    elasticsearch_endpoint    = var.elasticsearch_endpoint
    nimbus1                   = "nimbus1.storm.${var.environment}"
    nimbus2                   = "nimbus2.storm.${var.environment}"
    selenium_address          = var.selenium_address
    environment               = var.environment
    report_address            = module.service_discovery.service_discovery_dns_zone
    auth_domain               = var.auth_domain
    client_id                 = var.client_id
    client_secret             = var.client_secret
    pool_id                   = var.pool_id
    scope                     = local.scope[var.environment]
    playground_host           = var.playground_host
    playground_port           = var.playground_port
  }
}


resource "aws_ecs_task_definition" "task_definition" {
  family             = "${var.name}-ecs-task"
  execution_role_arn = var.ecs_task_execution_role
  #default for Fargate
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.wihp_app.rendered
  tags                     = merge(var.tags, { Name : "${var.name}-ecs-task" })

}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.desired_count
  #default for Fargate
  launch_type    = "FARGATE"
  propagate_tags = "SERVICE"

  network_configuration {
    security_groups  = var.ecs_security_group_ids
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  service_registries {
    registry_arn = module.service_discovery.service_discovery_arn
  }

  load_balancer {
    target_group_arn = var.load_balancer_target_group_id
    container_name   = var.name
    container_port   = var.port
  }

  depends_on = [var.load_balancer_listener, var.ecs_task_execution_role]

  tags = merge(var.tags, { Name : "${var.name}-ecs-service" })
}
