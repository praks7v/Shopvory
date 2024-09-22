#### VPC Network ####
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

#### VM Instances #####

variable "instance_image" {
  type        = string
  description = "instance images"
}

variable "region" {
  type        = string
  description = "region where resources will be created."
}

variable "ssh_user" {
  type        = string
  description = "ssh user name"
}

variable "ssh_public_key" {
  type        = string
  description = "ssh public key id path"
}

variable "vm_instances" {
  type = list(object({
    name         = string
    machine_type = string
    zone         = string
    disk_size    = number
  }))
}