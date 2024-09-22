terraform {
  backend "gcs" {
    bucket = "tf-state-file-cicd"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}
