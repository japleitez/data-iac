resource "aws_key_pair" "this" {
  key_name   = "${var.key_name}-key-pair-${lookup(var.tags, "Environment", "no-env-defined")}"
  public_key = var.ssh_public_key
  tags = merge(var.tags, {Name: "${var.key_name}-key-pair"})
}