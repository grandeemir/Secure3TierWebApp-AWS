variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "iam_role" {
  description = "The IAM role object for VPC flow logs"
  type        = any  # This allows the object to pass through
}

variable "vpc_flow_logs" {
  description = "The CloudWatch log group object"
  type        = any  # This allows the object to pass through
}