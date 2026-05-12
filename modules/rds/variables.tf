variable "db_subnet_ids" {
  description = "Subnet list from VPC module for RDS subnet group"
  type        = list(string)
}

variable "rds_security_group_id" {
  description = "RDS Security Group ID from VPC module"
  type        = string
}