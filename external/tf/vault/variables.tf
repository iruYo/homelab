variable "vault_address" {
  type        = string
  description = "Vault address"
}

variable "vault_token" {
  type        = string
  sensitive   = true
  description = "Token for authenticating to Vault"
}

variable "vault_root_username" {
  type = string
  default = "vault-root"
  description = "Username of the Vault AWS root configuration"
}