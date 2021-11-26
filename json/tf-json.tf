locals {
  json_data = jsondecode(file("${path.module}/pages.json"))

}

variable "json1" { default = {"env" : "prod" }}

variable "json2" { default = ["person1","person2","person3"] }

/*
output "json1" {
    value = var.json1
}

output "json2" {
    value = {
      persons=var.json2 
    }
}

output "persons" {
    value = [
        for pers in var.json2: 
        map("person",pers)
    ]
}

output tf-json {
    value = [
        for pg in local.json_data.query.pages: pg.title
    ]
}

*/

output "tf_json" {
    value = flatten([
        for pg in local.json_data.query.pages: [
            for item in pg: {
                title = item.title
                description = item.extract
            }
        ]
    ])
}

