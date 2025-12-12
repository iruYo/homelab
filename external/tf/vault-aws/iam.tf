data "aws_caller_identity" "this" {}

resource "aws_iam_user" "this" {
  name = var.vault_root_username
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowAssumeRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/vault-*"]
  }

  statement {
    sid    = "AllowSelfRotation"
    effect = "Allow"
    actions = [
      "iam:GetUser",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey"
    ]

    resources = [aws_iam_user.this.arn]
  }
}

resource "aws_iam_policy" "this" {
  name    = "AssumeVaultRole"
  path    = "/"
  policy  = data.aws_iam_policy_document.this.json
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}