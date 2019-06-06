resource "aws_db_instance" "gitlab_postgres" {
  allocated_storage      = 50
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6.10"
  instance_class         = "db.t2.medium"
  multi_az               = true
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
  name                   = "gitlabhq_production"
  username               = "gitlab"
  password               = "${var.gitlab_postgres_password}"
  skip_final_snapshot    = "true"
  vpc_security_group_ids = ["${aws_security_group.internal_psql.id}"]
}

resource "aws_elasticache_subnet_group" "gitlab_redis" {
  name       = "${var.name}-redis-subnet-group"
  subnet_ids = ["${aws_subnet.private.*.id}"]
}

resource "aws_elasticache_replication_group" "gitlab_redis" {
  replication_group_id          = "${var.name}"
  replication_group_description = "Redis cluster powering GitLab"
  engine                        = "redis"
  engine_version                = "3.2.10"
  node_type                     = "cache.t2.medium"
  number_cache_clusters         = 2
  port                          = 6379
  availability_zones            = ["${var.availability_zones}"]
  security_group_ids            = ["${aws_security_group.internal_redis.id}"]
  subnet_group_name             = "${aws_elasticache_subnet_group.gitlab_redis.name}"
}

output "gitlab_postgres_address" {
  value = "${aws_db_instance.gitlab_postgres.address}"
}

output "gitlab_redis_endpoint_address" {
  value = "${aws_elasticache_replication_group.gitlab_redis.primary_endpoint_address}"
}