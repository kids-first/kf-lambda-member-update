resource "aws_kms_key" "sqs_sns_key" {
  description         = "Key for sns and sqs"
  policy              = data.aws_iam_policy_document.kms_policy.json
  enable_key_rotation = true
  tags = {
    git_commit           = "7173679218c859ca8e841e802790fec06cc76826"
    git_file             = "deployment/terraform/kms.tf"
    git_last_modified_at = "2022-11-01 18:05:43"
    git_last_modified_by = "blackdenc@chop.edu"
    git_modifiers        = "blackdenc"
    git_org              = "kids-first"
    git_repo             = "kf-lambda-member-update"
    yor_trace            = "073389d3-525e-4297-b94a-9162d034e251"
  }
}

resource "aws_kms_alias" "sqs_sns_key_alias" {
  name          = "alias/lambda-${var.application}-${var.environment}-kms-key"
  target_key_id = aws_kms_key.sqs_sns_key.key_id
}

data "aws_iam_policy_document" "kms_policy" {
  policy_id = "__default_policy_ID"

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    principals {
      type = "Service"
      identifiers = [
        "cloudwatch.amazonaws.com"
      ]
    }
    resources = [
      "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:*",
    ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    resources = [
      "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    principals {
      type = "Service"
      identifiers = [
        "logs.${var.region}.amazonaws.com"
      ]
    }
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}