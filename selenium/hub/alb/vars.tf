variable "module_name" {
  description = "Module name for the Selenium load balancer resources"
  type = string
  default = "selenium-lb"
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "tags" {
  description = "Tags for the Application load balancer resources"
  type        = map(string)
}

variable "subnets" {
  description = "Subnets for the Application Load Balancer"
  type = list(string)
}

variable "security_groups" {
  description = "Security groups for the Application Load Balancer"
  type = list(string)
  default = []
}

variable "drop_invalid_header_fields" {
  description = "Drop invalid http headers"
  type = bool
  default = true
}

variable "internal" {
  description = "True if it is an internal Application load Balancer"
  type = bool
  default = false
}

variable "vpc_id" {
  description = "Id of the VPC"
  type = string
}

variable "target_type" {
  description = "Target type, default IP"
  type = string
  default = "ip"
}

variable "health_check_path" {
  description = "Application health check path"
  type = string
  default = "/status"
}

variable "target_group_port"{
  description = "Target group port"
  type = number
  default = 80
}
variable "target_group_protocol"{
  description = "Target group protocol"
  type = string
  default = "HTTP"
}

variable "health_check_healthy_threshold"{
  description = "Health check healthy threshold"
  type = string
  default = "3"
}

variable "health_check_interval"{
  description = "Health check interval"
  type = string
  default = "30"
}

variable "health_check_protocol"{
  description = "Health check protocol"
  type = string
  default = "HTTP"
}

variable "health_check_matcher"{
  description = "Health check matcher"
  type = string
  default = "200"
}

variable "health_check_timeout"{
  description = "Health check timeout"
  type = string
  default = "3"
}

variable "health_check_unhealthy_threshold"{
  description = "Health check unhealthy threshold"
  type = string
  default = "2"
}

variable "listener_protocol"{
  description = "ALB listener protocol"
  type = string
  default = "HTTP"
}

variable "listener_default_action_type"{
  description = "ALB listener default action type"
  type = string
  default = "forward"
}

#TF_VAR_access_ips
variable "access_ips" {
  description = "The list of IPs that can access the infrastructure"
}

locals {
  name = "${var.module_name}-${var.environment}"
  tags = merge(var.tags, {Name: local.name})
}
