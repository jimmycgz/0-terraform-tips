terraform {
  backend "gcs" {
    bucket = "terraform-state-anthos-poc"
    prefix = "gce"
    # credentials = "service-account.json"
  }
}