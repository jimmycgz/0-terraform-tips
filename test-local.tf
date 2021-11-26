resource "null_resource" "default-namespace" {
  triggers = {
    always_run = "${timestamp()}"
  }    
  provisioner "local-exec" {
    interpreter = ["/bin/bash" ,"-c"]
    command = <<-EOT
      mkdir test_folder
      echo "mkdir done"
    EOT
} 
}    
