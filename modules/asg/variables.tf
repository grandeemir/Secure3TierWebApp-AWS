variable "name" {
  type    = string
  default = "3tier-vpc"
}

variable "project_name" {
  type    = string
  default = "ToDoApp"
}

variable "environment" {
  type = string
}

# Amazon Linux 2023
variable "ami_id" {
  type = string
  # default = "ami-0a59ec92177ec3fad"
}

variable "instance_type" {
  type = string
  # default = "t3.micro"
}

variable "web_sg" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "db_address" {
  type = string
}

variable "db_password" {
  type = string
}

variable "max_size" {
  type = string
}

variable "min_size" {
  type = string
}

variable "desired_capacity" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "backend_alb_dns_name" {
  type = string
}

variable "backend_servers_sg_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "backend_target_group_arn" {
  type = string
}