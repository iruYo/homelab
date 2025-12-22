terraform {
  required_version = "~> 1.5.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

provider "kubernetes" {}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      managed_by = "tofu-controller"
    }
  }
}
