locals {
  sa_private_key_pem = base64decode(data.vault_kv_secret_v2.sa.data["key"])

  jwks = jsonencode({
    keys = [
      {
        use = "sig"
        alg = "RS256"
        kty = "RSA"
        kid = data.external.pub_der.result.der
        n   = data.external.modulus.result.modulus
        e   = "AQAB"
    }]
  })
}

resource "random_uuid" "this" {}

resource "aws_s3_bucket" "this" {
  bucket = "cluster-oidc-${random_uuid.this.result}"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "public_read_get_object" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.public_read_get_object.json

  depends_on = [aws_s3_bucket_public_access_block.this]
}

# https://docs.siderolabs.com/talos/v1.13/security/iam-roles-for-service-accounts
resource "aws_s3_object" "keys" {
  bucket  = aws_s3_bucket.this.id
  key     = "keys.json"
  content = local.jwks

  etag = md5(local.jwks)

  depends_on = [
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket_policy.this,
  ]
}

resource "aws_s3_object" "discovery" {
  bucket       = aws_s3_bucket.this.id
  key          = ".well-known/openid-configuration"
  content_type = "application/json"
  content      = jsonencode({
    issuer                                = "https://${aws_s3_bucket.this.bucket_domain_name}"
    jwks_uri                              = "https://${aws_s3_bucket.this.bucket_domain_name}/keys.json"
    authorization_endpoint                = "urn:kubernetes:programmatic_authorization"
    response_types_supported              = ["id_token"]
    subject_types_supported               = ["public"]
    id_token_signing_alg_values_supported = ["RS256"]
    claims_supported                      = ["sub", "iss"]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket_policy.this,
  ]
}

data "tls_public_key" "sa" {
  private_key_pem = local.sa_private_key_pem
}

data "external" "pub_der" {
  program = ["bash", "-c", <<EOF
set -euo pipefail
pem=$(jq -r .pem)
der=$(echo "$pem" | openssl pkey -pubin -inform PEM -outform DER | openssl dgst -sha256 -binary | base64 | tr -d '=' | tr '/+' '_-')
jq -n --arg der "$der" '{"der":$der}'
EOF
  ]
  query = { pem = data.tls_public_key.sa.public_key_pem  }
}

data "external" "modulus" {
  program = ["bash", "-c", <<EOF
set -euo pipefail
pem=$(jq -r .pem)
modulus=$(echo "$pem" | openssl rsa -inform PEM -modulus -noout | cut -d'=' -f2 | xxd -r -p | base64 | tr -d '=' | tr '/+' '_-')
jq -n --arg modulus "$modulus" '{"modulus":$modulus}'
EOF
  ]
  query = { pem = local.sa_private_key_pem }
}