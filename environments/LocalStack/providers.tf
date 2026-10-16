terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    ec2                  = "http://localhost:4566"
    elasticloadbalancing = "http://localhost:4566"
    autoscaling          = "http://localhost:4566"
    rds                  = "http://localhost:4566"
    s3                   = "http://localhost:4566"
    iam                  = "http://localhost:4566"
    sts                  = "http://localhost:4566"
    route53              = "http://localhost:4566"
    cloudfront           = "http://localhost:4566"
    wafv2                = "http://localhost:4566"
    acm                  = "http://localhost:4566"
    cloudwatch           = "http://localhost:4566"
    logs                 = "http://localhost:4566"
    secretsmanager       = "http://localhost:4566"
    ssm                  = "http://localhost:4566"
    kms                  = "http://localhost:4566"
  }

  default_tags {
    tags = {
      Project     = "Secure3TierWebApp"
      Environment = "LOCAL"
      ManagedBy   = "Terraform"
    }
  }
}
