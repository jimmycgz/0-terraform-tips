resource "google_compute_instance" "gce-admin" {
  name         = var.gce_name
  machine_type = "f1-micro"
  zone         = var.gcp_zone
  boot_disk {
    auto_delete = false
    initialize_params {
      image = "ubuntu-1604-xenial-v20181023"
      size  = "10"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
}

output "gce-admin" {
  value = google_compute_instance.gce-admin.name
}
output "gce-admin-pub-ip" {
  value = google_compute_instance.gce-admin.network_interface[0].access_config[0].nat_ip
}