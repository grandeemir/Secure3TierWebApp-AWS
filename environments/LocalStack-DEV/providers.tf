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
  region                      = "us-east-1"
  alias                       = "n-virginia"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    ec2                  = "http://10.147.20.85:4566"
    elasticloadbalancing = "http://10.147.20.85:4566"
    autoscaling          = "http://10.147.20.85:4566"
    rds                  = "http://10.147.20.85:4566"
    s3                   = "http://10.147.20.85:4566"
    iam                  = "http://10.147.20.85:4566"
    sts                  = "http://10.147.20.85:4566"
    route53              = "http://10.147.20.85:4566"
    cloudfront           = "http://10.147.20.85:4566"
    wafv2                = "http://10.147.20.85:4566"
    acm                  = "http://10.147.20.85:4566"
    cloudwatch           = "http://10.147.20.85:4566"
    logs                 = "http://10.147.20.85:4566"
    secretsmanager       = "http://10.147.20.85:4566"
    ssm                  = "http://10.147.20.85:4566"
    kms                  = "http://10.147.20.85:4566"
  }

  default_tags {
    tags = {
      Project     = "Secure3TierWebApp"
      Environment = "LOCAL"
      ManagedBy   = "Terraform"
    }
  }
}
