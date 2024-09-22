resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.cluster_location
  project                  = var.project_id
  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count
  network                  = var.network_name
  subnetwork               = var.subnet_name
  logging_service          = var.logging_service
  monitoring_service       = var.monitoring_service
  networking_mode          = var.networking_mode
  deletion_protection      = var.deletion_protection

  node_locations = var.node_locations

  dynamic "addons_config" {
    for_each = [for addon in var.addons_config : addon if addon.disabled != null]
    content {
      http_load_balancing {
        disabled = addon.http_load_balancing.disabled
      }
      horizontal_pod_autoscaling {
        disabled = addon.horizontal_pod_autoscaling.disabled
      }
    }
  }

  release_channel {
    channel = var.release_channel
  }

  workload_identity_config {
    workload_pool = var.workload_identity_pool
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_allocation_policy.cluster_secondary_range_name
    services_secondary_range_name = var.ip_allocation_policy.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_nodes    = var.private_cluster_config.enable_private_nodes
    enable_private_endpoint = var.private_cluster_config.enable_private_endpoint
    master_ipv4_cidr_block  = var.private_cluster_config.master_ipv4_cidr_block
  }
}
