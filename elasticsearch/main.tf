data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "template_file" "access_policies" {
  template = file("${path.module}/access_policies/config.json")

  vars = {
    current_name = data.aws_region.current.name
    account_id   = data.aws_caller_identity.current.account_id
    name         = local.name
  }
}

module "security_group" {
  source           = "./security_group"
  vpc_id           = var.vpc_id
  ssh_cidr_block   = var.ssh_cidr_block
  https_cidr_block = var.https_cidr_block
  environment      = var.environment
  tags             = local.tags
}

# resource "aws_iam_service_linked_role" "es" {
#   aws_service_name = "es.amazonaws.com"
# }

resource "aws_elasticsearch_domain" "es" {
  domain_name           = local.name
  elasticsearch_version = "7.10"

  cluster_config {
    instance_count = 3
    instance_type  = var.instance_type[var.environment]

    zone_awareness_enabled   = false
    dedicated_master_enabled = false
    warm_enabled             = false

  }

  ebs_options {
    ebs_enabled = true
    volume_size = 33
    volume_type = "standard"
  }

  vpc_options {
    subnet_ids         = slice(var.private_subnets, 0, 1)
    security_group_ids = [module.security_group.id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
    "override_main_response_version"         = "false"
  }

  access_policies = data.template_file.access_policies.rendered

  # depends_on = [aws_iam_service_linked_role.es]

  tags = local.tags

}
