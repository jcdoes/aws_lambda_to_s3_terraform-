terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.23.1"
    }
  }
}

provider "aws" {
  max_retries         = 1
  region              = var.region
  shared_config_files = ["/Users/<username>/.aws/config"]
  profile             = "<profile_name>"
}

module "up-lambda" {
  source                                = "./up-lambda"
  region                                = var.region
  tags                                  = var.tags
}

module "up-s3" {
  source                                = "./up-s3"
  tags                                  = var.tags
  bucket_name                           = var.bucket_name
}