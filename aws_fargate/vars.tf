variable "environment" {
  description = "The environment name"
  type        = string
}

variable "name" {
  description = "ECS name prefix"
  type        = string
}

variable "tags" {
  description = "Tags for the ECS resources"
  type        = map(string)
}
