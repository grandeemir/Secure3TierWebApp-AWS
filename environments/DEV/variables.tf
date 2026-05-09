variable "name" {
  type    = string
  default = "3tier-vpc"
}

variable "project_name" {
  type    = string
  default = "ToDoApp"
}

# Amazon Linux 2023
variable "ami_id" {
  type    = string
  default = "ami-0ed094fb1304fd857"
}

variable "instance_type" {
  default = "t3.micro"
}