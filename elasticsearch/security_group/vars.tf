variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "https_cidr_block" {
  description = "The HTTPS CIDR block"
  type        = list(string)
}

variable "ssh_cidr_block" {
  description = "The SSH CIDR block"
  type        = list(string)
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
  type    = string
  default = "elasticsearch-sg"
}

locals {
  name = "${var.module_name}-${var.environment}"
  tags = merge(var.tags, { Name : local.name })
}
