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
    key    = "prod/cluster/cert-manager/terraform.tfstate"
  }
}

provider "vault" {
  address = "https://vault.home.youriulbri.ch:8200"
  skip_child_token = true

  auth_login {
    path = "auth/kubernetes/login"

    parameters = {
      role = "tf-runner"
    }
  }
}

data "vault_aws_access_credentials" "this" {
  backend = "aws"
  role    = "cert-manager" # kubernetes auth role name
}

provider "aws" {
  region     = "eu-central-1"
  access_key = data.vault_aws_access_credentials.this.access_key
  secret_key = data.vault_aws_access_credentials.this.secret_key
}