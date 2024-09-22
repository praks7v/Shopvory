output "cluster_endpoint" {
  description = "The endpoint of the Kubernetes cluster."
  value       = { for region, cluster in google_container_cluster.primary : region => cluster.endpoint }
}

output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = { for region, cluster in google_container_cluster.primary : region => cluster.name }
}
