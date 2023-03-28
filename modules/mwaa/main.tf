# MWAA S3

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "wihp-temp-${local.name}" # temp name due to migration

  #
  #  https://github.com/hashicorp/terraform-provider-aws/issues/23125
  #  https://github.com/hashicorp/terraform-provider-aws/issues/23103
  #
  #   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-4-upgrade#server_side_encryption_configuration-argument
  #
  #  server_side_encryption_configuration {
  #    rule {
  #      apply_server_side_encryption_by_default {
  #        sse_algorithm = "AES256"
  #      }
  #    }
  #  }
  #
  #  versioning {cle
  #    enabled = true
  #  }

  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "dags" {
  for_each = fileset("${path.module}/dags/", "*.py")
  bucket   = aws_s3_bucket.s3_bucket.id
  key      = "dags/${each.value}"
  source   = "${path.module}/dags/${each.value}"
  etag     = filemd5("${path.module}/dags/${each.value}")
}

### IAM Roles
resource "aws_iam_role" "iam_role" {
  name = "${local.name}-IAMRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "mwaa"
        Principal = {
          Service = [
            "airflow-env.amazonaws.com",
            "airflow.amazonaws.com"
          ]
        }
      },
    ]
  })

  tags = merge(local.tags)
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    sid       = ""
    actions   = ["airflow:PublishMetrics"]
    effect    = "Allow"
    resources = ["arn:aws:airflow:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:environment/${local.name}"]
  }

  statement {
    sid     = ""
    actions = ["s3:ListAllMyBuckets"]
    effect  = "Allow"
    resources = [
      aws_s3_bucket.s3_bucket.arn,
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]
  }

  statement {
    sid = ""
    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.s3_bucket.arn,
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]
  }

  statement {
    sid       = ""
    actions   = ["logs:DescribeLogGroups"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = ""
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogRecord",
      "logs:GetLogGroupFields",
      "logs:GetQueryResults",
      "logs:DescribeLogGroups"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:airflow-${local.name}*"]
  }

  statement {
    sid       = ""
    actions   = ["cloudwatch:PutMetricData"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = ""
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = ["arn:aws:sqs:${data.aws_region.current.name}:*:airflow-celery-*"]
  }

  statement {
    sid = ""
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt"
    ]
    effect        = "Allow"
    not_resources = ["arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values = [
        "sqs.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "iam_policy" {
  name   = "${local.name}-IAMPoliy"
  path   = "/"
  policy = data.aws_iam_policy_document.iam_policy_document.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "aws_security_group" "mwaa" {
  name        = "${var.module_name}-mwaa-sg"
  description = "Security Group for Amazon MWAA Environment ${var.environment}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
    cidr_blocks = var.access_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_mwaa_environment" "airflow" {
  name = "${local.name}-mwaa"

  airflow_configuration_options = {
    "core.default_task_retries"          = 16
    "core.parallelism"                   = 1
    "wihp.client_id"                     = var.client_id
    "wihp.client_secret"                 = var.client_secret
    "wihp.data_acquisition_service_host" = var.data_acquisition_service_host
    "wihp.data_acquisition_service_port" = var.data_acquisition_service_port
    "wihp.oauth_host"                    = var.oauth_host
    "wihp.oauth_port"                    = var.oauth_port
    "wihp.oauth_scope"                   = local.oauth_scope[var.environment]
  }

  webserver_access_mode = "PUBLIC_ONLY"

  dag_s3_path = "dags/"

  execution_role_arn = aws_iam_role.iam_role.arn

  network_configuration {
    security_group_ids = [aws_security_group.mwaa.id]
    subnet_ids         = var.private_subnets
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }

    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }

    task_logs {
      enabled   = true
      log_level = "INFO"
    }

    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }

    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }

  source_bucket_arn = aws_s3_bucket.s3_bucket.arn

  tags = local.tags
}

/*
module "lb" {
  source      = "./modules/lb"
  vpc_id      = var.vpc_id
  access_ips  = var.access_ips
  environment = var.environment
  subnets     = var.public_subnets
  tags        = local.tags
  ips_path    = "${path.root}/ips"
}
*/
