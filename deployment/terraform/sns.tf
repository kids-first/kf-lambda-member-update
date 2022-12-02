resource "aws_sns_topic" "app_sns_notifications" {
  name              = "${var.application}-${var.region}-${var.environment}-sns"
  display_name      = "${var.application}-${var.region}-${var.environment}-notifications"
  kms_master_key_id = "alias/${var.application}-${var.environment}-kms-key"
  tags = {
    git_commit           = "91c80656a306a7a32bc611d97286f3719b2fbcb0"
    git_file             = "deployment/terraform/sns.tf"
    git_last_modified_at = "2022-11-01 18:05:43"
    git_last_modified_by = "blackdenc@chop.edu"
    git_modifiers        = "blackdenc"
    git_org              = "kids-first"
    git_repo             = "kf-lambda-member-update"
    yor_trace            = "b9b526cb-3b99-4111-9650-e812f0e7f4d2"
  }
}

resource "aws_sns_topic_subscription" "sns_sqs_subscription" {
  topic_arn = aws_sns_topic.app_sns_notifications.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.kf_lambda_sqs.arn
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.app_sns_notifications.arn
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
        data.aws_caller_identity.current.account_id
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
      aws_sns_topic.app_sns_notifications.arn
    ]
  }
}
