output "alb_security_group_ids" {
  description = "The Application load balancer security group ids"
  value       = module.load_balancer.alb_security_group_ids
}

output "application_load_balancer_dns_name" {
  description = "The Application load balancer security group id"
  value       = module.load_balancer.dns_name
}

output "data_acquisition_service_host" {
  description = "The data acquisition service internal host name"
  value       = module.das_ecs_service.service_host_name
}

output "data_acquisition_service_port" {
  description = "The data acquisition service internal port"
  value       = module.das_ecs_service.port
}
