resource "aws_elb" "gitlab_application" {
  subnets         = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.external_elb.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    target              = "TCP:443"
    interval            = 10
  }
  lifecycle {
    create_before_destroy = true
  }
}

output "gitlab_dns_name" {
  value = "${aws_elb.gitlab_application.dns_name}"
}