resource "aws_service_discovery_private_dns_namespace" "selenium_hub_discovery_namespace" {
  name        = local.hub_dns_zone
  description = "Discovery namespace for selenium hub"
  vpc         = var.vpc_id
  tags        = local.tags
}

resource "aws_service_discovery_service" "selenium_hub_service_discovery" {
  name = "service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.selenium_hub_discovery_namespace.id

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
