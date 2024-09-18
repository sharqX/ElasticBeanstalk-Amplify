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

module "s3" {
  source      = "./s3"
  bucket-name = var.bucket-name
  app         = var.app
}

module "elastic-beanstalk" {
  source      = "./elastic-beanstalk"
  eb-app-name = "MERN Backend"
  bucket      = module.s3.s3-bucket-id
  object      = module.s3.s3-object-id
  vpc_id      = module.vpc.mern_vpc_id
  subnets     = tolist(module.vpc.public_subnet_id)[0]
  security-group = module.security-group.sg_id
}