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

# Keys can't be computed ahead of time, so they'll have to be managed by ansible after K3s master creation
#resource "aws_s3_object" "jwks" {
#  bucket       = aws_s3_bucket.this.id
#  key          = "keys.json"

#  content      = local.jwks_keys
#  content_type = "application/json"
#  etag         = md5(local.jwks_keys)
#}

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
}