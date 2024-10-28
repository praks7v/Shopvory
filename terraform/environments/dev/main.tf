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

# VPC Subnetwork
resource "google_compute_subnetwork" "dev_subnet" {
  project       = var.project_id
  name          = "gke-dev-subnet"
  ip_cidr_range = "30.0.0.0/16"
  region        = var.region
  network       = module.network.network_name

  private_ip_google_access = false

  secondary_ip_range {
    range_name    = "dev-pod-range"
    ip_cidr_range = "30.2.0.0/16"
  }
  secondary_ip_range {
    range_name    = "dev-service-range"
    ip_cidr_range = "30.4.0.0/20"
  }
}

# VPC Firewall Rules
module "firewall" {
  source       = "../../modules/firewall"
  project_id   = var.project_id
  network_name = module.network.network_name

  ingress_rules = [
    {
      name          = "allow-ssh-dev-cluser"
      description   = "Allow SSH from anywhere"
      priority      = 1001
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    },
    {
      name          = "allow-prometheus-monitoring"
      description   = "Allow prometheus monotoring from anywhere"
      priority      = 1002
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["9090", "8080", "9115", "9093"]
        }
      ]
    },
    {
      name          = "allow-efk"
      description   = "Allow Elasticsearch Kibana and fluent from anywhere"
      priority      = 1005
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["9200", "9300", "5601"]
        }
      ]
    }
  ]
}
