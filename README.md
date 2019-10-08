# terraform-best-practices
My collections for tips, know hows, issue with solutions for Terraform

# Tips (How Tos of Terraform)

## How to add resouces to existing VPC or how to update existing resource?

Step1: Define VPC variable as map like my_aws_resource_vpc_existing
```
variable "my_aws_resource_vpc_existing" {
  description = "The existing VPC to be used for adding new resources"
  type        = "map"

  default = {
    sit2 = "vpc-exx.x" #Ohio default for SIT2
    qa   = "vpc-exxx" #Ohio default for QA
    intl = "vpc-xxxx.f" #Ohio default for INTL PROD
  }
}
```
Step2: Define ENV variable as string
```
variable "my_server_env" {
  default = "qa"
  type    = "string"
}
```
Step3: Define local items to find the correct values for VPC and security groups
```
locals {
  my-aws-resource-vpc   = "${lookup(var.my_aws_resource_vpc_existing, "${var.my_server_env}")}"
  security_group_id_queue = "${lookup(var.security_group_id_existing_queue, "${var.my_server_env}")}"
  security_group_id_db    = "${lookup(var.security_group_id_existing_db, "${var.my_server_env}")}"
}
```
Step4: Get subnet list from existing vpc
```
data "aws_subnet_ids" "my-aws-resource-pub-subnet-ids" {
  vpc_id = "${local.my-aws-resource-vpc}"
}

data "aws_subnet" "my-aws-resource-pub-subnet" {
  count = "${length(data.aws_subnet_ids.my-aws-resource-pub-subnet-ids.ids)}"
  id    = "${data.aws_subnet_ids.my-aws-resource-pub-subnet-ids.ids[count.index]}"
}
```
Step5: Create new Security group on existing VPC
```
resource "aws_security_group" "my-aws-resource-sg" {
  name        = "SG-${var.tag_env_pre_fix}"
  description = "Security Group for each Subnet. Inbound: allow 80/22 from office IP; Outbound:all"
  vpc_id      = "${local.my-aws-resource-vpc}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "SG-${var.tag_env_pre_fix}"
  }
}
```

Step6: Modify Existing Security group, adding new fw rule
```
resource "aws_security_group_rule" "my-sg-general" {
  count             = "${length(var.fw_ports)}"
  security_group_id = "${aws_security_group.my-aws-resource-sg.id}"

  # tcp ports access from office IP
  type        = "ingress"
  from_port   = "${var.fw_ports[count.index]}"
  to_port     = "${var.fw_ports[count.index]}"
  protocol    = "tcp"
  cidr_blocks = ["${var.fw_sources[0]}"]
}
```

## * How to interpolate strings and variables?
```
Name = "my-${var.server_names[count.index]}"  #my-Metrics, my-Logging
Name = "${format("my-subnet-%d", count.index)}"  # my-subnet-0 , 1 ,2
Name = "${format("my-subnet-%3d", count.index)}"  # my-subnet-000, 001, 002

More details are in :
https://www.terraform.io/docs/configuration/interpolation.html
```
## * How to define lists, map list, and get their values via variables?
```
variable "amis" {
  type = "map"

  default = {
      Metrics= "ami-5b",  # Grafana BKP from Ohio
      Logging= "ami-cb"  # ELK Stack BKP from Ohio
  }
}

ami = "${lookup(var.amis, "Metrics")}"  # Find the key value of Metrics in variable amis

variable "server_names" {
  default=["Metrics","Logging"]
  type    = "list"
}

count=2
ami = "${lookup(var.amis, "${var.server_names[count.index]}")}"  # Find the values of the 1st(Metrics) 2nd key(Logging) in variable amis

```
## * How to alternatively pick up items from a list ?
```
subnet_id= "${element(aws_subnet.my-pub-subnet.*.id, 0)}" #pick up the first subnet (Item 0)
subnet_id = "${element(aws_subnet.my-pub-subnet.*.id, count.index)}" #pick up sequency will be Item 0, 1, 0, 1 if count =2, or Item 0,1,2,0,1,2 if count=3

```

# Issue Log
	
## * Terraform plugin doesn't work in Jenkins script

Symptom: It shows below error although Terraform installer already configured in the Jenkins plugin:
```
  + def tfHome = tool name: Terraform
/var/jenkins_home/workspace/infra-as-code/deployment-poc@tmp/durable-8622f3f6/script.sh: 2: /var/jenkins_home/workspace/infra-as-code/deployment-poc@tmp/durable-8622f3f6/script.sh: def: not found
```

Resolution: Install and run Terraform in another EC2.
  
## * Terraform has a defect that it doesn't keep the state for some resources, which only run one time at begining.
  Resolution: These non-state provisioner resources are: file, local-exec and remote-exec. Suessfully done this via resource "null_resource" "rerun" and use uuid as trigger , find this section at the bottom of the terraform_main.tf file. Use uuid as trigger so Terraform will run the non-state provisioner in this group for each run.
  
## * Can't bootstrap by neither remote-exec or run a .sh file in the new instance.
  Resolution: Used my own AMI with the API pre-configured, then user Terraform remote-exec to update the ip address of API3-GCP into the Json config file of API1-AWS.
  
## * How to add a quate (") to a txt file by echo in Terraform? like  command="echo "IP_add=": >IP.txt",
  Resolution: use the combination of (\") and (') like command="echo ' \"IP_add=\":' >IP.txt". Can also pupolate the content by Terraform local_file with EOF sign.
  
## * Can't associate one IGW to multiple subnets, Terraform seems only associate it to the last one in resource IGW_asso
  Resolution: use count to associate every subnet to IGW.
   
  

