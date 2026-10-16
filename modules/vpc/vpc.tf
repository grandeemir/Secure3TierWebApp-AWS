module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = "10.0.0.0/16"

  azs                          = ["us-east-1a", "us-east-1b"]
  private_subnets              = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets             = ["10.0.5.0/24", "10.0.6.0/24"]
  create_database_subnet_group = true
  database_subnet_group_name   = "${var.name}-db-subnet-group"
  public_subnets               = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway      = true
  enable_vpn_gateway      = false
  map_public_ip_on_launch = true

  tags = var.tags
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-alb-sg"
  }
}

resource "aws_security_group" "backend_alb_sg" {
  name        = "${var.name}-backend-alb-sg"
  description = "Security group for Backend ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow HTTP traffic from web servers"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "${var.name}-web-sg"
  description = "Security group for web servers"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow HTTP traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_servers_sg" {
  name        = "${var.name}-backend-sg"
  description = "Security group for backend servers"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow HTTP traffic from backend ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_alb_sg.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.name}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow MySQL traffic from backend servers"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_servers_sg.id]
  }
  tags = {
    Name = "${var.name}-rds-sg"
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}