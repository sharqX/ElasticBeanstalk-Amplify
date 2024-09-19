variable "eb-app-name" {}
variable "solution_stack_name" {}
variable "tier" {}
variable "ServiceRole" {}
variable "eb_instance_profile" {}
variable "InstanceType" {}
variable "vpc_id" {}
variable "subnets" {}
variable "security-group" {}

# output "eb_loadbalancer_url" {
#   value = aws_elastic_beanstalk_environment.mern-backend-env.endpoint_url
# }

# output "eb-env-name" {
#   value = aws_elastic_beanstalk_environment.mern-backend-env.name
# }

output "eb_lb_name" {
  value = aws_elastic_beanstalk_environment.mern-backend-env.load_balancers

}

resource "aws_elastic_beanstalk_application" "mern-backend" {
  name = var.eb-app-name
}

resource "aws_elastic_beanstalk_environment" "mern-backend-env" {
  name                = "mern-backend-env"
  application         = aws_elastic_beanstalk_application.mern-backend.name
  solution_stack_name = var.solution_stack_name
  tier                = var.tier

  #LoadBalancer
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.ServiceRole
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "classic"
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
    value     = "True"
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
    value     = "basic"
  }

}