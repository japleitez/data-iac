
resource "aws_appautoscaling_target" "target" {
  service_namespace  = var.service_namespace
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = var.scalable_dimension
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

# Automatically scale capacity up by one


resource "aws_appautoscaling_policy" "up" {
  name               = "${var.autoscaling_policy_name}_scale_up"
  service_namespace  = var.service_namespace
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = var.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = var.adjustment_type
    cooldown                = var.cooldown
    metric_aggregation_type = var.metric_aggregation_type

    step_adjustment {
      metric_interval_lower_bound = var.step_adjustment_metric_interval_lower_bound
      scaling_adjustment          = var.step_adjustment_up_scaling_adjustment
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
  name               = "${var.autoscaling_policy_name}_scale_down"
  service_namespace  = var.service_namespace
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = var.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = var.adjustment_type
    cooldown                = var.cooldown
    metric_aggregation_type = var.metric_aggregation_type

    step_adjustment {
      metric_interval_lower_bound = var.step_adjustment_metric_interval_lower_bound
      scaling_adjustment          = var.step_adjustment_down_scaling_adjustment
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.autoscaling_policy_name}_cpu_high"
  comparison_operator = var.cpu_high_comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_up

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]

  tags = merge(var.tags, {Name: "${var.autoscaling_policy_name}-metric-alarm-cpu-high"})
}

# CloudWatch alarm that triggers the autoscaling down policy

resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "${var.autoscaling_policy_name}_cpu_low"
  comparison_operator = var.cpu_low_comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_down

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  tags = merge(var.tags, {Name: "${var.autoscaling_policy_name}-metric-alarm-cpu-low"})
  alarm_actions = [aws_appautoscaling_policy.down.arn]
}
