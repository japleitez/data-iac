resource "aws_security_group" "this" {
  name        = "${var.security_group_name}-sg"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name : "${var.security_group_name}-sg" })
}

resource "aws_security_group_rule" "inbound" {
  description       = var.inbound_description
  protocol          = var.ingress_protocol
  from_port         = var.ingress_from_port
  to_port           = var.ingress_to_port
  cidr_blocks       = var.ingress_cidr_blocks
  security_group_id = aws_security_group.this.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_80" {
  description       = "Http port 80"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = var.ingress_cidr_blocks
  security_group_id = aws_security_group.this.id
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_outbound" {
  description       = var.inbound_description
  protocol          = var.egress_protocol
  from_port         = var.egress_from_port
  to_port           = var.egress_to_port
  cidr_blocks       = var.egress_cidr_blocks
  security_group_id = aws_security_group.this.id
  type              = "egress"
}
