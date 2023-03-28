data "aws_region" "current" {}

data "template_file" "storm_nimbus" {
  template = file("./storm/templates/nimbus.storm.json.tpl")

  vars = {
    storm_cpu           = var.storm_cpu
    storm_memory        = var.storm_memory
    storm_image         = var.storm_image
    nimbus_port         = var.nimbus_port
    hostname            = "storm.local.hostname=nimbus${count.index + 1}.${var.storm_dns_zone}"
    aws_region          = data.aws_region.current.name
    storm_log_group     = var.storm_log_group
    storm_stream_prefix = var.storm_stream_prefix
    zookeeper           = var.zookeeper_hostname
  }

  count = var.nimbus_instance_number
}

resource "aws_ecs_task_definition" "storm_nimbus" {
  family                = "${var.module_name}${count.index}-ecs-task"
  container_definitions = data.template_file.storm_nimbus[count.index].rendered
  execution_role_arn    = var.ecs_task_execution_role
  #default for Fargate
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.storm_cpu
  memory                   = var.storm_memory
  tags                     = merge(var.tags, { Name : "${var.module_name}${count.index}-ecs-task" })
  count                    = var.nimbus_instance_number
}

resource "aws_ecs_service" "storm_nimbus" {
  name                    = "${var.module_name}${count.index}-service"
  cluster                 = var.cluster_id
  task_definition         = aws_ecs_task_definition.storm_nimbus[count.index].arn
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
    registry_arn = aws_service_discovery_service.storm_nimbus.*.arn[count.index]
  }

  lifecycle {
    create_before_destroy = true
  }
  tags  = merge(var.tags, { Name : "${var.module_name}${count.index}-ecs-service" })
  count = var.nimbus_instance_number
}

resource "aws_service_discovery_service" "storm_nimbus" {
  name = "nimbus${count.index + 1}"

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
  count = var.nimbus_instance_number
}
