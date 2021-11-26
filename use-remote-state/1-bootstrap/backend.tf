terraform {
  backend "gcs" {
    bucket = "jmy-tf-state"
    prefix = "bootstrap"
    # credentials = "service-account.json"
  }
}