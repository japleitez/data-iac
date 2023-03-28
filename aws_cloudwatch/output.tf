output "cloudwatch_name" {
  description = "Cloudwatch name"
  value       = aws_cloudwatch_log_group.data_collection_dashboard_log_group.name
}

output "cloudwatch_stream_name" {
  description = "Cloudwatch stream name"
  value       = aws_cloudwatch_log_stream.data_collection_dashboard_log_stream.name
}
