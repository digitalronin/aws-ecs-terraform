resource "aws_ecs_cluster" "main" {
  name = "example-cluster"
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.app_name}-${var.app_environment}-logs"

  tags = {
    Application = var.app_name
    Environment = var.app_environment
  }
}

resource "aws_ecs_service" "rails_app_service" {
  name            = "rails-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.rails_app_task.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.rails_app_task.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.rails_app_tg.id
    container_name   = "rails-app"
    container_port   = var.rails_app_port
  }

  depends_on = [aws_lb_listener.rails_app]
}

resource "aws_ecs_task_definition" "rails_app_task" {
  family                   = "rails-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = <<DEFINITION
[
  {
    "image": "${local.rails_app_image}",
    "environment": [
      {
        "name": "PORT",
        "value": "${var.rails_app_port}"
      },
      {
        "name": "RAILS_MASTER_KEY",
        "value": "${var.rails_master_key}"
      },
      {
        "name": "DATABASE_URL",
        "value": "${local.database_url}"
      },
      {
        "name": "REDIS_URL",
        "value": "${local.redis_url}"
      }
    ],
    "cpu": 1024,
    "memory": 2048,
    "name": "rails-app",
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.app_name}-${var.app_environment}"
      }
    },
    "portMappings": [
      {
        "containerPort": ${var.rails_app_port},
        "hostPort": ${var.rails_app_port}
      }
    ]
  }
]
DEFINITION
}

resource "aws_security_group" "rails_app_task" {
  name   = "example-task-security-group"
  vpc_id = aws_vpc.default.id

  ingress {
    protocol        = "tcp"
    from_port       = var.rails_app_port
    to_port         = var.rails_app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
