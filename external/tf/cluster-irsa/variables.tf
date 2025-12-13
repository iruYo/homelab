variable "oidc_data_secret_path" {
  type        = string
  description = "Path to the OIDC data in Vault secrets"
  sensitive   = true
}

variable "vault_address" {
  type        = string
  description = "Vault address"
}

variable "vault_token" {
  type        = string
  sensitive   = true
  description = "Token for authenticating to Vault"
}