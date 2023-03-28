output "id" {
  description = "Security group ID for Selenium"
  value       = aws_security_group.selenium_alb_security_group.id
}
