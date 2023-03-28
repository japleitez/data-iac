resource "aws_service_discovery_private_dns_namespace" "zookeeper_discovery_namespace" {
  name        = local.zookeeper_dns_zone
  description = "Discovery namespace for zookeeper"
  vpc         = var.vpc_id
  tags        = var.tags
}
data "aws_region" "current" {}

data "template_file" "ecs-zookeeper" {
  template = file("./zookeeper/templates/zookeeper.json.tpl")

  vars = {
    zookeeper_cpu                    = var.zookeeper_cpu
    zookeeper_memory                 = var.zookeeper_memory
    zookeeper_image                  = var.zookeeper_image
    zookeeper_port                   = var.zookeeper_port
    zookeeper_port_communication     = var.zookeeper_port_communication
    zookeeper_port_election          = var.zookeeper_port_election
    zookeeper_servers                = local.zookeeper_servers
    zookeeper_elect_port_retry       = var.zookeeper_elect_port_retry
    zookeeper_4lw_commands_whitelist = var.zookeeper_4lw_commands_whitelist
    aws_region                       = data.aws_region.current.name
    zookeeper_log_group              = var.zookeeper_log_group
    zookeeper_stream_prefix          = var.zookeeper_stream_prefix
    myid                             = count.index + 1
  }

  count = var.zookeeper_instance_number
}

resource "aws_ecs_task_definition" "ecs_zookeeper" {
  family                = "${var.module_name}-${count.index}-ecs-task"
  container_definitions = data.template_file.ecs-zookeeper[count.index].rendered

  execution_role_arn = var.ecs_task_execution_role
  #default for Fargate
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.zookeeper_cpu
  memory                   = var.zookeeper_memory
  tags                     = merge(var.tags, { Name : "${var.module_name}${count.index}-ecs-task" })
  count                    = var.zookeeper_instance_number
}

resource "aws_ecs_service" "ecs_zookeeper" {
  name                    = "${var.module_name}-service-${count.index + 1}"
  cluster                 = var.cluster_id
  task_definition         = aws_ecs_task_definition.ecs_zookeeper[count.index].arn
  enable_ecs_managed_tags = true
  desired_count           = 1
  launch_type             = "FARGATE"
  propagate_tags          = "SERVICE"
  # only manual task rotation via task stop
  deployment_minimum_healthy_percent = 100
  # deployment_maximum_percent         = 100
  network_configuration {
    subnets          = [element(var.private_subnets, 2)]
    security_groups  = [aws_security_group.zookeeper_sg.id]
    assign_public_ip = false
  }
  service_registries {
    registry_arn = aws_service_discovery_service.discovery_service_zookeeper.*.arn[count.index]
  }

  lifecycle {
    create_before_destroy = true
  }
  tags  = merge(var.tags, { Name : "${var.module_name}${count.index}-ecs-service" })
  count = var.zookeeper_instance_number
}

resource "aws_service_discovery_service" "discovery_service_zookeeper" {
  name = "${var.module_name}${count.index + 1}"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.zookeeper_discovery_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 10
  }
  count = var.zookeeper_instance_number
}

resource "aws_security_group" "zookeeper_sg" {
  name        = "${var.module_name}-sg"
  description = "Zookeeper secuirty group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name : "${var.module_name}-sg" })
}

resource "aws_security_group_rule" "inbound_zookeeper_port" {
  description       = "Ingress Zookeeper port"
  protocol          = "tcp"
  from_port         = var.zookeeper_port
  to_port           = var.zookeeper_port
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.zookeeper_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_zookeeper_port_communication" {
  description       = "Ingress Zookeeper port communication"
  protocol          = "tcp"
  from_port         = var.zookeeper_port_communication
  to_port           = var.zookeeper_port_communication
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.zookeeper_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_zookeeper_port_election" {
  description       = "Ingress Zookeeper port election"
  protocol          = "tcp"
  from_port         = var.zookeeper_port_election
  to_port           = var.zookeeper_port_election
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.zookeeper_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_outbound" {
  description       = "Zookeeper allow all outbound"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.zookeeper_sg.id
  type              = "egress"
}
