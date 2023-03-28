variable "environment" {
  description = "The environment name"
  type        = string
}

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

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
}

variable "private_subnets" {
  description = "The private subnets for the network configuration of ElasticSearch service"
  type        = list(string)
}

variable "module_name" {
  description = "The module name for ElasticSearch"
  type        = string
  default     = "elasticsearch"
}

variable "instance_type" {
  description = "ElasticSearch instance type"
  type        = map(string)
  default = {
    mr          = "t2.small.elasticsearch"
    development = "t2.small.elasticsearch"
    test        = "t2.small.elasticsearch"
    pre         = "t2.small.elasticsearch"
    prod        = "t2.small.elasticsearch"
  }
}

locals {
  name = "${var.module_name}-${var.environment}"
  tags = merge(var.tags, { Name : local.name })
}
