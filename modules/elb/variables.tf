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

variable "public_subnets" {
  type = list(string)
}

variable "alb_sg" {
  type = string
}

variable "vpc_id" {
  type = string
}