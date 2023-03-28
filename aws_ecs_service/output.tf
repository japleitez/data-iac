output "port" {
  description = "The application port"
  value       = var.port
}

output "service_name" {
  description = "The ECS service name"
  value       = aws_ecs_service.ecs_service.name
}

output "service_host_name" {
  description = "The internal host of the ecs service"
  value       = module.service_discovery.service_discovery_dns_zone
}
