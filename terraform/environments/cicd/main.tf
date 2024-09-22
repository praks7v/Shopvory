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

# VPC Subnet
resource "google_compute_subnetwork" "subnetwork" {
  project       = var.project_id
  name          = "cicd-public-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = module.network.network_name
}

# Firewall
module "firewall" {
  source       = "../../modules/firewall"
  project_id   = var.project_id
  network_name = module.network.network_name

  ingress_rules = [
    {
      name          = "allow-ssh-cicd"
      description   = "Allow SSH from anywhere"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    },
    {
      name          = "allow-http"
      description   = "Allow HTTP from anywhere"
      priority      = 1001
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["80"]
        }
      ]
    },
    {
      name          = "allow-jenkins"
      description   = "Allow HTTP from anywhere"
      priority      = 1002
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["8080"]
        }
      ]
    },
    {
      name          = "allow-sonarqube"
      description   = "Allow HTTP from anywhere"
      priority      = 1003
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["9000"]
        }
      ]
    }
  ]

  egress_rules = [
    {
      name               = "allow-all-egress"
      description        = "Allow all egress traffic"
      priority           = 1010
      destination_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "all"
        }
      ]
    }
  ]
}

# VM Creation
resource "google_compute_instance" "vm_instances" {
  project      = var.project_id
  count        = length(var.vm_instances)
  name         = var.vm_instances[count.index].name
  machine_type = var.vm_instances[count.index].machine_type
  zone         = var.vm_instances[count.index].zone

  boot_disk {
    auto_delete = true

    initialize_params {
      image = var.instance_image
      size  = var.vm_instances[count.index].disk_size
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  labels = {
    env = "cicd"
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key)}"
  }

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = google_compute_subnetwork.subnetwork.id
  }
}

resource "google_service_account" "jenkins_sa" {
  project    = var.project_id
  account_id = "jenkins-sa"
}

resource "google_project_iam_member" "compute_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.jenkins_sa.email}"

  condition {
    title       = "expires_after_2024_12_12"
    description = "Expiring at midnight of 2024-12-12"
    expression  = "request.time < timestamp(\"2024-12-12T00:00:00Z\")"
  }

}

resource "google_project_iam_member" "gke_admin" {
  project = var.project_id
  role    = "roles/container.clusterAdmin"
  member  = "serviceAccount:${google_service_account.jenkins_sa.email}"

  condition {
    title       = "expires_after_2024_12_12"
    description = "Expiring at midnight of 2024-12-12"
    expression  = "request.time < timestamp(\"2024-12-12T00:00:00Z\")"
  }
}

resource "google_project_iam_member" "gke_cluster_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.jenkins_sa.email}"

  condition {
    title       = "expires_after_2024_12_12"
    description = "Expiring at midnight of 2024-12-12"
    expression  = "request.time < timestamp(\"2024-12-12T00:00:00Z\")"
  }
}