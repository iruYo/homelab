variable "tf_state_manager_username" {
  type        = string
  default     = "tf-s3-state-manager"
  description = "Username of the tf state S3 bucket manager"
}


variable "tf_state_bucket" {
  type        = string
  description = "Name of existing tf state S3 bucket which should be managed"
  sensitive   = true
}