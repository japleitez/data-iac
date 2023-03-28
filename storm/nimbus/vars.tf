variable "storm_discovery_namespace" {
  description = "Storm discovery namespace"
}

variable "zookeeper_hostname" {
  description = "Zookeeper host name"
  type        = string
}

variable "storm_security_group" {
  description = "Storm security group"
}

variable "storm_dns_zone" {
  description = "Storm DNS zone name"
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

variable "ecs_task_execution_role" {
  description = "The ECS Task execution role"
}

variable "cluster_id" {
  description = "The ECS Cluster ID"
}

variable "private_subnets" {
  description = "The private subnets for the network configuration of ECS service"
  type = list(string)
}

variable "storm_log_group" {
  description = "Cloudwatch log group prefix"
  type = string
}
variable "storm_stream_prefix" {
  description = "Cloudwatch Stream prefix"
  type = string
}

variable "storm_image" {
  description = "Storm docker image"
}

variable "nimbus_port" {
  default = "6627"
}


variable "nimbus_instance_number" {
  default = 2
}

variable "storm_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 1024
  type        = string
}

variable "storm_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 2048
  type        = string
}

variable "module_name" {
  description = "The Storm module name"
  type        = string
  default     = "nimbus-storm"
}

