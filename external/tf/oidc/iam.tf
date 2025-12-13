module "iam_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "~> 6.0.0"

  url     = "https://${aws_s3_bucket.this.bucket_domain_name}"
}