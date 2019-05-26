variable "my_vpc_id" {
  default = "vpc-e568218e"
  description = "the vpc id where to deploy the aws machine and security group"
}

variable "my_subnet" {
  default = "subnet-feb08e95"
  description = "the public subnet id where to deploy the ec2 machine needs to be in the same vpc of my_vpc_id"
}

variable "my_ami_id" {
  default = "ami-0ebe657bc328d4e82"
  description = "A Linux Amazon 2 AMI the installation script is tested for this kind of AMI"
}

variable "my_pem_keyname" {
  default = "EffectiveDevOpsAWS"
  description = "the Pem Key Name"
}
