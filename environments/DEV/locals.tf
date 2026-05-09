locals {
  common_tags = {
    project     = "${var.project_name}-vpc"
    environment = "development"
    terraform   = "true"
  }
}