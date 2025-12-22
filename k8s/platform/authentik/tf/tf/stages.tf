resource "authentik_stage_identification" "authentication" {
  name               = "authentication-identification"
  user_fields        = []
  show_source_labels = true

  sources = [
    authentik_source_oauth.github.uuid
  ]
}

resource "authentik_stage_user_login" "authentication" {
  name = "authentication-login"
}

resource "authentik_stage_user_write" "enrollment_user_write" {
  name                     = "enrollment-user-write"
  create_users_as_inactive = false
  create_users_group       = data.authentik_group.admins.id
  user_type                = "internal"
}

resource "authentik_stage_deny" "enrollment_denied" {
  name         = "enrollment-denied-stage"
  deny_message = "Unknown user / Registration is disabled."
}