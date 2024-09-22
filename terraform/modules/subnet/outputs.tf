output "subnets" {
  value = {
    for s in google_compute_subnetwork.subnetwork : s.name => {
      id   = s.id
      name = s.name
    }
  }
}

