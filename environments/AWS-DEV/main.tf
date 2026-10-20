
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
  redis_endpoint           = module.elasticache.primary_endpoint_address
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


module "s3_static" {
  source = "../../modules/s3_static"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "waf" {
  source = "../../modules/waf"

  providers = {
    aws = aws.us_east_1
  }

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  project_name = var.project_name
  environment  = var.environment

  alb_dns_name   = module.elb_http.web_alb_dns_name
  s3_domain_name = module.s3_static.bucket_regional_domain_name

  application_domain = local.application_domain

  acm_certificate_arn = aws_acm_certificate_validation.cloudfront.certificate_arn

  waf_web_acl_arn = module.waf.web_acl_arn

  tags = local.common_tags
}

module "route53" {
  source = "../../modules/route53"

  domain_name = var.domain_name
  subdomain   = "app"

  cloudfront_domain_name = module.cloudfront.distribution_domain_name
  cloudfront_zone_id     = module.cloudfront.distribution_hosted_zone_id
}

resource "aws_s3_bucket_policy" "static" {
  bucket = module.s3_static.bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "AllowCloudFrontRead"
      Effect   = "Allow"
      Action   = "s3:GetObject"
      Resource = "${module.s3_static.bucket_arn}/*"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = module.cloudfront.distribution_arn
        }
      }
    }]
  })

  depends_on = [
    module.s3_static
  ]
}

module "elasticache" {
  source = "../../modules/elasticache"

  project_name               = var.project_name
  environment                = var.environment
  private_subnet_ids         = module.vpc.private_subnets
  security_group_id          = module.vpc.elasticache_sg
  engine                     = "redis"
  engine_version             = "7.1"
  node_type                  = "cache.t4g.micro"
  num_cache_nodes            = 2
  automatic_failover_enabled = true
  multi_az_enabled           = true

  tags = local.common_tags
}
