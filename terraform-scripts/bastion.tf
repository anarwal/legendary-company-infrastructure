resource "aws_instance" "bastion" {
  ami                    = "${length(var.ami) > 0 ? var.ami : data.aws_ami.centos.id}"
  source_dest_check      = false
  instance_type          = "${var.instance_type}"
  subnet_id              = "${aws_subnet.public.0.id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${split(",",aws_security_group.external_ssh.id)}"]
  monitoring             = true

  tags = "${merge(var.tags, map(
    "Name", "${var.name}-bastion",
    "Environment", var.environment
  ))}"
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true

  tags = "${merge(var.tags, map(
    "Name", "${var.name}-bastion-eip",
    "Environment", var.environment
  ))}"
}

output "bastion_public_eip" {
  value = "${aws_eip.bastion.public_ip}"
}

output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}