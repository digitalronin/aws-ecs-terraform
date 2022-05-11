resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-instance"
  vpc_id      = aws_vpc.default.id

  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_security_group.hello_world_task.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 10
  engine                 = "postgres"
  instance_class         = "db.t4g.micro"
  db_name                = "mydb"
  username               = "admindbuser"
  password               = var.dbpassword
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

locals {
  database_url = "postgresql://${aws_db_instance.postgres.username}:${var.dbpassword}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.db_name}"
}

output "database_url" {
  value = local.database_url
}
