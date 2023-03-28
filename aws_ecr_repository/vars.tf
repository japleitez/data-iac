variable "name" {
  description = "The name for the ECR"
  type = string
}
variable "tags" {
  description = "Tags for the ECR"
  type        = map(string)
}