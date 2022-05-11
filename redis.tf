resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_security_group" "redis_sg" {
  name_prefix = "redis-cluster"
  vpc_id      = aws_vpc.default.id

  ingress {
    protocol        = "tcp"
    from_port       = 6379
    to_port         = 6379
    security_groups = [aws_security_group.hello_world_task.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "redis-instance"
  engine             = "redis"
  node_type          = "cache.t4g.micro"
  num_cache_nodes    = 1
  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
  port               = 6379
  security_group_ids = [aws_security_group.redis_sg.id]
}

locals {
  redis_url = "redis://${aws_elasticache_cluster.redis.cache_nodes[0].address}"
}

output "redis_url" {
  value = local.redis_url
}
