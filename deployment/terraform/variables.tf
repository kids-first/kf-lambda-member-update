variable "environment" {
  description = "Dev/QA/QC/Prd"
  type        = string
}

variable "application" {
  description = "Name of the application"
  default     = "kf-lambda-member-update"
}

variable "organization" {
  description = "Organization deploying this application"
  default     = "kf-strides"
}

variable "region" {
  description = "AWS region to deploy to"
  default     = "us-east-1"
}

variable "payload_bucket" {
  description = "Name of bucket to push files to"
}

variable "lambda_timeout" {
  description = "Default timeout for lambda response"
  default     = "60"
}

variable "lambda_memory" {
  description = "Memory allocated to lambda function"
  default     = "256"
}

variable "lambda_version" {
  description = "Git Commit generated at build time"
  type        = string
}

variable "security_group_name" {
  description = "Name for dataservice security group"
}

variable "es_host" {
  description = "Hostname for elasticsearch domain"
}

variable "aws_cidr" {
  description = "Which CIDR range to allow ingress traffic from"
  default     = ["0.0.0.0/0"]
}

variable "ecr_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "kf-strides-member-updates-lambda"
}

variable "azs" {
  type    = list(any)
  default = ["a", "b", "c", "e"]
}
