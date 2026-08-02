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

resource "vault_kv_secret_v2" "cert_manager_irsa" {
  mount      = "secret"
  name       = "k8s/infra/irsa/cert-manager"
  data_json  = jsonencode({
    role_arn = module.cert_manager_irsa.arn
  })
}