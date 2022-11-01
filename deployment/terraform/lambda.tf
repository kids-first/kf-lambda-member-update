resource "aws_cloudwatch_log_group" "app" {
  name              = "apps-${var.environment}/${var.application}"
  retention_in_days = 90
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../.."
  output_path = "${path.module}/lambda.zip"
  excludes = [
    "deployment",
    "scripts",
    ".git",
    "tests",
    ".github",
    ".dockerignore",
    ".gitignore",
    "Jenkinsfile",
    "Dockerfile-dev",
    "README.md",
    "docker-compose.yml",
  ]
}

# data "archive_file" "lambda_layer_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/../../venv/lib/python3.7/site-packages"
#   output_path = "${path.module}/lambda_layer.zip"
# }

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "${path.module}/python.zip"
  layer_name = "member_updates_layer_2"

  compatible_runtimes = ["python3.9"]
}

resource "aws_lambda_event_source_mapping" "kf-lambda-source-mapping" {
  event_source_arn = aws_sqs_queue.kf_lambda_sqs.arn
  function_name    = aws_lambda_function.kf_lambda_function.function_name
}
