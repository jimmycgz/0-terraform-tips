# Parse json value via Terraform

## Via tf code
```
# Init from the current folder
terraform init

# Just to print output for parsed json value, no any resources to create
terraform apply 
```

## Via TF Console

Terraform Console offers interactive with variables and outputs

Below exercises are calling the local variable defined in tf-json.tf
```
terraform console

# parse page 0 
[for page in local.json_data.query.pages[0]: page]

# parse each item of every page and convert to a new flatten list of map
flatten([for page in local.json_data.query.pages: [for item in page: {title=item.title, page=item.extract}]])
```