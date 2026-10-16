
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "s3_domain_name" {
  type = string
}

variable "application_domain" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "waf_web_acl_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
