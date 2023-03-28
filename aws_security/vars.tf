variable "security_group_name" {
  description = "The name for the security group"
  type        = string
}

variable "description" {
  description = "The description of the security group"
  type        = string
}

variable "inbound_description" {
  description = "The description of the inbound rule"
  type        = string
}

variable "outbound_description" {
  description = "The description of the outbound rule"
  type        = string
}

variable "vpc_id" {
  description = "The vpc id"
}

variable "ingress_protocol" {
  description = "Security group rule protocol"
  type        = string
  default     = "tcp"
}

variable "ingress_from_port" {
  description = "Security group rule from port"
  type        = number
  default     = 443
}

variable "ingress_to_port" {
  description = "Security group rule to port"
  type        = number
  default     = 443
}

variable "ingress_cidr_blocks" {
  description = "Security group rule cidr block"
  type        = list(string)
}

variable "egress_protocol" {
  description = "Security group rule protocol"
  type        = string
  default     = "-1"
}

variable "egress_from_port" {
  description = "Security group rule from port"
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "Security group rule to port"
  type        = number
  default     = 0
}

variable "egress_cidr_blocks" {
  description = "Security group rule cidr block"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
}
