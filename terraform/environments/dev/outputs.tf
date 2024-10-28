output "gke_connection_string_dev_cluster" {
  description = "GKE connection string to configure kubectl"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.dev.name} --zone ${var.zone} --project ${var.project_id}"
}
