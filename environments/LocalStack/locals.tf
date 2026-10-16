locals {
  common_tags = {
    project     = "${var.project_name}-vpc"
    environment = var.environment # change this to match your environment
    terraform   = "true"
  }
}