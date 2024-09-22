# Output external IPs with instance names
output "external_ips" {
  value       = { for instance in google_compute_instance.vm_instances : instance.name => instance.network_interface[0].access_config[0].nat_ip }
  description = "Map of VM instance names to their external IP addresses."
}
