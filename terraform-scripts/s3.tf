resource "aws_s3_bucket" "legendary_infra_s3_bucket" {
  bucket        = "${var.s3_bucket_name}"
  acl           = "private"
  force_destroy = "${var.force_destroy}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = "${var.versioning_enabled}"
  }
  // lifecycle rule

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = "${var.lifecycle_infrequent_storage_transition_enabled}"
    prefix = "${var.lifecycle_infrequent_storage_object_prefix}"

    transition {
      days          = "${var.lifecycle_days_to_infrequent_storage_transition}"
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = "${var.lifecycle_glacier_transition_enabled}"
    prefix = "${var.lifecycle_glacier_object_prefix}"

    transition {
      days          = "${var.lifecycle_days_to_glacier_transition}"
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = "${var.lifecycle_expiration_enabled}"

    prefix = "${var.lifecycle_expiration_object_prefix}"

    expiration {
      days = "${var.lifecycle_days_to_expiration}"
    }
  }

  //lifecycle rule end

  tags = "${merge(local.DEFAULT_TAGS, var.tags, map("Name", format("%s", var.s3_bucket_name)))}"
}

resource "aws_s3_bucket_policy" "legendary_infra_bucket_predefined_user" {
  bucket = "${aws_s3_bucket.legendary_infra_s3_bucket.id}"

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowTest",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.s3_user.arn != "" ? aws_iam_user.s3_user.arn : local.root_user }"
      },
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::${var.s3_bucket_name}/*",
                   "arn:aws:s3:::${var.s3_bucket_name}"]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_metric" "default-metric" {
  count  = "${var.BucketSizeBytes != "" || var.NumberOfObjects != "" ? 1 : 0}"
  bucket = "${aws_s3_bucket.legendary_infra_s3_bucket.bucket}"
  name   = "${var.s3_bucket_name}"
}

locals {
  root_user = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"

  DEFAULT_TAGS = {
    "managed_by"       = "Terraform Infra Project"
    "terraform_module" = "s3"
  }
}

output "bucket_id" {
  value = "${element(concat(aws_s3_bucket.legendary_infra_s3_bucket.*.id, list("")), 0)}"
}

output "bucket_arn" {
  value = "${element(concat(aws_s3_bucket.legendary_infra_s3_bucket.*.arn, list("")), 0)}"
}


