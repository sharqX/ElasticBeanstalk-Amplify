module "iam" {
  source           = "./iam"
  iam_role         = var.iam_role
  instance-profile = var.instance-profile
  eb_service_role  = var.eb_service_role
}

module "vpc" {
  source               = "./vpc"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  private_subnet_cidr  = var.private_subnet_cidr
  ap_availability_zone = var.ap_availability_zone
  public_subnet_cidr   = var.public_subnet_cidr

}

module "security-group" {
  source  = "./security-group"
  sg_name = "MERN Security Group"
  vpc_id  = module.vpc.mern_vpc_id
}

module "elastic-beanstalk" {
  source              = "./elastic-beanstalk"
  eb-app-name         = "MERN Backend"
  solution_stack_name = var.solution_stack_name
  tier                = "WebServer"
  ServiceRole         = module.iam.aws-elasticbeanstalk-service-role
  eb_instance_profile = module.iam.aws-elasticbeanstalk-ec2-instance-profile
  InstanceType        = var.InstanceType
  vpc_id              = module.vpc.mern_vpc_id
  subnets             = tolist(module.vpc.public_subnet_id)[0]
  security-group      = module.security-group.sg_id
}

module "eb-load-balancer" {
  source            = "./eb-load-balancer"
  loadbalancer_name = tolist(module.elastic-beanstalk.eb_lb_name)[0]
}

module "hosted-zone" {
  source         = "./hosted-zone"
  subdomain_name = "backend.infotex.digital"
  lb_dns_name    = module.eb-load-balancer.eb_lb_dns_name
  lb_zone_id     = module.eb-load-balancer.eb_lb_zone_id
}

module "acm" {
  source         = "./acm"
  domain_name    = var.domain_name
  hosted_zone_id = module.hosted-zone.hosted_zone_id
}

output "sg_id" {
  value = module.security-group.sg_id
}