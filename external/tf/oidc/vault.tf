data "vault_kv_secret_v2" "sa" {
  mount = "secret"
  name  = "k8s/talos/service-account"
}

resource "vault_kv_secret_v2" "oidc" {
  mount                      = "secret"
  name                       = "ansible/k8s/oidc"
  data_json                  = jsonencode({
    bucket_name  = aws_s3_bucket.this.id
    provider_arn = module.iam_oidc_provider.arn,
    url          = "https://${aws_s3_bucket.this.bucket_domain_name}"
  })
}
