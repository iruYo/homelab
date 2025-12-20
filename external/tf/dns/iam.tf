data "aws_iam_policy_document" "this" {
  statement {
    sid    = "ListHostedZones"
    effect = "Allow"

    actions = ["route53:ListHostedZones"]

    resources = ["*"]
  }

  statement {
    sid    = "ReadHostedZoneAndRecords"
    effect = "Allow"

    actions = [
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets"
    ]

    resources = ["arn:aws:route53:::hostedzone/${aws_route53_zone.sld.zone_id}"]
  }

  statement {
    sid    = "ChangeAcmeChallengeRecord"
    effect = "Allow"

    actions = ["route53:ChangeResourceRecordSets"]

    resources = ["arn:aws:route53:::hostedzone/${aws_route53_zone.sld.zone_id}"]

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "route53:ChangeResourceRecordSetsNormalizedRecordNames"
      values = ["_acme-challenge.vault.${aws_route53_zone.sld.name}"]
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = "route53_vault_dns01_challenge_policy"
  description = "Allow domain DNS01 challenge for vault"

  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_user" "this" {
  name = var.dns01_user_name
  path = "/"
}

resource "aws_iam_user_policy_attachment" "attach_dns" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}