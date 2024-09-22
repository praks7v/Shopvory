output "firewall_rule_names" {
  description = "The names of the firewall rules created."
  value       = [for rule in google_compute_firewall.rules : rule.name]
}
