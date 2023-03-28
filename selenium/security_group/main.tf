resource "aws_security_group" "selenium_sg" {
  name        = local.name
  description = "Security group for Selenium"
  vpc_id      = var.vpc_id

  ingress {
    description = "Selenium Hub ports"
    from_port   = 4442
    to_port     = 4444
    protocol    = "tcp"

    cidr_blocks = [var.vpc_cidr_block]

  }
  ingress {
    description = "Selenium Node port"
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"

    cidr_blocks = [var.vpc_cidr_block]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = local.tags
}
