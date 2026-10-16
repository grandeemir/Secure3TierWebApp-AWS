variable "name" {
  type    = string
  default = "3tier-vpc"
}

variable "project_name" {
  type    = string
  default = "ToDoApp"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "domain_name" {
  type    = string
  default = "aws3tier.site"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}