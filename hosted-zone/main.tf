variable "subdomain_name" {}
variable "lb_dns_name" {}
variable "lb_zone_id" {}

output "hosted_zone_id" {
  value = data.aws_route53_zone.domain_name.zone_id
}

data "aws_route53_zone" "domain_name" {
  name         = "infotex.digital"
  private_zone = false
}

resource "aws_route53_record" "lb_record" {
  zone_id = data.aws_route53_zone.domain_name.zone_id
  name    = var.subdomain_name
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}