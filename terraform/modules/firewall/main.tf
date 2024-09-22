locals {
  ingress_rules = { for rule in var.ingress_rules : rule.name => merge(rule, { direction = "INGRESS" }) }
  egress_rules  = { for rule in var.egress_rules : rule.name => merge(rule, { direction = "EGRESS" }) }
  rules_all     = merge(local.ingress_rules, local.egress_rules)
}

resource "google_compute_firewall" "rules" {
  for_each    = local.rules_all
  name        = each.value.name
  description = each.value.description
  direction   = each.value.direction
  disabled    = each.value.disabled
  network     = var.network_name
  project     = var.project_id
  priority    = each.value.priority

  source_ranges           = lookup(each.value, "source_ranges", null)
  destination_ranges      = lookup(each.value, "destination_ranges", null)
  source_tags             = each.value.source_tags
  source_service_accounts = each.value.source_service_accounts
  target_tags             = each.value.target_tags
  target_service_accounts = each.value.target_service_accounts

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }

  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = lookup(deny.value, "ports", null)
    }
  }

  dynamic "log_config" {
    for_each = lookup(each.value, "log_config", null) == null ? [] : [each.value.log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}
