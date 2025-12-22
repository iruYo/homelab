resource "authentik_brand" "this" {
  domain         = var.authentik_url
  default        = false

  branding_title = "authentik"
#  branding_logo                    = ""
#  branding_favicon                 = ""
#  branding_default_flow_background = ""

  flow_authentication = authentik_flow.authentication.uuid
  flow_invalidation   = data.authentik_flow.default_invalidation.id
}