resource "authentik_flow" "authentication" {
  name               = "authentication-flow"
  title              = "Welcome!"
  slug               = "authentication-flow"
  designation        = "authentication"
  layout             = "sidebar_left"
  policy_engine_mode = "any"
}

resource "authentik_flow_stage_binding" "authentication_identification_00" {
  target = authentik_flow.authentication.uuid
  stage  = authentik_stage_identification.authentication.id
  order  = 0
}

resource "authentik_flow_stage_binding" "authentication_user_login_100" {
  target = authentik_flow.authentication.uuid
  stage  = authentik_stage_user_login.authentication.id
  order  = 100
}

data "authentik_flow" "default_invalidation" {
  slug = "default-invalidation-flow"
}

data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_flow" "default_provider_authorization" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-provider-authorization-implicit-consent" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default_source_auth" {
  slug = "default-source-authentication"
}

data "authentik_flow" "default_source_enrollment" {
  slug = "default-source-enrollment"
}

resource "authentik_flow" "enrollment_denied" {
  name        = "Enrollment Denied"
  title       = "Registration Closed"
  slug        = "enrollment-denied-flow"
  designation = "enrollment"
}

resource "authentik_flow_stage_binding" "enrollment_denied_00" {
  target = authentik_flow.enrollment_denied.uuid
  stage  = authentik_stage_deny.enrollment_denied.id
  order  = 0
}