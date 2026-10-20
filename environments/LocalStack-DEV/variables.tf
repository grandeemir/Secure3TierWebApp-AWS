variable "name" {
  type    = string
  default = "aws3tier-project"
}

variable "project_name" {
  type    = string
  default = "aws3tier"
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