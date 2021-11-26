resource "google_service_account" "service_account" {
  account_id   = var.sa_name
  display_name = var.sa_name
  project      = var.gcp_project
}

output "my-sa" {
  value = google_service_account.service_account.display_name
}