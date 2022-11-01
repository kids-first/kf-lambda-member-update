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
  tags = {
    git_commit           = "7173679218c859ca8e841e802790fec06cc76826"
    git_file             = "deployment/terraform/securitygroups.tf"
    git_last_modified_at = "2022-11-01 18:05:43"
    git_last_modified_by = "blackdenc@chop.edu"
    git_modifiers        = "blackdenc"
    git_org              = "kids-first"
    git_repo             = "kf-lambda-member-update"
    yor_trace            = "b60ee6a8-4d30-430a-964b-2df2f09200a3"
  }
}
