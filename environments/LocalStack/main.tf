module "vpc" {
  source       = "../../modules/vpc"
  name         = "dev-vpc"
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "rds" {
  source                = "../../modules/rds"
  db_subnet_ids         = module.vpc.database_subnets
  rds_security_group_id = module.vpc.rds_sg.id
  db_name               = "ToDoAppDB"
  username              = "admin"
}

module "web_asg" {
  source                   = "../../modules/asg"
  name                     = "${var.name}-asg"
  environment              = var.environment
  project_name             = var.project_name
  max_size                 = "4"
  min_size                 = "2"
  desired_capacity         = "2"
  ami_id                   = "ami-0a59ec92177ec3fad"
  instance_type            = "t2.micro"
  target_group_arn         = module.elb_http.target_group_arn
  web_sg                   = module.vpc.web_sg.id
  public_subnets           = module.vpc.public_subnets
  db_address               = module.rds.db_address
  db_password              = module.rds.db_password
  backend_alb_dns_name     = module.elb_http.backend_alb_dns_name
  backend_servers_sg_id    = module.vpc.backend_servers_sg_id
  private_subnets          = module.vpc.private_subnets
  backend_target_group_arn = module.elb_http.backend_target_group_arn
  tags                     = local.common_tags
}

module "elb_http" {
  source          = "../../modules/elb"
  vpc_id          = module.vpc.vpc_id
  project_name    = var.project_name
  environment     = var.environment
  public_subnets  = module.vpc.public_subnets
  alb_sg          = module.vpc.alb_sg.id
  backend_alb_sg  = module.vpc.backend_alb_sg
  private_subnets = module.vpc.private_subnets
  tags            = local.common_tags
}