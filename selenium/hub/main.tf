data "aws_region" "current" {}

resource "aws_cloudwatch_log_stream" "data_collection_dashboard_log_stream" {
  name           = local.name
  log_group_name = var.log_group
}

data "template_file" "hub" {
  template = file("${path.module}/template/selenium.json.tpl")

  vars = {
    name           = local.name
    app_image      = var.selenium_hub_image
    app_port       = 4444
    fargate_cpu    = var.hub_cpu
    fargate_memory = var.hub_memory
    aws_region     = data.aws_region.current.name
    log_group      = var.log_group
    stream_prefix  = local.name
  }
}


resource "aws_ecs_task_definition" "hub_task_definition" {
  family             = "${local.name}-ecs-task"
  execution_role_arn = var.ecs_task_execution_role
  #default for Fargate
  network_mode = "awsvpc"
  requires_compatibilities = [
  "FARGATE"]
  cpu                   = var.hub_cpu
  memory                = var.hub_memory
  container_definitions = data.template_file.hub.rendered
  tags = merge(local.tags, {
    Name : "${local.name}-ecs-task"
  })

}

module "selenium_alb" {
  source      = "./alb"
  vpc_id      = var.vpc_id
  access_ips  = var.access_ips
  environment = var.environment
  subnets     = var.public_subnets
  tags        = local.tags
}

module "service_discovery" {
  source = "./service_discovery"

  environment = var.environment
  tags        = local.tags
  vpc_id      = var.vpc_id
}

resource "aws_ecs_service" "hub_service" {
  name            = "${local.name}-service"
  cluster         = var.selenium_cluster.id
  task_definition = aws_ecs_task_definition.hub_task_definition.arn
  desired_count   = var.desired_hub_count
  #default for Fargate
  launch_type    = "FARGATE"
  propagate_tags = "SERVICE"

  network_configuration {
    security_groups = [
    var.security_group_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.selenium_alb.selenium_target_group_id
    container_name   = local.name
    container_port   = 4444
  }

  service_registries {
    registry_arn = module.service_discovery.service_discovery_arn
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    module.selenium_alb.selenium_target_group_id,
  var.ecs_task_execution_role]

  tags = local.tags
}
