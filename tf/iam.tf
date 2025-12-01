# TODO DEPLOY THE THNG
# AUTH TOFU CONTROLLER TO VAULT AS vault-admin
# LET TOFU CONTROLLER HANDLE CERT-MANAGER
# https://us-east-1.console.aws.amazon.com/iam/home?region=eu-central-1#

locals {
  policies = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
  ]
}

resource "aws_iam_user" "this" {
  name = "vault-admin"

  tags = {
    user = "vault"
  }
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each   = toset(local.policies)
  user       = aws_iam_user.this.name
  policy_arn = each.value
}
