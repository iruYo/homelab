resource "vault_kv_secret_v2" "oidc" {
  mount                      = "secret"
  name                       = "ansible/k3s/oidc"
  data_json                  = jsonencode({
    provider_arn = module.iam_oidc_provider.arn,
    role_arn     = module.irsa.arn
    url          = "https://${aws_s3_bucket.this.bucket_domain_name}"
  })
}
