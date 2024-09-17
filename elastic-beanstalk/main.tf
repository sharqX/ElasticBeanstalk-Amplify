variable "eb-app-name" {}
variable "bucket" {}
variable "object" {}
variable "vpc_id" {}
variable "subnets" {}

resource "aws_elastic_beanstalk_application" "mern-backend" {
  name = var.eb-app-name
}

resource "aws_elastic_beanstalk_application_version" "mern-backend-version" {
  name        = "mern-app-backend-version"
  application = var.eb-app-name
  bucket      = var.bucket
  key         = var.object
}

resource "aws_elastic_beanstalk_environment" "mern-backend-env" {
  name                = "mern-backend"
  application         = aws_elastic_beanstalk_application.mern-backend.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.2.1 running Node.js 20"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "vpc_id"
    value     = var_id.vpc
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.subnets
  }
}