data "aws_iam_policy_document" "this" {
  # https://cert-manager.io/docs/configuration/acme/dns01/route53/#set-up-an-iam-policy
  statement {
    effect = "Allow"
    actions   = ["route53:GetChange"]
    resources = ["arn:aws:route53:::change/*"]
  }

  statement {
    effect = "Allow"
    actions   = ["route53:ChangeResourceRecordSet", "route53:ListResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "route53:ChangeResourceRecordSetsRecordTypes"
      values = ["TXT"]
    }
  }

  statement {
    actions   = ["route53:ListHostedZonesByName"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "this" {
  name   = "route53-change-record-sets"
  path   = "/"

  policy = data.aws_iam_policy_document.this.json

  tags = {
    user = "cert-manager"
  }
}
