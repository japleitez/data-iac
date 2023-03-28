output "zookeeper_hostname" {
  description = "Zookeeper hostname"
  value       = "zookeeper1.${local.zookeeper_dns_zone}"
}
