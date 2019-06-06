resource "aws_security_group" "internal_elb" {
  name_prefix = "${format("%s-%s-internal-elb-", var.name, var.environment)}"
  vpc_id      = "${aws_vpc.legendary-infra.id}"
  description = "Allows internal ELB traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s internal elb", var.name)}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "external_elb" {
  name_prefix = "${format("%s-%s-external-elb-", var.name, var.environment)}"
  vpc_id      = "${aws_vpc.legendary-infra.id}"
  description = "Allows external ELB traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s external elb", var.name)}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "internal_ssh" {
  name_prefix = "${format("%s-%s-internal-ssh-", var.name, var.environment)}"
  description = "Allows ssh from bastion"
  vpc_id      = "${aws_vpc.legendary-infra.id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.external_ssh.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s internal ssh", var.name)}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "external_ssh" {
  name_prefix = "${format("%s-%s-external-ssh-", var.name, var.environment)}"
  description = "Allows ssh from the world"
  vpc_id      = "${aws_vpc.legendary-infra.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s external ssh", var.name)}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "internal_psql" {
  name_prefix = "${format("%s-%s-internal-psql-", var.name, var.environment)}"
  vpc_id      = "${aws_vpc.legendary-infra.id}"
  description = "Allows incoming psql traffic from vpc"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s internal psql", var.name)}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "internal_redis" {
  name_prefix = "${format("%s-%s-internal-redis-", var.name, var.environment)}"
  vpc_id      = "${aws_vpc.legendary-infra.id}"
  description = "Allows redis traffic within the vpc"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s internal redis", var.name)}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "internal_mysql" {
  name_prefix = "${format("%s-%s-internal-psql-", var.name, var.environment)}"
  vpc_id      = "${aws_vpc.legendary-infra.id}"
  description = "Allows incoming psql traffic from vpc"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }


  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s internal psql", var.name)}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "nfs" {
  vpc_id      = "${aws_vpc.legendary-infra.id}"
  name_prefix = "${var.name}-gitlab-nfs-"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "gitlab_application" {
  vpc_id      = "${aws_vpc.legendary-infra.id}"
  name_prefix = "${var.name}-gitlab-application-"
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_blocks     = ["::/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "legendary-infra-application" {
  vpc_id      = "${aws_vpc.legendary-infra.id}"
  name_prefix = "${var.name}-legendary-infra-application-"
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_blocks     = ["::/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "nexus_sg" {
  vpc_id      = "${aws_vpc.legendary-infra.id}"
  name_prefix = "${var.name}-gitlab-nexus-registry-"
  description = "Allow access to Nexus dashboard & traffic on port 5000"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    ipv6_cidr_blocks     = ["::/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${format("%s nexus_sg", var.name)}"
    Environment = "${var.environment}"
  }
}

// Internal ELB allows internal traffic.
output "internal_elb" {
  value = "${aws_security_group.internal_elb.id}"
}

// External ELB allows traffic from the world.
output "external_elb" {
  value = "${aws_security_group.external_elb.id}"
}

// Internal SSH allows ssh connections from the external ssh security group.
output "internal_ssh" {
  value = "${aws_security_group.internal_ssh.id}"
}

// External SSH allows ssh connections on port 22 from the world.
output "external_ssh" {
  value = "${aws_security_group.external_ssh.id}"
}

// Internal PSQL allows postgres psql connections on port 5432
output "internal_psql" {
  value = "${aws_security_group.internal_psql.id}"
}

// Internal Redis allows redis connections on port 6379
output "internal_redis" {
  value = "${aws_security_group.internal_redis.id}"
}

// Nexus registry
output "nexus_registry" {
  value = "${aws_security_group.nexus_sg.id}"
}

// The default VPC security group ID.
output "security_group" {
  value = "${aws_vpc.legendary-infra.default_security_group_id}"
}