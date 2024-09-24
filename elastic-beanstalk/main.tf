variable "eb-app-name" {}
variable "eb-env-name" {}
variable "solution_stack_name" {}
variable "tier" {}
variable "eb-env-type" {}
variable "ServiceRole" {}
variable "eb-lb-type" {}
variable "is_shared_lb" {}
variable "sharedlb" {}
variable "healthcheck_path" {}
variable "eb_instance_profile" {}
variable "InstanceType" {}
variable "vpc_id" {}
variable "subnets" {}
variable "pub_ip" {}
variable "security-group" {}
variable "ELBSubnets" {}
variable "healthreporting" {}
variable "mongourl" {}

output "eb_endpoint_url" {
  value = aws_elastic_beanstalk_environment.mern-backend-env.endpoint_url
}

output "instance_id" {
  value = aws_elastic_beanstalk_environment.mern-backend-env.instances
}


resource "aws_elastic_beanstalk_application" "mern-backend" {
  name = var.eb-app-name
}

resource "aws_elastic_beanstalk_environment" "mern-backend-env" {
  name                = var.eb-env-name
  application         = aws_elastic_beanstalk_application.mern-backend.name
  solution_stack_name = var.solution_stack_name
  tier                = var.tier

#EnvironmentVariable
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MONGOURL"
    value     = var.mongourl
  }
  #LoadBalancer
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = var.eb-env-type
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.ServiceRole
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = var.eb-lb-type
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerIsShared"
    value     = var.is_shared_lb
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SharedLoadBalancer"
    value     = var.sharedlb
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = var.healthcheck_path
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }

  #LaunchConfig
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.eb_instance_profile
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.InstanceType
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.security-group
  }

  #VPC
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
    value     = var.pub_ip
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = var.ELBSubnets
  }

  #AutoScaling
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }

  #HealthCheck
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = var.healthreporting
  }
}