resource "aws_iam_user" "this" {
  name = var.tf_state_manager_username
}

data "aws_iam_policy_document" "allow_users_to_assume" { # Who is allowed to assume this role
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.this.arn]
    }
  }
}

resource "aws_iam_role" "this" {
  name = "ManageTerraformStateS3Bucket"

  assume_role_policy = data.aws_iam_policy_document.allow_users_to_assume.json
}

data "aws_iam_policy_document" "allowed_roles_to_assume" { # Which roles am I allowed to assume
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [aws_iam_role.this.arn]
  }
}

resource "aws_iam_user_policy" "this" {
  name = "AllowAssumingTerraformStateS3Managing"
  user = aws_iam_user.this.name

  policy = data.aws_iam_policy_document.allowed_roles_to_assume.json
}


data "aws_iam_policy_document" "s3_tf_object_access" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.tf_state_bucket}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${var.tf_state_bucket}/*"
    ]
  }
}

resource "aws_iam_role_policy" "this" {
  name = "S3AllowTarraformStateObjectManagement"
  role = aws_iam_role.this.id

  policy = data.aws_iam_policy_document.s3_tf_object_access.json
}