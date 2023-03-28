output "aws_key_pair_name" {
  value = aws_key_pair.this.key_name
  description = "The AWS key pair"
}