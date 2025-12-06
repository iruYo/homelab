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
    key    = "prod/k3s/cert-manager/terraform.tfstate"
  }
}

provider "kubernetes" {}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      env        = "cluster"
      managed_by = "tofu-controller"
    }
  }
}
