
locals {
  sa_name = data.terraform_remote_state.my-sa.outputs.my-sa
}

output "my_sa_name" {
  value = local.sa_name
}