variable "oidc_provider_arn" {
  type        = string
  description = "OIDC Provider ARN"
}

module "irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"

  name   = "cert-manager"

  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z03639181DGOGN4RUZ7O2"]

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
  }

  data = {
    "values.yml" = yamlencode({
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.irsa.arn
        }
      }
    })
  }
}
