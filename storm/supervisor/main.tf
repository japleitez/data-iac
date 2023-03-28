data "aws_region" "current" {}

data "template_file" "storm_supervisor" {
  template = file("./storm/templates/supervisor.storm.json.tpl")

  vars = {
    storm_cpu           = var.storm_cpu
    storm_memory        = var.storm_memory
    storm_image         = var.storm_image
    supervisor_port     = var.supervisor_port
    worker_port_1       = var.worker_port_1
    worker_port_2       = var.worker_port_2
    worker_port_3       = var.worker_port_3
    worker_port_4       = var.worker_port_4
    hostname            = "storm.local.hostname=supervisor${count.index + 1}.${var.storm_dns_zone}"
    aws_region          = data.aws_region.current.name
    storm_log_group     = var.storm_log_group
    storm_stream_prefix = var.storm_stream_prefix
    zookeeper           = var.zookeeper_hostname
    nimbus1             = "nimbus1.storm.${var.environment}"
    nimbus2             = "nimbus2.storm.${var.environment}"
  }

  count = var.supervisor_instance_number
}

resource "aws_ecs_task_definition" "storm_supervisor" {
  family                = "${var.module_name}${count.index}-ecs-task"
  container_definitions = data.template_file.storm_supervisor[count.index].rendered
  execution_role_arn    = var.ecs_task_execution_role
  #default for Fargate
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.storm_cpu
  memory                   = var.storm_memory
  tags                     = merge(var.tags, { Name : "${var.module_name}${count.index}-ecs-task" })
  count                    = var.supervisor_instance_number
}

resource "aws_ecs_service" "storm_supervisor" {
  name                    = "${var.module_name}${count.index}-service"
  cluster                 = var.cluster_id
  task_definition         = aws_ecs_task_definition.storm_supervisor[count.index].arn
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
    registry_arn = aws_service_discovery_service.storm_supervisor.*.arn[count.index]
  }

  lifecycle {
    create_before_destroy = true
  }
  tags  = merge(var.tags, { Name : "${var.module_name}${count.index}-ecs-service" })
  count = var.supervisor_instance_number
}

resource "aws_service_discovery_service" "storm_supervisor" {
  name = "supervisor${count.index + 1}"

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
  count = var.supervisor_instance_number
}
