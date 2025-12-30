terraform {
  required_version = "~> 1.5.0"

  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2025.10.1"
    }
  }
}

provider "authentik" {
  url   = "http://authentik-server.authentik.svc"
  token = var.AUTHENTIK_BOOTSTRAP_TOKEN
}