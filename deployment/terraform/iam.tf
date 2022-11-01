resource "aws_iam_instance_profile" "aws_lambda_profile" {
  name = "aws-lambda-${var.application}-${var.environment}-profile"
  role = aws_iam_role.aws_lambda_role.name
}

resource "aws_iam_role" "aws_lambda_role" {
  name = "aws-lambda-${var.application}-${var.environment}-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_policy" "aws_lambda_policy" {
  name        = "aws-lambda-policy-${var.application}-${var.environment}"
  description = "Policy for lambda"
  policy      = data.aws_iam_policy_document.lambda_policy_document.json
}

data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::${var.payload_bucket}/*",
      "arn:aws:s3:::${var.payload_bucket}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "arn:aws:s3:::${var.payload_bucket}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging",
      "lambda:InvokeFunction",
      "lambda:InvokeAsync",
    ]

    resources = [
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.application}-${var.environment}",
      "arn:aws:s3:::${var.organization}-study-*-${var.environment}*",
      "arn:aws:s3:::${var.organization}-study-*-${var.environment}*/*",
      "arn:aws:s3:::${var.organization}-study-*",
      "arn:aws:s3:::${var.organization}-study-*/*",
      "arn:aws:s3:::${var.organization}-seq-data-*",
      "arn:aws:s3:::${var.organization}-seq-data-*/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "sqs:Receive*",
      "sqs:DeleteMessage",
      "sqs:Get*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "aws_lambda_role_attach" {
  role       = aws_iam_role.aws_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_policy.arn
}
