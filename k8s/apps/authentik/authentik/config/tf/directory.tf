data "authentik_group" "admins" {
  name = "authentik Admins"
}

resource "authentik_user" "this" {
  username = "iruYo"
  name     = "Youri"
  email    = var.email
  type     = "internal"
  groups   = [data.authentik_group.admins.id]
}
