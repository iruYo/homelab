variable "domain" {
  type = string
  default = "youriulbri.ch"
  description = "Domain name"
}

variable "zones" {
  type = list(object({
    name     = string
    subzones = optional(list(string))
  }))
  description = "Route53 zones"
}
