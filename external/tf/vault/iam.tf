data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "allow_s3" {
  statement {
    sid    = "AllowS3"
    effect = "Allow"

    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPolicy",
      "s3:GetBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:PutBucketCORS"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowS3Object"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "allow_s3" {
  name        = "S3Access"
  description = "Provides access to manage S3 buckets"
  policy      = data.aws_iam_policy_document.allow_s3.json
}

data "aws_iam_policy_document" "allow_vault_root" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/${var.vault_root_username}"]
    }
  }
}

resource "aws_iam_role" "vault_s3" {
  name               = "vault-s3"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.allow_vault_root.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.vault_s3.name
  policy_arn = aws_iam_policy.allow_s3.arn
}

resource "vault_aws_secret_backend_role" "manage_s3" {
  backend         = "aws"
  name            = "manage-s3"
  credential_type = "assumed_role"

  role_arns       = [aws_iam_role.vault_s3.arn]
}