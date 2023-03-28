resource "aws_security_group" "es" {
  name        = local.name
  description = "Security group for ElasticSearch"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = var.https_cidr_block

  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = var.ssh_cidr_block

  }
  tags = local.tags
}
