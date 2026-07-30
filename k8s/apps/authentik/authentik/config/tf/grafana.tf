data "authentik_property_mapping_provider_scope" "this" {
  managed_list = [
    "goauthentik.io/providers/oauth2/scope-email",
    "goauthentik.io/providers/oauth2/scope-profile",
    "goauthentik.io/providers/oauth2/scope-openid",
    "goauthentik.io/providers/oauth2/scope-offline_access"
  ]
}

resource "authentik_provider_oauth2" "grafana" {
  name                       = "Grafana"
  client_id                  = var.grafana_client_id
  client_secret              = var.grafana_client_secret

  authorization_flow         = data.authentik_flow.default-provider-authorization-implicit-consent.id
  invalidation_flow          = data.authentik_flow.default-provider-invalidation-flow.id

  allowed_redirect_uris      = [
    {
      matching_mode = "strict",
      url           = "https://grafana.${var.domain}/login/generic_oauth",
    }
  ]

  signing_key                = data.authentik_certificate_key_pair.this.id
  issuer_mode                = "per_provider"
  sub_mode                   = "hashed_user_id"
  property_mappings          = data.authentik_property_mapping_provider_scope.this.ids
}

resource "authentik_application" "grafana" {
  name              = "Grafana"
  slug              = "grafana"
  protocol_provider = authentik_provider_oauth2.grafana.id
  meta_icon         = "https://raw.githubusercontent.com/grafana/grafana/main/public/img/icons/mono/grafana.svg"
  meta_launch_url   = "https://grafana.${var.domain}"
  open_in_new_tab   = true
}