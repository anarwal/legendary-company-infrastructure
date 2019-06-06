resource "aws_instance" "nfs_server" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.micro"
  key_name               = "${var.key_name}"
  subnet_id              = "${aws_subnet.private.0.id}"
  vpc_security_group_ids = ["${aws_security_group.internal_ssh.id}", "${aws_security_group.nfs.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.nfs_server.id}"
}

output "nfs_Server_ip" {
  value = "${aws_instance.nfs_server.private_ip}"
}