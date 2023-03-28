module "alb_security_group" {
  source = "./security_group"
  vpc_id = var.vpc_id
  environment = var.environment
  tags = local.tags
  access_ips = var.access_ips
}

resource "aws_alb" "this" {
  #checkov:skip=CKV_AWS_150:Deletion protection is not enabled as we want to destroy our infrastructure for testing purposes
  #checkov:skip=CKV_AWS_91:Access logs is disabled until we create the S3 resources
  name            = local.name
  subnets         = var.subnets
  security_groups = [module.alb_security_group.id]
  drop_invalid_header_fields = var.drop_invalid_header_fields
  internal = var.internal
  tags = local.tags
}

resource "aws_alb_target_group" "selenium_target_group" {
  name        = "${local.name}-tg"
  port        = 80
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    protocol            = var.health_check_protocol
    matcher             = var.health_check_matcher
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    unhealthy_threshold = var.health_check_unhealthy_threshold
    port                = "4444"
  }

  tags = local.tags
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "selenium_listener" {
  load_balancer_arn = aws_alb.this.id
  port              = 80
  protocol          = var.listener_protocol

  default_action {
    target_group_arn = aws_alb_target_group.selenium_target_group.id
    type             = var.listener_default_action_type
  }

  tags = local.tags
}
