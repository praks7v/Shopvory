variable "project_id" {
  description = "Project ID of the project that holds the network."
  type        = string
}

variable "network_name" {
  description = "Name of the network this set of firewall rules applies to."
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules."
  type = list(object({
    name                    = string
    description             = optional(string, null)
    disabled                = optional(bool, false)
    priority                = optional(number, 1000)
    source_ranges           = optional(list(string), [])
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))
    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])
    log_config = optional(object({
      metadata = string
    }))
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules."
  type = list(object({
    name                    = string
    description             = optional(string, null)
    disabled                = optional(bool, false)
    priority                = optional(number, 1000)
    destination_ranges      = optional(list(string), [])
    source_ranges           = optional(list(string), [])
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))
    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])
    log_config = optional(object({
      metadata = string
    }))
  }))
  default = []
}
