variable "function_name" {
  default = "kf-lambda-member-update"
}

variable "environment" {
}

variable "application" {
  default = "kf-lambda-member-update"
}

variable "organization" {
  default = "kf-strides"
}

variable "region" {
  default = "us-east-1"
}

variable "bucket" {
  default = "kf-strides-remote-state-files"
}

variable "payload_bucket" {
  default = "kf-strides-devops-bucket"
}

variable "owner" {
  default = "d3b"
}

variable "lambda_handler" {
  default = "service.handler"
}

variable "secret_path" {
  default = "not_set"
}

variable "ssl_certificate_arn" {
  default = "arn:aws:acm:us-east-1:538745987955:certificate/5ea96727-f480-4f77-97bb-f9a9d4d9d1de"
}

variable "lambda_runtime" {
  default = "python3.9"
}

variable "lambda_timeout" {
  default = "60"
}

variable "lambda_memory" {
  default = "256"
}

variable "lambda_version" {
}

variable "slack_channels" {
  default = ""
}

variable "security_group_name" {
}

variable "es_host" {
  default = ""
}

variable "aws_cidr" {
  default = ["0.0.0.0/0"]
}
