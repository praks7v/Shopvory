# terraform {
#   backend "gcs" {
#     bucket = "<your-bucket>"
#     prefix = "terraform/state"
#   }
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "~> 6.0"
#     }
#   }
# }
