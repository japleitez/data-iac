variable "group_name" {
  description = "The AWS Cloudwatch group name"
  type = string
}

variable "stream_name" {
  description = "The AWS Cloudwatch stream name"
  type = string
}

variable "retention_in_days" {
  description = "The AWS Cloudwatch group retention period"
  default = 30
  type = number
}

variable "tags" {
  description = "Tags for the AWS Cloudwatch module"
  type        = map(string)
}