provider "google" {
  project = var.project_id
  region  = var.region
  # credentials = "/home/dev/credentials/gcp/project-manager-432906-d71f478c4255.json"
  # use export for best practice security reason
  # export GOOGLE_APPLICATION_CREDENTIALS="/home/dev/credentials/gcp/project-manager-432906-d71f478c4255.json"

}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
