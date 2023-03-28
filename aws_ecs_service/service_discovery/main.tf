resource "aws_service_discovery_private_dns_namespace" "discovery_namespace" {
  name        = local.dns_zone
  description = "Discovery namespace for ECS services"
  vpc         = var.vpc_id
  tags        = local.tags
}

resource "aws_service_discovery_service" "service_discovery" {
  name = "service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.discovery_namespace.id

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
