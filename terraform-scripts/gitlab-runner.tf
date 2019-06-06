################################################################################################################
## Configure the user-data template file
################################################################################################################
data "template_file" "user_data" {
  template = "${file("${path.module}/templates/gitlab_runner_user_data.sh")}"
  vars {
    GITLAB_RUNNER_NAME                    = "${var.gitlab_runner_name}"
    GITLAB_RUNNER_URL                     = "${var.gitlab_runner_url}"
    GITLAB_RUNNER_TOKEN                   = "${var.gitlab_runner_token}"
    GITLAB_RUNNER_TAGS                    = "${var.gitlab_runner_tags}"
    GITLAB_RUNNER_DOCKER_IMAGE            = "${var.gitlab_runner_docker_image}"
    GITLAB_CONCURRENT_JOB                 = "${var.gitlab_concurrent_job}"
    GITLAB_CHECK_INTERVAL                 = "${var.gitlab_check_interval}"

    GITLAB_RCT_LOW_FREE_SPACE             = "${var.gitlab_rct_low_free_space}"
    GITLAB_RCT_EXPECTED_FREE_SPACE        = "${var.gitlab_rct_expected_free_space}"
    GITLAB_RCT_LOW_FREE_FILES_COUNT       = "${var.gitlab_rct_low_free_files_count}"
    GITLAB_RCT_EXPECTED_FREE_FILES_COUNT  = "${var.gitlab_rct_expected_free_files_count}"
    GITLAB_RCT_DEFAULT_TTL                = "${var.gitlab_rct_default_ttl}"
    GITLAB_RCT_USE_DF                     = "${var.gitlab_rct_use_df}"
  }
}

################################################################################################################
## Configure the AWS EC2 instance
################################################################################################################
resource "aws_instance" "gitlab_runner" {
  ami                     = "${var.amazon_linux_ami}"
  instance_type           = "${var.gitlab_runner_aws_instance_type}"
  subnet_id               = "${aws_subnet.public.0.id}"
  vpc_security_group_ids  = ["${split(",",aws_security_group.external_ssh.id)}"]
  user_data               = "${data.template_file.user_data.rendered}"
  key_name                = "${var.key_name}"

  tags = "${merge(var.tags, map(
    "Name", "${var.name}-gitlab-runner",
    "Environment", var.environment
  ))}"
}