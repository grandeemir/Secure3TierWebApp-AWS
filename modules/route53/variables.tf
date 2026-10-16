variable "domain_name" {
  type = string
}

variable "subdomain" {
  type    = string
  default = "app"
}

variable "cloudfront_domain_name" {
  type = string
}

variable "cloudfront_zone_id" {
  type = string
}