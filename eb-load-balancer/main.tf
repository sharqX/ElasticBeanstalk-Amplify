variable "loadbalancer_name" {}

output "eb_lb_zone_id" {
  value = data.aws_elb.eb_loadbalancer.zone_id
}

output "eb_lb_dns_name" {
  value = data.aws_elb.eb_loadbalancer.dns_name
}

data "aws_elb" "eb_loadbalancer" {
  name = var.loadbalancer_name
}