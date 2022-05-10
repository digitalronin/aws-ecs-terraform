resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id        = "redis-instance"
  engine            = "redis"
  node_type         = "cache.t4g.micro"
  num_cache_nodes   = 1
  subnet_group_name = aws_elasticache_subnet_group.redis_subnet_group.name
  port              = 6379
}

output "redis_arn" {
  value = aws_elasticache_cluster.redis.arn
}

output "redis_nodes" {
  value = aws_elasticache_cluster.redis.cache_nodes
}

output "redis_url" {
  value = "redis://${aws_elasticache_cluster.redis.cache_nodes[0].address}"
}
