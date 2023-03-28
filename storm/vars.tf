variable "public_subnets" {
  description = "The public subnets for the load balancer"
}

#TF_VAR_access_ips
variable "access_ips" {
  description = "The list of IPs that can access the infrastructure"
}

variable "aws_route53_zone_name" {
  description = "Route 53 zone name"
  type        = string
}

variable "zookeeper_hostname" {
  description = "Zookeeper host name"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block"
  type        = string
}

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
}

variable "ecs_task_execution_role" {
  description = "The ECS Task execution role"
}

variable "cluster_id" {
  description = "The ECS Cluster ID"
}

variable "private_subnets" {
  description = "The private subnets for the network configuration of ECS service"
  type        = list(string)
}

variable "storm_log_group" {
  description = "Cloudwatch log group prefix"
  type        = string
}
variable "storm_stream_prefix" {
  description = "Cloudwatch Stream prefix"
  type        = string
}

variable "storm_image" {
  default = "249503910438.dkr.ecr.eu-central-1.amazonaws.com/storm_2_4_0:0.0.4"
}

variable "module_name" {
  description = "The Storm module name"
  type        = string
  default     = "storm"
}

locals {
  storm_dns_zone = "${var.module_name}.${var.environment}"
}
