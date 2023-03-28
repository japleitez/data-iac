
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

variable "private_subnets" {
  description = "The private subnets for the network configuration of ECS service"
  type        = list(string)
}

variable "zookeeper_log_group" {
  description = "Cloudwatch log group prefix"
  type        = string
}
variable "zookeeper_stream_prefix" {
  description = "Cloudwatch Stream prefix"
  type        = string
}

variable "zookeeper_image" {
  default = "249503910438.dkr.ecr.eu-central-1.amazonaws.com/zookeeper:3.7.0"
}

variable "zookeeper_port" {
  default = "2181"
}
variable "zookeeper_port_communication" {
  default = "2888"
}

variable "zookeeper_port_election" {
  default = "3888"
}

variable "zookeeper_instance_number" {
  default = 1
}

variable "zookeeper_elect_port_retry" {
  default = 999
}

variable "zookeeper_4lw_commands_whitelist" {
  default = "*"
}

variable "zookeeper_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 1024
  type        = string
}

variable "zookeeper_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 2048
  type        = string
}

variable "module_name" {
  description = "The DNS name for zookeeper"
  type        = string
  default     = "zookeeper"
}

variable "cluster_id" {
  description = "The ECS Cluster Storm ID"
}

locals {
  zookeeper_dns_zone = "${var.module_name}.${var.environment}"
  zookeeper_servers  = "server.1=zookeeper1.${local.zookeeper_dns_zone}:2888:3888;2181 server.2=zookeeper2.${local.zookeeper_dns_zone}:2888:3888;2181 server.3=zookeeper3.${local.zookeeper_dns_zone}:2888:3888;2181"
}
