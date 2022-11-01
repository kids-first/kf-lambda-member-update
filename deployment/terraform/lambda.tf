resource "aws_cloudwatch_log_group" "app" {
  name              = "apps-${var.environment}/${var.application}"
  retention_in_days = 90
  tags = {
    git_commit           = "85cdabefb205a2f15f8862f28766e51ebd8807ea"
    git_file             = "deployment/terraform/lambda.tf"
    git_last_modified_at = "2022-11-01 18:05:43"
    git_last_modified_by = "blackdenc@chop.edu"
    git_modifiers        = "blackdenc"
    git_org              = "kids-first"
    git_repo             = "kf-lambda-member-update"
    yor_trace            = "f1ed3785-e12a-4eb7-b3d7-dbed6eb95ce4"
  }
}

resource "aws_lambda_event_source_mapping" "kf_lambda_source_mapping" {
  event_source_arn = aws_sqs_queue.kf_lambda_sqs.arn
  function_name    = aws_lambda_function.kf_lambda_function.function_name
}

data "aws_ecr_repository" "ecr" {
  name = var.ecr_name
}

resource "aws_lambda_function" "kf_lambda_function" {
  function_name = "${var.application}-${var.environment}"
  description   = "This lambda receive events from the SQS queue that contains users from persona."
  role          = aws_iam_role.aws_lambda_role.arn

  package_type = "Image"
  image_uri    = "${data.aws_ecr_repository.ecr.repository_url}:${var.lambda_version}"

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory

  tags = {
    env         = var.environment
    application = var.application
    yor_trace   = "3c5d7f53-f09f-4222-8e9e-10cf77e969e8"
  }

  environment {
    variables = {
      es_host   = var.es_host
      es_scheme = "https"
      es_port   = "443"
    }
  }

  vpc_config {
    subnet_ids         = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id, data.aws_subnet.subnet3.id, data.aws_subnet.subnet4.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}
