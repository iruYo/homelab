path "pki_int" {
  capabilities = ["read"]
}

path "pki_int/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
