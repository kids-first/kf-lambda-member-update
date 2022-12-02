# sqs.tf

resource "aws_sqs_queue" "kf_lambda_sqs" {
  #checkov:skip=CKV_AWS_27:TODO-Will need a seperate story for adding encryption to SQS
  #ts:skip=AWS.SQS.NetworkSecurity.High.0570 TODO-Will need a seperate story for adding encryption to SQS
  name                       = "lambda-${var.application}-${var.environment}-sqs"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10
  visibility_timeout_seconds = 60

  tags = {
    Name                 = "lambda-${var.application}-${var.environment}-sqs"
    Environment          = var.environment
    Application          = var.application
    git_commit           = "91c80656a306a7a32bc611d97286f3719b2fbcb0"
    git_file             = "deployment/terraform/sqs.tf"
    git_last_modified_at = "2022-11-01 18:05:43"
    git_last_modified_by = "blackdenc@chop.edu"
    git_modifiers        = "blackdenc"
    git_org              = "kids-first"
    git_repo             = "kf-lambda-member-update"
    yor_trace            = "4b2b9ae8-a1b5-408f-ae9e-0dce292582d9"
  }
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.kf_lambda_sqs.id
  policy    = data.aws_iam_policy_document.sqs_policy_document.json
}

data "aws_iam_policy_document" "sqs_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    resources = [
      aws_sqs_queue.kf_lambda_sqs.arn,
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.app_sns_notifications.arn]
    }
  }
}