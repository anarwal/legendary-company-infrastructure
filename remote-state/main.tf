provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "infra-bucket"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "legendary-infra-stack-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}