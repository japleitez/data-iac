variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "cluster_id" {
  description = "The ECS Cluster ID"
}

variable "ecs_task_execution_role" {
  description = "The ECS Task execution role"
}
variable "template" {
  description = "The template for the Task Definition"
}

variable "name" {
  description = "ECS name prefix"
  type        = string
}

variable "image" {
  description = "Docker image "
  type        = string
}

variable "auth_domain" {
  description = "The domain of the AuthN/AuthZ service"
}

variable "client_id" {
  description = "The oauth client_id"
}

variable "client_secret" {
  description = "The oauth client_secret"
}

variable "pool_id" {
  description = "The Cognito pool_id"
}

variable "port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
  type        = number
}

variable "log_group" {
  description = "Cloudwatch log grou prefix"
  type        = string
}
variable "stream_prefix" {
  description = "Cloudwatch Stream prefix"
  type        = string
}

variable "desired_count" {
  description = "Number of desired containers to run"
  default     = 2
  type        = number
}

variable "health_check_path" {
  description = "Health check path"
  default     = "/"
  type        = string
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
  type        = string
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
  type        = string
}

variable "ecs_security_group_ids" {
  description = "The security group ids for the ECS service"
  type        = list(string)
}
variable "load_balancer_target_group_id" {
  description = "The load balancer target group id for the network configuration of ECS service"
  type        = string
}
variable "load_balancer_listener" {
  description = "The load balancer listener to be used as a dependency for the creation of ECS service"
  type        = object({})
}
variable "private_subnets" {
  description = "The private subnets for the network configuration of ECS service"
  type        = list(string)
}

variable "elasticsearch_endpoint" {
  description = "ElasticSearch endpoint"
  default     = ""
  type        = string
}

variable "selenium_address" {
  description = "Selenium Address"
  default     = ""
  type        = string
}

variable "db_address" {
  description = "The database address (without the port)"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "The database name"
  type        = string
  default     = ""
}

variable "db_password" {
  description = "The database password"
  type        = string
  default     = ""
}

variable "spring_liquibase_contexts" {
  description = "Spring liquibase contexts"
  type        = string
  default     = "prod"
}

variable "playground_host" {
  description = "Playground Service host name"
  type        = string
  default     = "playground_host"
}

variable "playground_port" {
  description = "Playground Service port"
  type        = string
  default     = "playground_port"
}

variable "tags" {
  description = "Tags for the ECS resources"
  type        = map(string)
}

locals {
  scope = {
    mr          = "https://development.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    development = "https://${var.environment}.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    test        = "https://${var.environment}.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    pre         = "https://${var.environment}.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    prod        = "https://${var.environment}.wihp.ecdp.tech.ec.europa.eu/api/das:full"
  }
}
