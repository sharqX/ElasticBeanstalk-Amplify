variable "loadbalancer_name" {}
# variable "mern_acm_arn" {}
# variable "lb_default_action_type" {}
# variable "target_group_arn" {}

output "eb_lb_zone_id" {
  value = data.aws_elb.eb_loadbalancer.zone_id
}

output "eb_lb_dns_name" {
  value = data.aws_elb.eb_loadbalancer.dns_name
}

data "aws_elb" "eb_loadbalancer" {
  name = var.loadbalancer_name
}

#https
# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = aws_lb.jenkins_lb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
#   certificate_arn   = var.mern_acm_arn

#   default_action {
#     type             = var.lb_default_action_type
#     target_group_arn = var.target_group_arn
#   }
# }