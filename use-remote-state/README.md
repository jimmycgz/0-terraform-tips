
### Link to general config files in each module folder 
 ln -s ../terraform.tfvars terraform.tfvars
 ln -s ../provider-main.tf provider-main.tf
 ln -s ../provider-variables.tf provider-variables.tf


### Can't find state bucket
Error: Failed to get existing workspaces: querying Cloud Storage failed: storage: bucket doesn't exist
Solution: Check if the bucket exists in your project, and then loging applicaation default
gsutil ls -p test-add-metrics-scope
gcloud auth application-default login
gcloud auth list # <- confirm that correct account has a star next to it