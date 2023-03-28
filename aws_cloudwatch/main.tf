resource "aws_cloudwatch_log_group" "data_collection_dashboard_log_group" {
  #checkov:skip=CKV_AWS_158:No integration with KMS yet
  name              = var.group_name
  retention_in_days = var.retention_in_days

  tags = merge(var.tags, {Name: "${replace(var.group_name, "/", "-")}-log-group"})
}


resource "aws_cloudwatch_log_stream" "data_collection_dashboard_log_stream" {
  name           = var.stream_name
  log_group_name = aws_cloudwatch_log_group.data_collection_dashboard_log_group.name
}