locals{
    # test via tf console
  mon_group_id_long=google_monitoring_group.app-instance-mig.id
  # string like "projects/test-add-metrics-1234/groups/3544096198684228759"
  regex("[^/]+$",google_monitoring_group.app-instance-mig.id)
  regex("groups/[0-9]+","projects/test-add-metrics-1234/groups/3544096198684228759")
  regex("[^/]+$","projects/test-add-metrics-1234/groups/3544096198684228759")
filter= format("select_process_count(\"command=python3\",\"user=root\") resource.type=\"gce_instance\" group.id=\"%s\"", regex("[^/]+$",google_monitoring_group.app-instance-mig.id))
}

variable "org_list" {
  type = map(string)
  default = {
    "orgid_88" = "customer_8"
    "orgid_99" = "customer_9"
  }
}

org_list= {
    "orgid_88" = "cust_foo"
    "orgid_99" = "customer_test"
}

resource "google_monitoring_group" "group_by_orgid" {
  for_each =var.org_list
  display_name = format("%s-%s",each.key,each.value)
  project      = var.project_id
  filter       = format("metadata.user_labels.orgid_88 = has_substring(\"%s\")",each.value)
}

output "google_monitoring_group_orgid" {
  value = toset([
    for group in google_monitoring_group.group_by_orgid : group.display_name
  ])
}
