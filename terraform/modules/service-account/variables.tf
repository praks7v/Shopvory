variable "account_id" {
  type        = string
  description = "The unique identifier for the service account."
}

variable "display_name" {
  type        = string
  description = "The display name for the service account."
}

variable "project_id" {
  type        = string
  description = "The project ID where the service account will be created."
}

variable "roles" {
  type = map(string)
  description = "A map of roles to assign to the service account."
}
