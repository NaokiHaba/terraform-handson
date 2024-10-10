# VPC用のセキュリティグループ
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "handson alb security group"
  vpc_id      = aws_vpc.main.id

  # アウトバウンドルール: すべてのトラフィックを許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "handson-alb-sg"
  }
}

resource "aws_security_group_rule" "allow_http_from_alb" {
  security_group_id = aws_security_group.alb.id
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "main" {
  name = "handson-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id]
  subnets = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1c.id, aws_subnet.public-subnet-1d.id]
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "200 OK"
      status_code  = "200"
    }
  }
}

