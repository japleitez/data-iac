variable "environment" {
  description = "The environment name"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "WIHPEcsTaskExecutionRole"
  type        = string
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default     = "WIHPEcsAutoScaleRole"
  type        = string
}

variable "tags" {
  description = "Tags for the ECS resources"
  type        = map(string)
}
