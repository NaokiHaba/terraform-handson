resource "aws_ecs_task_definition" "main" {
  family = "handson-task"

  requires_compatibilities = ["FARGATE"]

  cpu = 256
  memory = 512

  network_mode = "awsvpc"

  container_definitions = jsonencode([
    {
      name = "handson-container",
      image = "nginx:latest",
      portMappings = [
        {
          containerPort = 80
          hostPort = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_cluster" "main" {
  name = "handson-cluster"
}

resource "aws_lb_target_group" "main" {
  name        = "handson-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    port = 80   
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.main.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_security_group" "ecs_tasks" {
  name_prefix = "handson-ecs-tasks"
  vpc_id = aws_vpc.main.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
        Name = "handson-ecs-tasks"
    }
}

resource "aws_security_group_rule" "ecs_tasks_inbound" {
  security_group_id = aws_security_group.ecs_tasks.id
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

resource "aws_ecs_service" "main" {
  name = "handson-service"

  depends_on = [ aws_lb_listener_rule.main ]

  cluster = aws_ecs_cluster.main.id

  launch_type = "FARGATE"

  desired_count = 1

  task_definition = aws_ecs_task_definition.main.arn

  network_configuration {
    subnets = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1c.id]
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name = "handson-container"
    container_port = 80
  }
}