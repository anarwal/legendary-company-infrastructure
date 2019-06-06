resource "aws_vpc" "legendary-infra" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    Name = "${var.vpc_name}"
  }
}

// The VPC ID
output "id" {
  value = "${aws_vpc.legendary-infra.id}"
}

// The VPC CIDR
output "cidr_block" {
  value = "${aws_vpc.legendary-infra.cidr_block}"
}