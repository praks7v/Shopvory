terraform {
  backend "gcs" {
    bucket = "tf-state-files-env"
    prefix = "terraform/state/cicd"
  }
}
