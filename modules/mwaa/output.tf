output "mwaa_environment_url" {
  value       = aws_mwaa_environment.airflow.webserver_url
  description = "Web server URL of MWAA."
}
