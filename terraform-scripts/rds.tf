variable "apply_immediately" {
  default = "false"
  description = "Whether to deploy changes to the database immediately (true) or at the next maintenance window (false)."
}

resource "aws_db_instance" "rds_test_mysql" {
  allocated_storage      = 16
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "legenedary_infra_rds_mysql"
  username               = "legInfra"
  password               = "${var.rds_password}"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
  vpc_security_group_ids = ["${aws_security_group.internal_mysql.id}"]
  apply_immediately      = "${var.apply_immediately}"
  skip_final_snapshot    = true
}

resource "aws_instance" "rds_jump_box" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${split(",",aws_security_group.external_ssh.id)}"]
  subnet_id              = "${aws_subnet.public.0.id}"
  user_data              = "${file("${path.module}/templates/rds_bastion_user_data.sh")}"
  monitoring             = true

  tags = "${merge(var.tags, map(
    "Name", "${var.name}-rds-jump-box",
    "Environment", var.environment
  ))}"
}

resource "aws_eip" "rds_jump_box_eip" {
  instance = "${aws_instance.rds_jump_box.id}"
  vpc      = true

  tags = "${merge(var.tags, map(
    "Name", "${var.name}-rds-jump-box-eip",
    "Environment", var.environment
  ))}"
}

output "rds_jump_box_public_eip" {
  value = "${aws_eip.rds_jump_box_eip.public_ip}"
}

output "rds_jump_box_public_ip" {
  value = "${aws_instance.rds_jump_box.public_ip}"
}