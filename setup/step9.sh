#!/bin/bash

USE_DIR="legendary-company-infrastructure"

# TODO: create personal access token for admin user and update gitlab.tf

cd ../terraform-scripts
cp gitlab.tf nexus.tf ../$USE_DIR
rm gitlab.tf nexus.tf
cd ../$USE_DIR

terraform init \
    -backend-config="bucket=$S3_BUCKET_NAME" \
    -backend-config="key=infraProject.tf" \
    -backend-config="region=us-east-1" \
    -backend-config="dynamodb_table=$DYNAMO_DB_TABLE" \
    -backend-config="encrypt=true" \
    -backend-config="access_key=$IAM_ACCESS_KEY_FOR_S3" \
    -backend-config="secret_key=$IAM_SECRET_KEY_FOR_S3" \
    -backend=true

terraform plan
terraform apply
