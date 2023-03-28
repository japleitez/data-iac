#TF_VAR_access_ips
variable "access_ips" {
  description = "The list of IPs that can access the infrastructure"
}

variable "data_acquisition_dashboard_image" {
  description = "Docker image for Data Acquisition Dashboard"
  default     = "249503910438.dkr.ecr.eu-central-1.amazonaws.com/data_acquisition_dashboard"
}

#TF_VAR_data_acquisition_dashboard_tag
variable "data_acquisition_dashboard_tag" {
  description = "Tag name for the  Data Acquisition Dashboard Docker image"
  default     = "2.0.4"
}

variable "data_acquisition_service_image" {
  description = "Docker image for Data Acquisition Service"
  default     = "249503910438.dkr.ecr.eu-central-1.amazonaws.com/data_acquisition_service"
}

#TF_VAR_data_acquisition_service_tag
variable "data_acquisition_service_tag" {
  description = "Tag name for the Data Acquisition Service' Docker image"
  default     = "feature_wih_1554_0.0.4"
}

variable "playground_service_image" {
  description = "Docker image for Playground Service"
  default     = "249503910438.dkr.ecr.eu-central-1.amazonaws.com/playground_service"
}

#TF_VAR_playground_service_tag
variable "playground_service_tag" {
  description = "Tag name for the Playground Service' Docker image"
  default     = "2.0.4"
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "cloudwatch_group_name" {
  description = "The name for Dashboard's AWS Cloudwatch group name"
  default     = "/ecs/data-collection/dashboard-app"
}
variable "cloudwatch_stream_prefix" {
  description = "The prefix for Cloudwatch stream"
  default     = "ecs"
}

variable "cloudwatch_stream_name" {
  description = "The name for Dashboard's AWS Cloudwatch stream name"
  default     = "data-collection-dashboard-log-stream"
}

variable "dashboard_name" {
  description = "Name prefix for Data Acquisition Dashboard"
  default     = "dc-dashboard"
}

variable "cluster_name" {
  description = "Name prefix for Data Collection cluster"
  default     = "data-collection"
}

variable "das_health_check_path" {
  description = "Healthcheck path for Dashboard Service"
  default     = "/das/"
  type        = string
}

variable "dashboard_health_check_path" {
  description = "Healthcheck path for Dashboard"
  default     = "/"
  type        = string
}

variable "playground_health_check_path" {
  description = "Healthcheck path for Playground service"
  default     = "/playground/"
  type        = string
}

variable "private_subnets" {
  description = "The private subnets for the Dashboard"
  type        = list(string)
}

variable "public_subnets" {
  description = "The public subnets for the Dashboard"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}


variable "vpc_cidr_block" {
  description = "The VPC cidr range"
  type        = string
}

variable "dashboard_ecr_name" {
  description = "The name for Dashboard's ECR"
  type        = string
  default     = "data_acquisition_dashboard"
}

variable "data_acquisition_ecr_name" {
  description = "The name for ECR of Data Acquisition service"
  type        = string
  default     = "data_acquisition_service"
}

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
}

variable "das_name" {
  description = "Data Acquisition Service Name"
  type        = string
  default     = "DAS"
}

variable "playground_name" {
  description = "Playground_name Service Name"
  type        = string
  default     = "playground"
}

variable "aws_route53_zone_id" {
  description = "ASW Route53 zone id"
}

variable "domain_name" {
  description = "ASW Route53 name"
}

variable "elasticsearch_endpoint" {
  description = "ElasticSearch endpoint"
  type        = string
}

variable "selenium_address" {
  description = "Selenium Address"
  type        = string
}

variable "ecs_task_execution_role" {
  description = "The ECS execution role"
}

variable "auth_domain" {
  description = "The domain of the AuthN/AuthZ service"
}

variable "pool_id" {
  description = "The pool id of Cognito"
}

variable "dashboard_client_id" {
  description = "The client id for dashboard"
}

variable "data_acquisition_service_client_secret" {
  description = "The client secret for data acquisition client secret"
}

variable "data_acquisition_service_client_id" {
  description = "The client secret for data acquisition client id"
}

variable "playground_service_client_secret" {
  description = "The client secret for Playground client secret"
}

variable "playground_service_client_id" {
  description = "The client secret for Playground client id"
}

variable "spring_liquibase_contexts" {
  description = "Spring liquibase contexts"
  type        = map(string)
  default = {
    mr          = "prod,faker"
    development = "prod,faker"
    test        = "prod"
    pre         = "prod"
    prod        = "prod"
  }
}

variable "backup_retention_period_postgres" {
  description = "The number of days to retain automated PostgreSQL DB backups"
  type        = map(number)
  default = {
    mr          = 1
    development = 1
    test        = 1
    pre         = 7
    prod        = 7
  }
}

variable "multi_az_postgres" {
  description = "When the deployment has two standby DB instances"
  type        = map(bool)
  default = {
    mr          = false
    development = false
    test        = false
    pre         = true
    prod        = true
  }
}

variable "skip_final_snapshot_postgres" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = map(bool)
  default = {
    mr          = true
    development = true
    test        = true
    pre         = true
    prod        = false
  }
}

#  prod can be gp2
variable "storage_type_postgres" {
  description = "Specifies the storage type to be associated with the DB instance 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  type        = map(string)
  default = {
    mr          = "standard"
    development = "standard"
    test        = "standard"
    pre         = "standard"
    prod        = "standard"
  }
}

variable "allocated_storage_postgres" {
  description = "Amount of storage to be allocated for the DB instance, in gibibytes"
  type        = map(string)
  default = {
    mr          = "20"
    development = "20"
    test        = "20"
    pre         = "50"
    prod        = "50"
  }
}

variable "instance_class_postgres" {
  description = "instance class"
  type        = map(string)
  default = {
    mr          = "db.t3.micro"
    development = "db.t3.micro"
    test        = "db.t3.micro"
    pre         = "db.t3.small"
    prod        = "db.t3.small"
  }
}

variable "postgres_secrets" {
  description = "PostgresSQL pass"
  type        = map(string)
}

variable "postgres_snapshot_identifier" {
  description = "PostgresSQL snapshot id"
  type        = string
}

variable "storage_encrypted_postgres" {
  description = "AWS KMS keys when creating encrypted volumes and snapshots"
  type        = map(bool)
  default = {
    mr          = false
    development = false
    test        = false
    pre         = false
    prod        = false
  }
}

variable "backup_window_postgres" {
  description = "The daily time range during which automated backups are created"
  type        = map(string)
  default = {
    mr          = "20:01-20:43"
    development = "21:01-21:43"
    test        = "22:01-22:43"
    pre         = "23:01-23:43"
    prod        = "23:01-23:43"
  }
}

locals {
  timestamp         = timestamp()
  timestamp_cleaned = replace(local.timestamp, "/[- TZ:]/", "")
}

