#####################
## Provider - Main ##
#####################

terraform {
  required_version = ">= 0.14"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
