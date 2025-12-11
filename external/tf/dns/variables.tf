variable "domain" {
  type = string
  default = "youriulbri.ch"
  description = "Domain name"
}

variable "dns01_user_name" {
  type = string
  default = "vault-dns01"
  description = "Username responsible for vault DNS01 challenge"
}
