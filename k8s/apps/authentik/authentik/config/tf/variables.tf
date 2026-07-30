variable "AUTHENTIK_BOOTSTRAP_TOKEN" {
  type      = string
  sensitive = true
}

variable "discord_client_id" {
  type      = string
  sensitive = true
}

variable "discord_client_secret" {
  type      = string
  sensitive = true
}

variable "domain" {
  type      = string
}

variable "email" {
  type      = string
}

variable "grafana_client_id" {
  type      = string
  sensitive = true
}

variable "grafana_client_secret" {
  type      = string
  sensitive = true
}

variable "github_client_id" {
  type      = string
  sensitive = true
}

variable "github_client_secret" {
  type      = string
  sensitive = true
}