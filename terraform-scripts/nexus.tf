resource "aws_instance" "nexus" {
  ami                    = "${var.amazon_linux_ami}"
  instance_type          = "${var.nexus_instance_type}"
  key_name               = "${var.key_name}"
  subnet_id               = "${aws_subnet.public.0.id}"
  vpc_security_group_ids = ["${split(",",aws_security_group.nexus_sg.id)}"]
  user_data              = "${file("${path.module}/templates/nexus_user_data.sh")}"

  tags = "${merge(var.tags, map(
    "Name", "${var.name}-nexus",
    "Environment", var.environment
  ))}"
}

resource "aws_eip" "nexus_eip" {
  instance = "${aws_instance.nexus.id}"
  vpc      = true
}

resource "aws_route53_record" "nexus_dns" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.nexus_dns_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.nexus_eip.public_ip}"]
}

output "nexus_public_ip" {
  value = "${aws_instance.nexus.public_ip}"
}