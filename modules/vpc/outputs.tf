output "vpc_id" {
  value = module.vpc.vpc_id
}

# modules/vpc/outputs.tf

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "alb_sg" {
  value = aws_security_group.alb_sg
}

output "web_sg" {
  value = aws_security_group.web_sg
}

output "rds_sg" {
  value = aws_security_group.rds_sg
}

output "database_subnets" {
  value = module.vpc.database_subnets
}