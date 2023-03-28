data "aws_region" "current" {}

resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"
  #Default for security reasons
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = merge(var.tags, { Name : "${var.name}-ecs-cluster" })
}
