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

variable "ami_id" {
  type    = string
  default = "ami-0ed094fb1304fd857"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}