terraform {
  required_version = "~> 1.13.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.14.0"
    }

    vault = {
      source = "hashicorp/vault"
      version = "~> 5.6.0"
    }
  }

  backend "s3" {
    region = "eu-central-1"
    key    = "prod/oidc/terraform.tfstate"
  }
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token

  skip_child_token = true
}

#data "vault_aws_access_credentials" "this" {
#  backend = "aws"
#  role    = "manage-s3"
#  type    = "sts"
#}

provider "aws" {
  region  = "eu-central-1"

  default_tags {
    tags = {
      managed_by = "ansible"
    }
  }
}
