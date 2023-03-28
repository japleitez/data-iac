variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
}

variable "module_name" {
  type        = string
  default     = "selenium-alb-sg"
}

#TF_VAR_access_ips
variable "access_ips" {
  description = "The list of IPs that can access the infrastructure"
}

locals {
  name = "${var.module_name}-${var.environment}"
  tags = merge(var.tags, {Name: local.name})
}
