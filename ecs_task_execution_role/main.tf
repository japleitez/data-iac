data "aws_region" "current" {}

module "ecs_task_execution_role" {
  source = "../aws_ecs_task_execution_role"
  name   = "${var.ecs_task_execution_role_name}_${var.environment}"
  tags   = var.tags
}
