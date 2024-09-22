variable "eb-app-name" {}
variable "solution_stack_name" {}
variable "tier" {}
variable "ServiceRole" {}
variable "eb_instance_profile" {}
variable "InstanceType" {}
variable "vpc_id" {}
variable "subnets" {}
variable "security-group" {}
variable "ELBSubnets" {}
variable "sharedlb" {}
# variable "cert_arn" {}

output "eb_loadbalancer_url" {
  value = aws_elastic_beanstalk_environment.mern-backend-env.endpoint_url
}

output "eb_lb_name" {
  value = aws_elastic_beanstalk_environment.mern-backend-env.load_balancers
}

output "instance_id" {
  value = aws_elastic_beanstalk_environment.mern-backend-env.instances
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
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerIsShared"
    value     = true
  }

  # setting {
  #   namespace = "aws:elbv2:loadbalancer"
  #   name      = "ManagedSecurityGroup"
  #   value     = var.security-group
  # }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SharedLoadBalancer"
    value     = var.sharedlb
  }

  # setting {
  #   namespace = "aws:elbv2:listener:listener_port:443"
  #   name = "Protocol"
  #   value = "HTTPS"
  # }

  # setting {
  #   namespace = "aws:elbv2:listener:default"
  #   name = "ListenerEnabled"
  #   value = "true"
  # }

  # setting {
  #   namespace = "aws:elbv2:listener:listener_port:80"
  #   name = "ListenerEnabled"
  #   value = true
  # }

  # setting {
  #   namespace = "aws:elbv2:listener:listener_port:443"
  #   name = "SSLCertificateArns"
  #   value = var.cert_arn
  # }
  # setting {
  #   namespace = "aws:elbv2:listener:listener_port:443"
  #   name = "SSLPolicy"
  #   value = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  # }

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
    value     = "basic"
  }

}