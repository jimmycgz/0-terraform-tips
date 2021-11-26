data "terraform_remote_state" "my-sa" {
  backend = "gcs"
  config = {
    bucket = "jmy-tf-state"
    prefix = "bootstrap"
    # credentials = "service-account.json"
  }
}