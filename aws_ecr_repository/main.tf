resource "aws_ecr_repository" "this" {
  #checkov:skip=CKV_AWS_136:No KMS integration yet
  name                 = var.name
  #For security this is a non dynamic value
  image_tag_mutability = "IMMUTABLE"
  #For security this is a non dynamic value
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {Name: "${var.name}-ecr"})
}
