data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "iam_boundary" {
  statement {
    sid       = "AllowAll"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["*"]
  }

  statement {
    sid       = "DenyIAMAccess"
    effect    = "Deny"
    resources = ["*"]

    actions = [
      "iam:Create*",
      "iam:Delete*",
      "iam:Update*",
      "iam:Put*",
      "iam:Attach*",
      "iam:Detach*",
      "organizations:*",
      "account:*",
    ]
  }
}

module "iam_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "~> 6.0.0"

  url     = "https://${aws_s3_bucket.this.bucket_domain_name}"
}

resource "aws_iam_policy" "iam_boundary" {
  name = "IAMBoundary"
  path   = "/"
  policy = aws_iam_policy_document.iam_boundary.json
}

data "aws_iam_policy_document" "provision_iam" {
  statement {
    sid       = "RestrictedIAMAccess"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:UpdateRole",
      "iam:TagRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values   = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/${aws_iam_policy.iam_boundary.name}"]
    }
  }

  statement {
    sid       = "AllowPassingRoles"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:PassRole"]
  }

  statement {
    sid       = "ReadBoundary"
    effect    = "Allow"
    resources = [aws_iam_policy.iam_boundary.arn]
    actions   = ["iam:GetPolicy", "iam:GetPolicyVersion"]
  }
}

resource "aws_iam_policy" "provision_iam" {
  name   = "VaultIAMProvision"
  path   = "/"
  policy = aws_iam_policy_document.provision_iam.json
}

module "irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.0.0"

  name    = "tf-runner"

  oidc_providers = {
    main = {
      provider_arn               = module.iam_oidc_provider.arn
      namespace_service_accounts = ["*:tf-runner"]
    }
  }

  policies = {
    policy = aws_iam_policy.provision_iam.arn
  }
}