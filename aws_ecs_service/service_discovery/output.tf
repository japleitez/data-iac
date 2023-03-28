output "service_discovery_arn" {
  description = "The service discovery arn"
  value       = aws_service_discovery_service.service_discovery.arn
}

output "service_discovery_dns_zone" {
  description = "The service discovery dns zone"
  value       = "${aws_service_discovery_service.service_discovery.name}.${local.dns_zone}"
}

