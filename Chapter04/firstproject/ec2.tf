# Provider Configuration for AWS
provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "eu-central-1"
}

# Resource Configuration for AWS
resource "aws_instance" "myserver" {
  ami = "ami-02fc41eea185ef7b2"
  instance_type = "t2.micro"
  key_name = "EffectiveDevOpsAWS"
  vpc_security_group_ids = ["sg-06345969884111f27"]

  tags {
    Name = "helloworld"
  }
}
