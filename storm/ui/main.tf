data "aws_region" "current" {}


#######################################################
#######################################################
###########             UI            #################
#######################################################
#######################################################
data "template_file" "storm_ui" {
  template = file("./storm/templates/ui.storm.json.tpl")

  vars = {
    name                = "ui-storm-${var.environment}"
    storm_cpu           = var.storm_cpu
    storm_memory        = var.storm_memory
    storm_image         = var.storm_image
    ui_port             = var.ui_port
    hostname            = "storm.local.hostname=ui.${var.storm_dns_zone}"
    aws_region          = data.aws_region.current.name
    storm_log_group     = var.storm_log_group
    storm_stream_prefix = var.storm_stream_prefix
    zookeeper           = var.zookeeper_hostname
    nimbus1             = "nimbus1.storm.${var.environment}"
    nimbus2             = "nimbus2.storm.${var.environment}"
  }
}

resource "aws_ecs_task_definition" "storm_ui" {
  family                = "${var.module_name}-ecs-task"
  container_definitions = data.template_file.storm_ui.rendered
  execution_role_arn    = var.ecs_task_execution_role
  #default for Fargate
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.storm_cpu
  memory                   = var.storm_memory
  tags                     = merge(var.tags, { Name : "${var.module_name}-ecs-task" })
}

resource "aws_ecs_service" "storm_ui" {
  name                    = "${var.module_name}-service"
  cluster                 = var.cluster_id
  task_definition         = aws_ecs_task_definition.storm_ui.arn
  enable_ecs_managed_tags = true
  desired_count           = 1
  launch_type             = "FARGATE"
  propagate_tags          = "SERVICE"
  # only manual task rotation via task stop
  deployment_minimum_healthy_percent = 100
  # deployment_maximum_percent         = 100
  network_configuration {
    subnets          = [element(var.private_subnets, 2)]
    security_groups  = [var.storm_security_group.id]
    assign_public_ip = false
  }
  service_registries {
    registry_arn = aws_service_discovery_service.storm_ui.arn
  }

  load_balancer {
    target_group_arn = module.load_balancer.storm_target_group_id
    container_name   = "ui-storm-${var.environment}"
    container_port   = 8080
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = merge(var.tags, { Name : "ui-${var.module_name}-ecs-service" })

  depends_on = [module.load_balancer.storm_listener, var.ecs_task_execution_role]
}

resource "aws_service_discovery_service" "storm_ui" {
  name = "ui"

  dns_config {
    namespace_id = var.storm_discovery_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 10
  }
}

module "load_balancer" {
  source            = "./alb"
  name              = "ui-storm-${var.environment}"
  health_check_path = "/"
  subnets           = var.public_subnets
  vpc_id            = var.vpc_id
  access_ips        = var.access_ips
  internal          = false
  tags              = var.tags
}
