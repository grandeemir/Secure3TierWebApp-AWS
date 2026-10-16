output "elb" {
  value = aws_lb.web_alb
}

output "target_group_arn" {
  value = aws_lb_target_group.web_tg.arn
}

output "backend_elb" {
  value = aws_lb.backend_alb
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.backend_tg.arn
}

output "backend_alb_dns_name" {
  value = aws_lb.backend_alb.dns_name
}

output "web_alb_dns_name" {
  description = "Public ALB DNS name"
  value       = aws_lb.web_alb.dns_name
}

output "web_alb_zone_id" {
  description = "Public ALB canonical hosted zone ID"
  value       = aws_lb.web_alb.zone_id
}
