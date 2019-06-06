#!/bin/bash

USE_DIR="legendary-company-infrastructure"
SCRIPT_DIR="$(dirname ${BASH_SOURCE[0]})"

cd ../terraform-scripts
cp autoscaling-group.tf elb.tf launch-configuration.tf template_file.tf ../$USE_DIR
rm autoscaling-group.tf elb.tf launch-configuration.tf template_file.tf
cd ../$USE_DIR

terraform init \
    -backend-config="bucket=$S3_BUCKET_NAME" \
    -backend-config="key=infraproject.tf" \
    -backend-config="region=us-east-1" \
    -backend-config="dynamodb_table=$DYNAMO_DB_TABLE" \
    -backend-config="encrypt=true" \
    -backend-config="access_key=$IAM_ACCESS_KEY_FOR_S3" \
    -backend-config="secret_key=$IAM_SECRET_KEY_FOR_S3" \
    -backend=true

terraform plan
terraform apply