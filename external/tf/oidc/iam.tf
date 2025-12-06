module "iam_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"

  url    = "https://${aws_s3_bucket.this.bucket_domain_name}"
}

module "irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"

  name   = "tf-runner"

  oidc_providers = {
    main = {
      provider_arn               = module.iam_oidc_provider.arn
      namespace_service_accounts = ["*:tf-runner"]
    }
  }

  policies = {
    policy = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}