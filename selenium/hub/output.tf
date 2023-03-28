output "selenium_hub_dns_zone" {
  description = "The selenium hub dns zone"
  value       = module.service_discovery.service_discovery_dns_zone
}
