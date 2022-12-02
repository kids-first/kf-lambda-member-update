resource "aws_cloudwatch_log_group" "app" {
  #checkov:skip=CKV_AWS_158:TODO-Add encryption to cloudwatch log group
  name              = "apps-${var.environment}/${var.application}"
  retention_in_days = 90
  tags = {
    git_commit           = "91c80656a306a7a32bc611d97286f3719b2fbcb0"
    git_file             = "deployment/terraform/cloudwatch.tf"
    git_last_modified_at = "2022-11-01 18:05:43"
    git_last_modified_by = "blackdenc@chop.edu"
    git_modifiers        = "blackdenc"
    git_org              = "kids-first"
    git_repo             = "kf-lambda-member-update"
    yor_trace            = "f1ed3785-e12a-4eb7-b3d7-dbed6eb95ce4"
  }
}