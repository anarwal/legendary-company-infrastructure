resource "aws_instance" "example_application" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.application_aws_instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${aws_subnet.public.0.id}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${split(",",aws_security_group.external_ssh.id)}"]
  user_data                   = "${file("${path.module}/templates/application_user_data.sh")}"


  tags = "${merge(var.tags, map(
    "Name", "${var.name}-example-application-slave",
    "Environment", var.environment
  ))}"
}


resource "aws_route53_record" "example_application_dns" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.example_application_dns_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.example_application.public_ip}"]
}

output "application_public_ip" {
  value = "${aws_instance.example_application.public_ip}"
}