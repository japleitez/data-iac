output "instance_id" {
  description = "SSH tunnelling port 80 using putty"
  value       = join("", [module.bastion.ssh_user, "@", module.bastion.public_ip])
}

output "elastic_search_endpoint" {
  description = "ElasticSearch endpoint"
  value       = module.elastic_search.endpoint
}
