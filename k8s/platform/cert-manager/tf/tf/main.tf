data "aws_caller_identity" "this" {}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC Provider ARN"
}

module "irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.0.0"

  name   = "cert-manager"

  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/*"]
  permissions_boundary          = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/IAMBoundary"

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }

  tags = {
    user = "cert-manager"
  }
}

resource "kubernetes_config_map" "cert_manager_arn" {
  metadata {
    name      = "cert-manager-iam-config"
    namespace = "cert-manager"
    labels    = {
      "reconcile.fluxcd.io/watch" = "Enabled"
    }
  }

  data = {
    "cert-manager-iam-values.yml" = yamlencode({
      serviceAccount = {
        create = true,
        annotations = {
          "eks.amazonaws.com/role-arn" = module.irsa.arn
        }
      }

      # Add pod annotation to trigger pod restart for eks webhook
      podAnnotations = {
        "checksum/irsa-role-arn" = module.irsa.arn
      }
    })
  }
}
