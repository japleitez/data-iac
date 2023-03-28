output "storm_listener" {
  description = "The Storm listener"
  value = aws_alb_listener.storm_listener
}

output "storm_target_group_id" {
  description = "The Storm target group"
  value = aws_alb_target_group.storm_target_group.id
}

output "alb_security_group_ids" {
  description = "The Security group id"
  value =  aws_alb.this.security_groups
}
