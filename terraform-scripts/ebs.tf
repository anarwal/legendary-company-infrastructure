locals {
  device_names = ["/dev/xvdf", "/dev/xvdg", "/dev/xvdh"]
}

resource "aws_ebs_volume" "gitlab_nfs" {
  count             = "${length(local.device_names)}"
  availability_zone = "us-east-1a"
  size              = 128
}