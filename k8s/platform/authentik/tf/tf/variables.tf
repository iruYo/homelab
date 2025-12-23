variable "AUTHENTIK_BOOTSTRAP_TOKEN" {
  type      = string
  sensitive = true
}

variable "authentik_url" {
  type      = string
}

variable "discord_client_id" {
  type      = string
  sensitive = true
}

variable "discord_client_secret" {
  type      = string
  sensitive = true
}

variable "email" {
  type      = string
}

variable "github_client_id" {
  type      = string
  sensitive = true
}

variable "github_client_secret" {
  type      = string
  sensitive = true
}