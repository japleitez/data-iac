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

variable "public_subnets" {
  description = "The public subnets for the ALB"
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

variable "desired_hub_count" {
  description = "The arn for the ECS task execution role"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
}

variable "selenium_hub_image" {
  description = "Selenium hub image"
  type        = string
  default     = "249503910438.dkr.ecr.eu-central-1.amazonaws.com/selenium-hub:4.2.1-20220531"
}

variable "hub_cpu" {
  description = "Selenium hub instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
  type        = string
}

variable "hub_memory" {
  description = "Selenium hub  instance memory to provision (in MiB)"
  default     = "512"
  type        = string
}

##TF_VAR_access_ips
variable "access_ips" {
  description = "The list of IPs that can access the infrastructure"
}

variable "module_name" {
  description = "The module name for Selenium hub"
  type        = string
  default     = "hub"
}

locals {
  name         = "${var.module_name}-${var.environment}"
  hub_dns_zone = "${var.module_name}.${var.environment}"
  tags = merge(var.tags, {
    Name : local.name
  })
}
