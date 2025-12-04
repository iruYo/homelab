terraform {
  required_version = "~> 1.13.0"

  backend "s3" {
    region = "eu-central-1"
    key    = "prod/cluster/external-secrets/terraform.tfstate"
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