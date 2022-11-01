data "aws_vpc" "vpc_lookup" {
  tags = {
    Name = "${var.organization}-apps-${var.environment}-${data.aws_region.current.name}-vpc"
  }
}

resource "aws_security_group" "lambda_sg" {
  name        = "${var.application}-${var.environment}-sg"
  vpc_id      = data.aws_vpc.vpc_lookup.id
  description = "Allows HTTPS egress"

  egress {
    description = "Allows HTTPS egress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.aws_cidr
  }
}
