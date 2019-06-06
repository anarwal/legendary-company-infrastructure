resource "aws_iam_role" "nfs_server" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "nfs_server_ebs" {
  role = "${aws_iam_role.nfs_server.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "nfs_server" {
  role = "${aws_iam_role.nfs_server.name}"
}

resource "aws_iam_user" "s3_user" {
  name = "${var.user_name}"
  path = "/"
  force_destroy = "${var.force_destroy}"
}

resource "aws_iam_user_policy_attachment" "s3_allow_policy" {
  user       = "${aws_iam_user.s3_user.name}"
  policy_arn = "${aws_iam_policy.s3_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "deny_put_acl" {
  user       = "${aws_iam_user.s3_user.name}"
  policy_arn = "${aws_iam_policy.deny_put_acl.arn}"
}


resource "aws_iam_access_key" "access_key_1" {
  count = "${var.rotation_status == "1" || var.rotation_status == "rotate" ? 1 : 0}"
  user  = "${aws_iam_user.s3_user.name}"
}

resource "aws_iam_policy" "s3_policy" {
  name = "${var.user_name}_policy"
  path = "/"
  description = "${var.user_name}_policy"
  policy =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "deny_put_acl" {
  name = "${var.user_name}_deny_put_acl_policy"
  path = "/"
  description = "deny_put_acl"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AddPerm",
      "Effect": "Deny",
      "Action": [
        "s3:PutBucketAcl",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

output "secret_key" {
  value = "${aws_iam_access_key.access_key_1.*.secret}"
}

output "access_key" {
  value = "${aws_iam_access_key.access_key_1.*.id}"
}

output "user_arn" {
  value = "${aws_iam_user.s3_user.arn}"
}