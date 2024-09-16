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
}