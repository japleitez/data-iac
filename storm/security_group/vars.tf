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

variable "nimbus_port" {
  description = "The nimbus port"
}

variable "supervisor_port" {
  description = "The supervisor port"
}

variable "ui_port" {
  description = "The UI port"
}

variable "worker1_port" {
  description = "The worker 1 port"
}

variable "worker2_port" {
  description = "The worker 2 port"
}

variable "worker3_port" {
  description = "The worker 3 port"
}

variable "worker4_port" {
  description = "The worker 4 port"
}

variable "module_name" {
  description = "The Storm module name"
  type        = string
  default     = "storm-sg"
}

