output "launch_template" {
  value = aws_launch_template.web_server
}

output "vpc" {
  value = module.vpc
}