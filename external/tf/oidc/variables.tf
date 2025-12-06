variable "oidc_bucket_name" {
  type        = string
  description = "OIDC S3 bucket name"
}

variable "oidc_jwks_keys" {
  type        = string
  description = "JWKS OIDC keys in json format"
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