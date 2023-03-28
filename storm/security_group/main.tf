
resource "aws_security_group" "storm_sg" {
  name        = var.module_name
  description = "Storm security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name : var.module_name })
}

resource "aws_security_group_rule" "inbound_storm_nimbus_port" {
  description       = "Ingress Storm Nimbus port"
  protocol          = "tcp"
  from_port         = var.nimbus_port
  to_port           = var.nimbus_port
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.storm_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_storm_ui_port" {
  description       = "Ingress Storm UI port communication"
  protocol          = "tcp"
  from_port         = var.ui_port
  to_port           = var.ui_port
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.storm_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_storm_worker1_port" {
  description       = "Ingress Storm worker 1 port communication"
  protocol          = "tcp"
  from_port         = var.worker1_port
  to_port           = var.worker1_port
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.storm_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_storm_supervisor_port" {
  description       = "Ingress Storm worker 1 port communication"
  protocol          = "tcp"
  from_port         = var.supervisor_port
  to_port           = var.supervisor_port
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.storm_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_storm_worker2_port" {
  description       = "Ingress Storm UI port communication"
  protocol          = "tcp"
  from_port         = var.worker2_port
  to_port           = var.worker2_port
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.storm_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_storm_worker3_port" {
  description       = "Ingress Storm UI port communication"
  protocol          = "tcp"
  from_port         = var.worker3_port
  to_port           = var.worker3_port
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.storm_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_storm_worker4_port" {
  description       = "Ingress Storm UI port communication"
  protocol          = "tcp"
  from_port         = var.worker4_port
  to_port           = var.worker4_port
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.storm_sg.id
  type              = "ingress"
}


resource "aws_security_group_rule" "allow_outbound" {
  description       = "Storm allow all outbound"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.storm_sg.id
  type              = "egress"
}
