data "aws_caller_identity" "this" {}

resource "aws_iam_user" "vault_root" {
  name = var.vault_root_username
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid       = "AllowAssumeRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/vault-*"]
  }
}

resource "aws_iam_policy" "vault_root" {
  name    = "AssumeVaultRole"
  path    = "/"
  policy  = aws_iam_policy_document.assume_role.json
}