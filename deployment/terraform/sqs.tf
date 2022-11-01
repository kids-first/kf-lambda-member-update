# sqs.tf

resource "aws_sqs_queue" "kf_lambda_sqs" {
  name                       = "lambda-${var.application}-${var.environment}-sqs"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10
  visibility_timeout_seconds = 60

  tags = {
    Name        = "lambda-${var.application}-${var.environment}-sqs"
    Environment = var.environment
    Application = var.application
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
          "aws:SourceArn": "${aws_sns_topic.app-sns-notifications.arn}"
        }
      }
    }
  ]
}
POLICY
}
