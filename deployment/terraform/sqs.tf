# sqs.tf

resource "aws_sqs_queue" "kf_lambda_sqs" {
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
    git_commit           = "85cdabefb205a2f15f8862f28766e51ebd8807ea"
    git_file             = "deployment/terraform/sqs.tf"
    git_last_modified_at = "2022-11-01 18:05:43"
    git_last_modified_by = "blackdenc@chop.edu"
    git_modifiers        = "blackdenc"
    git_org              = "kids-first"
    git_repo             = "kf-lambda-member-update"
    yor_trace            = "4b2b9ae8-a1b5-408f-ae9e-0dce292582d9"
  }
  kms_master_key_id = "alias/aws/sqs"
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.kf_lambda_sqs.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.kf_lambda_sqs.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.app_sns_notifications.arn}"
        }
      }
    }
  ]
}
POLICY
}
