provider "aws" {
  region = var.region

  default_tags {
    tags = {
      commit = var.lambda_version
    }
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
