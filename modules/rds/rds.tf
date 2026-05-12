# 1. Create a random password for the RDS instance
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "my-3tier-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "My 3-Tier DB Subnet Group"
  }
}

# 3. Main RDS MySQL Instance (Multi-AZ Active)
resource "aws_db_instance" "primary_db" {
  identifier            = "my-3tier-mysql-primary"
  allocated_storage     = 20
  max_allocated_storage = 100 # Otomatik depolama alanı artırımı
  storage_type          = "gp3"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  db_name               = "appdatabase"
  username              = "admin"
  password              = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [var.rds_security_group_id] # Security group for RDS allowing traffic from web servers

  # STANDBY REPLICA 
  multi_az = true

  backup_retention_period = 7
  backup_window           = "03:00-04:00"

  # For production it should be false. 
  skip_final_snapshot = true

  tags = {
    Environment = "Production"
    Project     = "3-Tier Web App"
  }
}
