## How to add resouces to existing VPC or how to update existing resource?

### how to map resource values by matching environment variable?
### How to map vpc name by mathcing environment variable? 
### How to map security group name by mathcing environment variable? 


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


