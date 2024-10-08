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

module "target-group" {
  source                   = "./target-group"
  lb_target_group_name     = "mern-tg"
  lb_target_group_port     = var.tg_port
  lb_target_group_protocol = var.tg_protocol
  vpc_id                   = module.vpc.mern_vpc_id
  autoscaling_group        = tolist(module.elastic-beanstalk.autoscaling_group)[0]
}

module "lb" {
  source                     = "./lb"
  lb_name                    = "mern-load-balancer"
  is_internal                = false
  lb_type                    = "application"
  lb_sg                      = [module.security-group.sg_id]
  lb_subnet                  = tolist(module.vpc.public_subnet_id)
  target_group_arn           = module.target-group.lb_target_group_arn
  lb_listener_port           = 80
  lb_listener_protocol       = "HTTP"
  lb_default_action_type     = "forward"
  lb_https_listener_port     = 443
  lb_https_listener_protocol = "HTTPS"
  mern_acm_arn               = module.acm.mern_acm_arn
}

module "elastic-beanstalk" {
  source              = "./elastic-beanstalk"
  eb-app-name         = "BookStore-Backend"
  eb-env-name         = "bookStore-backend-env"
  solution_stack_name = var.solution_stack_name
  tier                = "WebServer"
  eb-env-type         = "LoadBalanced"
  ServiceRole         = module.iam.aws-elasticbeanstalk-service-role
  eb-lb-type          = "application"
  is_shared_lb        = true
  sharedlb            = module.lb.lb_arn
  healthcheck_path    = "/health"
  eb_instance_profile = module.iam.aws-elasticbeanstalk-ec2-instance-profile
  InstanceType        = var.InstanceType
  vpc_id              = module.vpc.mern_vpc_id
  subnets             = join(",", module.vpc.public_subnet_id)
  pub_ip              = true
  security-group      = module.security-group.sg_id
  ELBSubnets          = join(",", module.vpc.public_subnet_id)
  healthreporting     = "enhanced"
  mongourl            = var.mongourl
  certificate_arn     = module.acm.mern_acm_arn
}

module "hosted-zone" {
  source         = "./hosted-zone"
  subdomain_name = var.subdomain
  lb_dns_name    = module.lb.lb_dns_name
  lb_zone_id     = module.lb.lb_zone_id
}

module "acm" {
  source         = "./acm"
  domain_name    = var.domain_name
  hosted_zone_id = module.hosted-zone.hosted_zone_id
}

# module "amplify" {
#   source               = "./amplify"
#   depends_on           = [module.elastic-beanstalk, module.hosted-zone, module.target-group]
#   aws_amplify_app_name = "BookStore"
#   repository           = var.repo
#   frontend_domain_name = var.frontend_domain_name
#   domain_prefix        = var.domain_prefix
#   domain_prefix_2      = var.domain_prefix_2
#   branch_name          = var.branch_name
#   access_token         = var.access_token
#   env_var              = var.env_var
# }