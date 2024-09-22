# VPC Network
module "network" {
  source                  = "../../modules/vpc-network"
  project_id              = var.project_id
  network_name            = var.network_name
  routing_mode            = "REGIONAL"
  description             = "BloggersUnity VPC Network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "prod_subnet" {
  project       = var.project_id
  name          = "gke-prod-subnet"
  ip_cidr_range = "40.0.0.0/16"
  region        = var.region
  network       = module.network.network_name

  private_ip_google_access = false

  secondary_ip_range {
    range_name    = "prod-pod-range"
    ip_cidr_range = "40.2.0.0/16"
  }
  secondary_ip_range {
    range_name    = "prod-service-range"
    ip_cidr_range = "40.4.0.0/20"
  }
}

module "firewall" {
  source       = "../../modules/firewall"
  project_id   = var.project_id
  network_name = module.network.network_name

  ingress_rules = [
    {
      name          = "allow-ssh-prod-cluser"
      description   = "Allow SSH from anywhere"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    }
  ]
}
