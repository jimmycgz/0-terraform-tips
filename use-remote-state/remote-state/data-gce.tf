data "terraform_remote_state" "gce" {
  backend = "gcs"
  config = {
    bucket = "jmy-tf-state"
    prefix = "gce"
    # credentials = "service-account.json"
  }
}