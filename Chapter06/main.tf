variable "my_default_vpcid" {
  default = "vpc-e568218e"
}
variable "my_subnet" {
  default = "subnet-feb08e95"
}
variable "subnet_ids" {
  type        = "list"
  description = "A list of VPC subnet IDs"
  default     = ["subnet-d056b4ff", "subnet-b541edfe"]
}
module "monolith_application" {
  source         = "github.com/RobertPolanski/Effective-DevOps-with-AWS//terraform-modules/monolith-playground"
  my_vpc_id      = "${var.my_default_vpcid}"
  my_subnet      = "${var.my_subnet}"
  my_ami_id      = "ami-0ebe657bc328d4e82"
  my_pem_keyname = "EffectiveDevOpsAWS"
}
output "monolith_url" { value = "${module.monolith_application.url}"}

resource "aws_security_group" "rds" {
  name        = "allow_from_my_vpc"
  description = "Allow from my vpc"
  vpc_id      = "${var.my_default_vpcid}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "1.28.0"
  # insert the 10 required variables here
  identifier = "demodb"
  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  name     = "demodb"
  username = "monty"
  password = "some_pass"
  port     = "3306"
  //vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  //subnet_ids = "${var.subnet_ids}"
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  //family = "mysql5.7"
  //major_engine_version = "5.7"
}

//module "db" {
//  source = "terraform-aws-modules/rds/aws"
//  identifier = "demodb"
//  engine            = "mysql"
//  engine_version    = "5.7.19"
//  instance_class    = "db.t2.micro"
//  allocated_storage = 5
//  name     = "demodb"
//  username = "monty"
//  password = "some_pass"
//  port     = "3306"
//  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
//  # DB subnet group
//  subnet_ids = "${var.subnet_ids}"
//  maintenance_window = "Mon:00:00-Mon:03:00"
//  backup_window      = "03:00-06:00"
//  # DB parameter group
//  family = "mysql5.7"
//  # DB option group
//  major_engine_version = "5.7"
//}
