module "vpc" {
  source       = "../../modules/vpc"
  name         = "dev-vpc"
  project_name = var.project_name
  environment  = var.environment
}

module "rds" {
  source                = "../../modules/rds"
  db_subnet_ids         = module.vpc.database_subnets
  rds_security_group_id = module.vpc.rds_sg.id
}

module "asg" {
  source         = "../../modules/asg"
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  name           = "${var.name}-asg"
  environment    = var.environment
  web_sg         = module.vpc.web_sg.id
  public_subnets = module.vpc.public_subnets
  db_address     = module.rds.db_address
  db_password    = module.rds.db_password
}