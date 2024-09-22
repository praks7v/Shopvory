# VPC Network
project_id   = "shopvory-ecommerce"
network_name = "cicd-vpc"

# VM instances
instance_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240829"

region = "asia-south1"

ssh_user       = "ansible"
ssh_public_key = "/home/dev/.ssh/ansible_ed25519.pub"

vm_instances = [
  {
    name         = "jenkins-vm"
    machine_type = "e2-standard-4"
    zone         = "asia-south1-a"
    disk_size    = 20
  }
]