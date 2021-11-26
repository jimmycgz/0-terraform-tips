locals {
  admin_vm_hostname = data.terraform_remote_state.gce.outputs.gce-admin
  gce_pub_ip        = data.terraform_remote_state.gce.outputs.gce-admin-pub-ip
  username          = "root"

}
resource "google_monitoring_group" "app-instance-mig2" {
  display_name = "app-instance-mig2"
  project      = var.gcp_project
  filter       = format("resource.type = \"gce_instance\" AND resource.metadata.name = has_substring(\"%s\")", local.admin_vm_hostname)
}

output "admin_vm_ssh" {
  description = "Run the following command to ssh to admin vm"
  value = join("\n", [
    "gcloud compute ssh ${local.username}@${local.admin_vm_hostname} --project=${var.gcp_project} --zone=${var.gcp_zone}",
    "Public IP: ${local.gce_pub_ip}",
  ])
}

