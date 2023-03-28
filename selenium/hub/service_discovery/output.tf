output "service_discovery_arn" {
  description = "The selenium service discovery arn"
  value       = aws_service_discovery_service.selenium_hub_service_discovery.arn
}

output "service_discovery_dns_zone" {
  description = "The selenium service discovery dns zone"
  value       = "${aws_service_discovery_service.selenium_hub_service_discovery.name}.${local.hub_dns_zone}"
}

