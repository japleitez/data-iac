variable "name" {
  description = "Name for the Application load balancer resources"
  type        = string
}

variable "tags" {
  description = "Tags for the Application load balancer resources"
  type        = map(string)
}

variable "subnets" {
  description = "Subnets for the Application Load Balancer"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for the Application Load Balancer"
  type        = list(string)
  default     = []
}

variable "drop_invalid_header_fields" {
  description = "Drop invalid http headers"
  type        = bool
  default     = true
}

variable "internal" {
  description = "True if it is an internal Application load Balancer"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "Id of the VPC"
  type        = string
}

variable "target_type" {
  description = "Target type, default IP"
  type        = string
  default     = "ip"
}

variable "dashboard_health_check_path" {
  description = "service Dashboard UI health check path"
  type        = string
}

variable "das_health_check_path" {
  description = "service Dashboard (DAS)  health check path"
  type        = string
}

variable "playground_health_check_path" {
  description = "service Playground health check path"
  type        = string
}

variable "target_group_port" {
  description = "Target group port"
  type        = number
  default     = 80
}
variable "target_group_protocol" {
  description = "Target group protocol"
  type        = string
  default     = "HTTP"
}

variable "health_check_healthy_threshold" {
  description = "Health check healthy threshold"
  type        = string
  default     = "3"
}

variable "health_check_interval" {
  description = "Health check interval"
  type        = string
  default     = "30"
}

variable "health_check_protocol" {
  description = "Health check protocol"
  type        = string
  default     = "HTTP"
}

variable "health_check_matcher" {
  description = "Health check matcher"
  type        = string
  default     = "200"
}

variable "health_check_timeout" {
  description = "Health check timeout"
  type        = string
  default     = "3"
}

variable "health_check_unhealthy_threshold" {
  description = "Health check unhealthy threshold"
  type        = string
  default     = "2"
}

variable "dashboard_listener_port" {
  description = "ALB listener port for Dashboard"
  type        = number
  default     = 443
}

variable "das_listener_port" {
  description = "ALB listener port for Data Acquisition Service"
  type        = number
  default     = 443
}

variable "das_target_group_port" {
  description = "Data Acquisition Service Target group port"
  type        = number
  default     = 80
}

variable "playground_target_group_port" {
  description = "playground Service Target group port"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "ALB listener protocol"
  type        = string
  default     = "HTTPS"
}

variable "domain_name" {
  description = "Route 53 zone name"
  type        = string
}

variable "listener_default_action_type" {
  description = "ALB listener default action type"
  type        = string
  default     = "forward"
}

#TF_VAR_access_ips
variable "access_ips" {
  description = "The list ofIPs that can access the infrastructure"
}
