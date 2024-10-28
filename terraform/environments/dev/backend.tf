terraform {
  backend "gcs" {
    bucket = "tf-state-file-cicd"
    prefix = "terraform/state/dev"
  }
}
