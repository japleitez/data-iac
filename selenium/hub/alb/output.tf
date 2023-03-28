output "selenium_target_group_id" {
  description = "The selenium target group"
  value = aws_alb_target_group.selenium_target_group.id
}

