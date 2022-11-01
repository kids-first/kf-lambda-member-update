module "network" {
  source        = "git@github.com:kids-first/aws-infra-network-module?ref=master"
  organization  = var.organization
  environment   = var.environment
  subnet_prefix = "apps"
  azs           = var.azs
}
