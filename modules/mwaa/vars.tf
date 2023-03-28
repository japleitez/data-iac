
variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "public_subnets" {
  description = "The public subnets for the network configuration of MWAA"
  type        = list(string)
}

variable "private_subnets" {
  description = "The private subnets for the network configuration of MWAA"
  type        = list(string)
}

variable "client_id" {
  description = "The OAuth2 client id of MWAA"
  type        = string
}
variable "client_secret" {
  description = "The OAuth2 client secret of MWAA"
  type        = string
}

variable "data_acquisition_service_host" {
  description = "The data acquisition service host"
  type        = string
}
variable "data_acquisition_service_port" {
  description = "The data acquisition service port"
  type        = string
}
variable "oauth_host" {
  description = "The OAuth service host"
  type        = string
}
variable "oauth_port" {
  description = "The OAuth service port"
  type        = string
}

#TF_VAR_access_ips
variable "access_ips" {
  description = "The list ofIPs that can access the infrastructure"
}

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
}

variable "module_name" {
  description = "The Managed Workflows for Apache Airflow"
  type        = string
  default     = "mwaa"
}

locals {
  name = "${var.module_name}-${var.environment}"
  tags = merge(var.tags, {
    Name : local.name
  })
  oauth_scope = {
    mr          = "https://development.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    development = "https://${var.environment}.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    test        = "https://${var.environment}.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    pre         = "https://${var.environment}.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    prod        = "https://${var.environment}.wihp.ecdp.tech.ec.europa.eu/api/das:full"
  }
}
