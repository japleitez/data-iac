variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "private_subnets" {
  description = "The private subnets for the network configuration of ElasticSearch service"
  type        = list(string)
}

variable "ecs_task_execution_role" {
  description = "The arn for the ECS task execution role"
}

variable "selenium_cluster" {
  description = "The selenium ECS cluster"
}

variable "security_group_id" {
  description = "The security group id for the selenium cluster (ports 4444 and 5555 by default)"
}

variable "log_group" {
  description = "Selenium log group"
  type        = string
}

variable "se_event_bus_host" {
  description = "Selenium hub address"
  type        = string
}

variable "desired_count" {
  description = "Desired count of chrome nodes"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
}

variable "selenium_chrome_node_image" {
  description = "Selenium chrome node image"
  type        = string
  default     = "249503910438.dkr.ecr.eu-central-1.amazonaws.com/selenium-node-chrome:4.2.1-20220531"
}

variable "cpu" {
  description = "Selenium chrome node instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
  type        = string
}

variable "memory" {
  description = "Selenium chrome node  instance memory to provision (in MiB)"
  default     = "2048"
  type        = string
}

variable "module_name" {
  description = "The module name for Selenium chrome node"
  type        = string
  default     = "chrome-node"
}

locals {
  name = "${var.module_name}-${var.environment}"
  tags = merge(var.tags, {
    Name : local.name
  })
}
