terraform {
  required_version = "~> 1.5.0"

  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2026.5.0"
    }
  }
}

provider "authentik" {
  url   = "http://authentik-server.authentik.svc"
  token = var.AUTHENTIK_BOOTSTRAP_TOKEN
}