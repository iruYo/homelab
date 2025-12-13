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

resource "aws_iam_policy" "iam_boundary" {
  name = "IAMBoundary"
  path   = "/"
  policy = data.aws_iam_policy_document.iam_boundary.json
}


data "aws_iam_policy_document" "provision_iam" {
  statement {
    sid       = "RestrictedIAMAccessWithBoundary"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:CreateRole",
      "iam:UpdateRole",
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values   = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/${aws_iam_policy.iam_boundary.name}"]
    }
  }

  statement {
    sid       = "RestrictedIAMAccess"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:AttachRolePolicy",
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListPolicyVersions",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:TagRole",
      "iam:TagPolicy",
      "iam:UntagRole",
      "iam:UntagPolicy",
    ]
  }
}

resource "aws_iam_policy" "provision_iam" {
  name   = "VaultIAMProvision"
  path   = "/"
  policy = data.aws_iam_policy_document.provision_iam.json
}

module "irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.0.0"

  name                  = "vault-tf-runner"
  trust_condition_test  = "StringLike"

  oidc_providers = {
    main = {
      provider_arn               = data.vault_kv_secret_v2.oidc.data["provider_arn"]
      namespace_service_accounts = ["*:tf-runner"]
    }
  }

  policies = {
    policy = aws_iam_policy.provision_iam.arn
  }
}