variable "domain_name" {}
variable "hosted_zone_id" {}

output "mern_acm_arn" {
  value = aws_acm_certificate.mern_acm.arn
}

output "ssl_certificate_id" {
  value = aws_acm_certificate.mern_acm.id
}

resource "aws_acm_certificate" "mern_acm" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = "production"
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.mern_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60

}