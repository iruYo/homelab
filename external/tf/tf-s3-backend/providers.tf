terraform {
  required_version = "~> 1.13.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }

  backend "s3" {
    region = "eu-central-1"
    key    = "root/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      managed_by = "user"
    }
  }
}
