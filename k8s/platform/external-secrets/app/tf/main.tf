resource "vault_auth_backend" "this" {
  type = "kubernetes"
}

resource "vault_policy" "this" {
  name = "k8s-external-secrets-policy"

  policy = <<EOT
path "secret/data/k3s/*" {
  capabilities = ["create", "read", "update"]
}

path "secret/metadata/k3s/*" {
  capabilities = [ "update" ]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "this" {
  backend                          = vault_auth_backend.this.path
  role_name                        = "k8s-external-secrets"
  bound_service_account_names      = ["external-secrets"]
  bound_service_account_namespaces = ["external-secrets"]
  token_policies                   = [vault_policy.this.name]
}
