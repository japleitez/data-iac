output "selenium_address" {
  description = "The selenium hub address"
  value       = module.selenium_hub.selenium_hub_dns_zone
}
