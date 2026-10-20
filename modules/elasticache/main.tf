resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${var.project_name}-${var.environment}-redis"

  description = "Redis/Valkey cache for ${var.project_name}-${var.environment}"

  engine         = var.engine
  engine_version = var.engine_version

  node_type = var.node_type

  num_cache_clusters = var.num_cache_nodes

  port = 6379

  subnet_group_name = aws_elasticache_subnet_group.this.name

  security_group_ids = [
    var.security_group_id
  ]

  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  tags = var.tags
}