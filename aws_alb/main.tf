# certificate
#  domain   = "wihp.ecdp.tech.ec.europa.eu"
data "aws_acm_certificate" "issued" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

module "alb_security_group" {
  source               = ".././aws_security"
  description          = "Controls access to the AL"
  inbound_description  = "Allow inbound at port 443"
  outbound_description = "Allow all outbound"
  security_group_name  = "${var.name}-load-balancer"
  ingress_cidr_blocks  = var.access_ips
  vpc_id               = var.vpc_id
  tags                 = var.tags
}

resource "aws_alb" "this" {
  #checkov:skip=CKV_AWS_150:Deletion protection is not enabled as we want to destroy our infrastructure for testing purposes
  #checkov:skip=CKV_AWS_91:Access logs is disabled until we create the S3 resources
  name                       = "${var.name}-lb"
  subnets                    = var.subnets
  security_groups            = concat(var.security_groups, [module.alb_security_group.aws_security_group_id])
  drop_invalid_header_fields = var.drop_invalid_header_fields
  internal                   = var.internal
  tags                       = merge(var.tags, { Name : "${var.name}-load-balancer" })
}

resource "aws_alb_target_group" "dashboard_target_group" {
  name        = "${var.name}-dad-tg"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    protocol            = var.health_check_protocol
    matcher             = var.health_check_matcher
    timeout             = var.health_check_timeout
    path                = var.dashboard_health_check_path
    unhealthy_threshold = var.health_check_unhealthy_threshold
    port                = "8080"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, { Name : "${var.name}-dashboard-target-group" })
}

resource "aws_alb_target_group" "das_target_group" {
  name        = "${var.name}-das-tg"
  port        = var.das_target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    protocol            = var.health_check_protocol
    matcher             = var.health_check_matcher
    timeout             = var.health_check_timeout
    path                = var.das_health_check_path
    unhealthy_threshold = var.health_check_unhealthy_threshold
    port                = "8081"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, { Name : "${var.name}-dashboard-target-group" })
}

resource "aws_alb_target_group" "playground_target_group" {
  name        = "${var.name}-plg-tg"
  port        = var.playground_target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    protocol            = var.health_check_protocol
    matcher             = var.health_check_matcher
    timeout             = var.health_check_timeout
    path                = var.playground_health_check_path
    unhealthy_threshold = var.health_check_unhealthy_threshold
    port                = "8082"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, { Name : "${var.name}-dashboard-target-group" })
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "dashboard_listener" {
  load_balancer_arn = aws_alb.this.arn
  port              = var.dashboard_listener_port
  protocol          = var.listener_protocol
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    target_group_arn = aws_alb_target_group.dashboard_target_group.id
    type             = var.listener_default_action_type
  }

  tags = merge(var.tags, { Name : "${var.name}-dashboard-listener" })
}

resource "aws_alb_listener_rule" "report_rule" {
  listener_arn = aws_alb_listener.dashboard_listener.arn
  priority     = 99

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }

  condition {
    path_pattern {
      values = ["/das/api/acquisitions/*/report"]
    }
  }
}

resource "aws_alb_listener_rule" "api_das_rule" {
  listener_arn = aws_alb_listener.dashboard_listener.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.das_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/das/*"]
    }
  }
}

resource "aws_alb_listener_rule" "api_playground_rule" {
  listener_arn = aws_alb_listener.dashboard_listener.arn
  priority     = 105

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.playground_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/playground/*"]
    }
  }
}

resource "aws_alb_listener" "http_to_https" {
  load_balancer_arn = aws_alb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(var.tags, { Name : "${var.name}-http_to_https" })
}
