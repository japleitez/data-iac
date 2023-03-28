# ECS task execution role
variable "name" {
  description = "The name for the ecs task execution role"
  type = string
}

variable "tags" {
  description = "Tags for the execution role"
  type        = map(string)
}