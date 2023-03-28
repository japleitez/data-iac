data "aws_region" "current" {}

resource "aws_cloudwatch_log_stream" "data_collection_dashboard_log_stream" {
  name           = local.name
  log_group_name = var.log_group
}

data "template_file" "node" {
  template = file("${path.module}/template/selenium.json.tpl")

  vars = {
    name              = local.name
    app_image         = var.selenium_chrome_node_image
    app_port          = 5555
    fargate_cpu       = var.cpu
    fargate_memory    = var.memory
    aws_region        = data.aws_region.current.name
    log_group         = var.log_group
    stream_prefix     = local.name
    se_event_bus_host = var.se_event_bus_host
  }
}


resource "aws_ecs_task_definition" "node_task_definition" {
  family             = "${local.name}-ecs-task"
  execution_role_arn = var.ecs_task_execution_role
  #default for Fargate
  network_mode = "awsvpc"
  requires_compatibilities = [
  "FARGATE"]
  cpu                   = var.cpu
  memory                = var.memory
  container_definitions = data.template_file.node.rendered
  tags = merge(local.tags, {
    Name : "${local.name}-ecs-task"
  })

}

resource "aws_ecs_service" "node_service" {
  name            = "${local.name}-service"
  cluster         = var.selenium_cluster.id
  task_definition = aws_ecs_task_definition.node_task_definition.arn
  desired_count   = var.desired_count
  #default for Fargate
  launch_type    = "FARGATE"
  propagate_tags = "SERVICE"

  network_configuration {
    security_groups = [
    var.security_group_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  depends_on = [
  var.ecs_task_execution_role]

  tags = local.tags
}
