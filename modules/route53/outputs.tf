
output "application_domain" {
  description = "Application hostname"
  value       = aws_route53_record.app.fqdn
}

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID"
  value       = data.aws_route53_zone.main.zone_id
}
