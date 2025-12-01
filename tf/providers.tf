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

  default_tags {
    tags = {
      env     = "cluster"
      managed_by = "ansible"
    }
  }
}

provider "vault" {
  address = "https://vault.home.youriulbri.ch:8200"
  skip_child_token = true

  auth_login {
    path = "auth/kubernetes/login"

    parameters = {
      role = "tofu-runner"
    }
  }
}