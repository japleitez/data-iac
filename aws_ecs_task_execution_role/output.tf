output "arn" {
  value = aws_iam_role.this.arn
  description = "The ARN of the ECS task execution IAM role"
}