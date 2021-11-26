variable mymap {
  default = {
    foo = "FOO"
    bar = "BAR"
    baz = "BAZ"
  }
}

# generate a list with combined key-value
locals {
  my_list = toset([
    for key, value in var.mymap : format("%s-%s", key, value)
  ])
}

output "my_list" {
    value=local.my_list
}


locals {

  sub_blocks = {
    "a-ams" = {
      "cluster"       = "10.10.0.0/14"
      "mystore"     = "10.40.0.0/29"
      "master"        = "10.50.0.64/28"
      "nodes_private" = "10.22.64.0/20"
      "nodes_public"  = "10.20.64.0/20"
      "services"      = "10.70.0.0/16"
    }
    "a-hkg" = {
      "cluster"       = "10.0.0.0/14"
      "mystore"     = "10.40.0.0/29"
      "master"        = "10.7.0.0/28"
      "nodes_private" = "10.2.0.0/20"
      "nodes_public"  = "10.20.0.0/20"
      "services"      = "10.8.0.0/16"
    }
  }

# generate a flat list, from each region, show subnet-name combined with region-id, and cidr value

  subnet_list = flatten([for region, block in local.sub_blocks : [for sub_name, cidr in block : {
    id   = format("%s-%s", region, sub_name)
    cidr = cidr
    }
  ]])
}

output "subnet_list" {
    value=local.subnet_list
}
