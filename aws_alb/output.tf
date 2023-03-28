output "application_load_balancer" {
  description = "The Application load balancer"
  value = aws_alb.this
}

output "dashboard_listener" {
  description = "The Dashboard listener"
  value = aws_alb_listener.dashboard_listener
}

output "dashboard_target_group_id" {
  description = "The Dashboard target group"
  value = aws_alb_target_group.dashboard_target_group.id
}

output "das_target_group_id" {
  description = "The Data Acquisition Service target group"
  value = aws_alb_target_group.das_target_group.id
}

output "playground_target_group_id" {
  description = "The Playground Service target group"
  value = aws_alb_target_group.playground_target_group.id
}

output "alb_security_group_ids" {
  description = "The Security group id"
  value =  aws_alb.this.security_groups
}

output "dns_name" {
  description = "The Security group id"
  value = aws_alb.this.dns_name
}

output "zone_id" {
  description = "The ELB Zone id"
  value = aws_alb.this.zone_id
}
