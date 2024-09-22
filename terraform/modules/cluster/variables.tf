variable "cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "cluster_location" {
  description = "Location of the GKE cluster."
  type        = string
}

variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}

variable "initial_node_count" {
  description = "Initial node count for the cluster."
  type        = number
}

variable "network_name" {
  description = "Name of the network to use."
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet to use."
  type        = string
}

variable "logging_service" {
  description = "Logging service to use."
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "Monitoring service to use."
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "networking_mode" {
  description = "Networking mode to use."
  type        = string
  default     = "VPC_NATIVE"
}

variable "deletion_protection" {
  description = "Enable or disable deletion protection."
  type        = bool
  default     = false
}

variable "node_locations" {
  description = "List of zones where the cluster nodes will be located."
  type        = list(string)
}

variable "addons_config" {
  description = "Add-ons configuration for the cluster."
  type = list(object({
    http_load_balancing = object({
      disabled = bool
    })
    horizontal_pod_autoscaling = object({
      disabled = bool
    })
  }))
  default = []
}

variable "release_channel" {
  description = "Release channel for the cluster."
  type        = string
  default     = "REGULAR"
}

variable "workload_identity_pool" {
  description = "Workload identity pool for the cluster."
  type        = string
}

variable "ip_allocation_policy" {
  description = "IP allocation policy for the cluster."
  type = object({
    cluster_secondary_range_name  = string
    services_secondary_range_name = string
  })
}

variable "private_cluster_config" {
  description = "Configuration for the private cluster."
  type = object({
    enable_private_nodes    = bool
    enable_private_endpoint = bool
    master_ipv4_cidr_block  = string
  })
}
