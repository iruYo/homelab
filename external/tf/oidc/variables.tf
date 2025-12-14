variable "vault_address" {
  type        = string
  description = "Vault address"
}

variable "vault_token" {
  type        = string
  sensitive   = true
  description = "Token for authenticating to Vault"
}