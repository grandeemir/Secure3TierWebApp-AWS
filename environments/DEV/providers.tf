terraform {
  required_version = ">= 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket         = "my-terraform-state-01419a9d"
    key            = "secure3tierwebapp/DEV/terraform.tfsate"
    dynamodb_table = "terraform-state-locks"
    region         = "us-east-1"
  }
}