resource "vault_aws_secret_backend_role" "this" {
  backend         = "secrets-aws"
  name            = "cert-manager"
  credential_type = "iam_user"
  policy_arns     = [aws_iam_policy.this.arn]
}