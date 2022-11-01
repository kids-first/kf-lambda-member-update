resource "aws_sns_topic" "app-sns-notifications" {
  name              = "${var.application}-${var.region}-${var.environment}-sns"
  display_name      = "${var.application}-${var.region}-${var.environment}-notifications"
  kms_master_key_id = "alias/${var.application}-${var.environment}-kms-key"
}

data "aws_iam_policy_document" "kms_policy" {
  policy_id = "__default_policy_ID"

  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey"
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
      "kms:*"
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
}

resource "aws_kms_key" "sqs_sns_key" {
  description         = "Key for sns and sqs"
  policy              = data.aws_iam_policy_document.kms_policy.json
  enable_key_rotation = true
}

resource "aws_kms_alias" "sqs_sns_key_alias" {
  name          = "alias/lambda-${var.application}-${var.environment}-kms-key"
  target_key_id = aws_kms_key.sqs_sns_key.key_id
}


resource "aws_sns_topic_subscription" "sns-sqs-subscription" {
  topic_arn = aws_sns_topic.app-sns-notifications.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.kf_lambda_sqs.arn
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.app-sns-notifications.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    sid    = "__default_statement_ID"
    effect = "Allow"
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        "${data.aws_caller_identity.current.account_id}"
      ]
    }
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.aws_lambda_role.arn]
    }
    principals {
      type = "Service"
      identifiers = [
        "cloudwatch.amazonaws.com"
      ]
    }
    resources = [
      "${aws_sns_topic.app-sns-notifications.arn}"
    ]
  }
}
