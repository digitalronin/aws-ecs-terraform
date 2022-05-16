/* Enable this service to run the task, and then destroy it afterwards
resource "aws_ecs_service" "rails_db_migrate" {
  name            = "rails_db_migrate"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.rails_db_migrate.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.rails_app_task.id]
    subnets         = aws_subnet.private.*.id
  }
}
*/

resource "aws_ecs_task_definition" "rails_db_migrate" {
  family                   = "rails_db_migrate"
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
    "name": "rails_db_migrate",
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.app_name}-${var.app_environment}"
      }
    },
    "command": ["bin/rails", "db:migrate"]
  }
]
DEFINITION
}
