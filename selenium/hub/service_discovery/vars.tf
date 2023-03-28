variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "module_name" {
  description = "Module name"
  type        = string
  default     = "selenium-hub-discovery"
}

locals {
  name         = "${var.module_name}-${var.environment}"
  hub_dns_zone = "selenium-hub.${var.environment}"
  tags = merge(var.tags, {
    Name : local.name
  })
}
