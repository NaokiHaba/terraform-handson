variable "name" {
  type = string
}

variable "domain" {
  type = string
}

resource "aws_route53_zone" "this" {
  name = var.domain
}

resource "aws_acm_certificate" "this" {
  domain_name = var.domain

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  depends_on = [aws_acm_certificate.this]

  zone_id = aws_route53_zone.this.zone_id
  ttl     = 60

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}

output "acm_id" {
  value = aws_acm_certificate.this.id
}
