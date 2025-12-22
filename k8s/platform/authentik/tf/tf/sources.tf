resource "authentik_source_oauth" "github" {
  name                = "GitHub"
  slug                = "github"
  provider_type       = "github"

  consumer_key        = var.github_client_id
  consumer_secret     = var.github_client_secret

  access_token_url    = "https://github.com/login/oauth/access_token"
  authorization_url   = "https://github.com/login/oauth/authorize"
  profile_url         = "https://api.github.com/user"
  oidc_well_known_url = ""

  user_matching_mode  = "email_link"

  authentication_flow = data.authentik_flow.default_source_auth.id
  enrollment_flow     = authentik_flow.enrollment_denied.uuid
}
