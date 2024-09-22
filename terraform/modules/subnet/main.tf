locals {
  subnets = {
    for subnet in var.subnets :
    subnet.subnet_name => subnet
  }
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each = local.subnets

  name                       = each.value.subnet_name
  ip_cidr_range              = each.value.subnet_ip
  region                     = each.value.subnet_region
  private_ip_google_access   = each.value.subnet_private_access
  private_ipv6_google_access = each.value.subnet_private_ipv6_access

  dynamic "log_config" {
    for_each = each.value.subnet_flow_logs ? [each.value] : []
    content {
      aggregation_interval = log_config.value.subnet_flow_logs_interval
      flow_sampling        = log_config.value.subnet_flow_logs_sampling
      metadata             = log_config.value.subnet_flow_logs_metadata
      filter_expr          = log_config.value.subnet_flow_logs_filter
      metadata_fields      = log_config.value.subnet_flow_logs_metadata == "CUSTOM_METADATA" ? log_config.value.subnet_flow_logs_metadata_fields : null
    }
  }

  network     = var.network_name
  project     = var.project_id
  description = each.value.description
  
  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  purpose          = each.value.purpose
  role             = each.value.role
  stack_type       = each.value.stack_type
  ipv6_access_type = each.value.ipv6_access_type
}
