variable "domain" {
  type = string
  default = "habas.click"
}

# Route53 Hosted Zone
data "aws_route53_zone" "main" {
  private_zone = false
  name         = "${var.domain}."
}

# ACM Certificate
resource "aws_acm_certificate" "main" {
  domain_name = var.domain
  validation_method = "DNS"

  tags = {
    Environment = "Dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Route53 Record
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  depends_on = [aws_acm_certificate.main]

  zone_id = data.aws_route53_zone.main.id
  ttl     = 60
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
}

# ACM Certificate Validation
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

# Route53 Record
resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.id
  name = var.domain
  type = "A"
  alias {
    name = aws_lb.main.dns_name
    zone_id = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

# ALB Listener
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn

  certificate_arn = aws_acm_certificate.main.arn

  port = 443
  protocol = "HTTPS"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }
}

# ALB Listener Rule
resource "aws_alb_listener_rule" "http_to_https" {
  listener_arn = aws_alb_listener.https.arn

  priority = 99

  action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = ["${var.domain}"]
    }
  }
}

# Security Group Rule
resource "aws_security_group_rule" "main" {
  security_group_id = aws_security_group.alb.id

  type = "ingress"
  from_port = 443
  to_port = 443
  
  protocol = "tcp"
  
  cidr_blocks = ["0.0.0.0/0"]
}
