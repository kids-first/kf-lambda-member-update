resource "aws_lambda_event_source_mapping" "kf_lambda_source_mapping" {
  event_source_arn = aws_sqs_queue.kf_lambda_sqs.arn
  function_name    = aws_lambda_function.kf_lambda_function.function_name
}

data "aws_ecr_repository" "ecr" {
  name = var.ecr_name
}

resource "aws_lambda_function" "kf_lambda_function" {
  #checkov:skip=CKV_AWS_272:No definition for this rule
  #checkov:skip=CKV_AWS_116:TODO-Add dead-letter queue
  #ts:skip=AWS.LambdaFunction.LM.MEIDUM.0063 Policy is defined in attached lambda role
  function_name = "${var.application}-${var.environment}"
  description   = "This lambda receive events from the SQS queue that contains users from persona."
  role          = aws_iam_role.aws_lambda_role.arn
  kms_key_arn   = aws_kms_key.sqs_sns_key.arn

  reserved_concurrent_executions = 100

  package_type = "Image"
  image_uri    = "${data.aws_ecr_repository.ecr.repository_url}:${var.lambda_version}"

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      es_host   = var.es_host
      es_scheme = "https"
      es_port   = "443"
    }
  }

  vpc_config {
    subnet_ids         = module.network.private_subnets
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = {
    env                  = var.environment
    application          = var.application
    yor_trace            = "3c5d7f53-f09f-4222-8e9e-10cf77e969e8"
    git_commit           = "91c80656a306a7a32bc611d97286f3719b2fbcb0"
    git_file             = "deployment/terraform/lambda.tf"
    git_last_modified_at = "2022-11-01 18:05:43"
    git_last_modified_by = "blackdenc@chop.edu"
    git_modifiers        = "blackdenc"
    git_org              = "kids-first"
    git_repo             = "kf-lambda-member-update"
  }
}
