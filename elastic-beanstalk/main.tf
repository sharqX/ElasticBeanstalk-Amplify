variable "eb-app-name" {}
variable "bucket" {}
variable "object" {}
variable "vpc_id" {}
variable "subnets" {}
variable "security-group" {}

data "aws_iam_role" "eb_ec2_role" {
  name = "aws-elasticbeanstalk-ec2-role"
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "aws-elasticbeanstalk-ec2-instance-profile"
  role = data.aws_iam_role.eb_ec2_role.name
}

resource "aws_elastic_beanstalk_application" "mern-backend" {
  name = var.eb-app-name
}

# resource "aws_elastic_beanstalk_application_version" "mern-backend-version" {
#   name        = "mern-app-backend-version"
#   application = var.eb-app-name
#   bucket      = var.bucket
#   key         = "backend.zip"
# }

resource "aws_elastic_beanstalk_environment" "mern-backend-env" {
  name                = "mern-backend-env"
  application         = aws_elastic_beanstalk_application.mern-backend.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.2.1 running Node.js 20"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = aws_iam_instance_profile.eb_instance_profile.name
  } 

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.subnets
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     =  "True"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.security-group
  }

setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }

}