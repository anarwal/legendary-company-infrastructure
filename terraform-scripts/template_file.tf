data "template_file" "gitlab_application_user_data" {
  template = "${file("${path.module}/templates/gitlab_application_user_data.tpl")}"
  vars {
    nfs_server_private_ip = "${aws_instance.nfs_server.private_ip}"
    postgres_database     = "${aws_db_instance.gitlab_postgres.name}"
    postgres_username     = "${aws_db_instance.gitlab_postgres.username}"
    postgres_password     = "${var.gitlab_postgres_password}"
    postgres_endpoint     = "${aws_db_instance.gitlab_postgres.address}"
    redis_endpoint        = "${aws_elasticache_replication_group.gitlab_redis.primary_endpoint_address}"
    cidr                  = "${aws_vpc.legendary-infra.cidr_block}"
  }
}