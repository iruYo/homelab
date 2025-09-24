terraform {
  required_version = "~> 1.13.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.14.0"
    }
  }

  backend "s3" {
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}
