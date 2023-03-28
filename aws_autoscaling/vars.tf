variable "service_namespace" {
  description = "The Autoscaling target service namespace"
  default = "ecs"
  type = string
}
variable "cluster_name" {
  description = "The Autoscaling resource cluster name. Will be used to construct the resource_id 'service/var.cluster_name/var.service_name'"
  type = string
}
variable "service_name" {
  description = "The Autoscaling resource service name. Will be used to construct the resource_id 'service/var.cluster_name/var.service_name'"
  type = string
}
variable "scalable_dimension" {
  description = "The Autoscaling target scalable dimension"
  default = "ecs:service:DesiredCount"
  type = string
}
variable "min_capacity" {
  description = "The Autoscaling target minimum capacity"
  default = 2
  type = number
}
variable "max_capacity" {
  description = "The Autoscaling target maximum capacity"
  default = 2
  type = number
}
variable "autoscaling_policy_name" {
  description = "The autoscaling policy name. Will used to construct different polices 'autoscaling_policy_name_up'"
  type = string
}

variable "adjustment_type" {
  description = "The autoscaling adjustment type. Is common for both Up and Down policy"
  default = "ChangeInCapacity"
  type = string
}
variable "cooldown" {
  description = "The autoscaling cooldown. Is common for both Up and Down policy"
  default = 60
  type = number
}

variable "metric_aggregation_type" {
  description = "The autoscaling metric aggregation type. Is common for both Up and Down policy"
  default = "Maximum"
  type = string
}
variable "step_adjustment_metric_interval_lower_bound" {
  description = "The metric interval upper bound for autoscaling step adjustment. Is common for both Up and Down policy"
  default = 0
  type = number
}
variable "step_adjustment_up_scaling_adjustment" {
  description = "The scaling adjustment for autoscaling step adjustment."
  default = 1
  type = number
}

variable "step_adjustment_down_scaling_adjustment" {
  description = "The scaling adjustment for autoscaling step adjustment."
  default = -1
  type = number
}

variable "cpu_high_comparison_operator" {
  description = "The comparison operator for high metric alarm"
  default = "GreaterThanOrEqualToThreshold"
  type = string
}
variable "cpu_low_comparison_operator" {
  description = "The comparison operator for low metric alarm"
  default = "LessThanOrEqualToThreshold"
  type = string
}
variable "evaluation_periods" {
  description = "The evaluation periods for metric alarms (high and low)"
  default = "2"
  type = string
}

variable "metric_name" {
  description = "The metric name for metric alarms (high and low)"
  default = "CPUUtilization"
  type = string
}

variable "namespace" {
  description = "The namespace for metric alarms (high and low)"
  default = "AWS/ECS"
  type = string
}

variable "period" {
  description = "The period for metric alarms (high and low)"
  default = "60"
  type = string
}

variable "statistic" {
  description = "The statistic for metric alarms (high and low)"
  default = "Average"
  type = string
}

variable "threshold_up" {
  description = "The threshold for metric alarms high"
  default = "85"
  type = string
}

variable "threshold_down" {
  description = "The threshold for metric alarms low"
  default = "10"
  type = string
}

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
}