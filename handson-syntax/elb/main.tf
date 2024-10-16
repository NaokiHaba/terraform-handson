variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "domain" {
  type = string
}

variable "acm_id" {
  type = string
}

resource "aws_security_group" "this" {
  name = "${var.name}-elb"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-elb"
  }
}

resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.this.id
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https" {
  security_group_id = aws_security_group.this.id
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "this" {
  name = var.name
  subnets = var.public_subnet_ids
  security_groups = [aws_security_group.this.id]
  load_balancer_type = "application"
  enable_deletion_protection = false
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port = 443
  protocol = "HTTPS"

  certificate_arn = var.acm_id

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "こんにちは、世界！"
      status_code = "200"
    }
  }
}

# data "aws_route53_zone" "this" {
#   name = var.domain

#   private_zone = false
# }

# resource "aws_route53_record" "this" {
#   type = "A"
#   name = var.domain
#   zone_id = data.aws_route53_zone.this.id
#   alias {
#     name = aws_lb.this.dns_name
#     zone_id = aws_lb.this.zone_id
#     evaluate_target_health = true
#   }
# }

output "https_listener_arn" {
  value = aws_alb_listener.https.arn
}


