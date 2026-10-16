output "rds_endpoint" {
  value = aws_db_instance.primary_db.endpoint
}

output "db_address" {
  value = aws_db_instance.primary_db.address
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}