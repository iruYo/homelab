data "vault_kv_secret_v2" "oidc" {
  mount = "secret"
  name  = var.oidc_data_secret_path
}

resource "vault_kv_secret_v2" "oidc_provisioner" {
  mount                      = "secret"
  name                       = "${var.oidc_data_secret_path}/provisioner"
  data_json                  = jsonencode({
    role_arn = module.irsa.arn
  })
}
