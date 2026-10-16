output "vpc_id" {
  value = module.vpc.vpc_id
}

output "backend_alb_sg" {
  value = aws_security_group.backend_alb_sg.id
}

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

output "backend_servers_sg_id" {
  value = aws_security_group.backend_servers_sg.id
}

output "database_subnets" {
  value = module.vpc.database_subnets
}