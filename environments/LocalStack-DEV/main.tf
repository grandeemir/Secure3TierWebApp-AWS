module "vpc" {
  source       = "../../modules/vpc"
  name         = "dev-vpc"
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}
