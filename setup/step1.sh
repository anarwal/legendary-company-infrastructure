#!/bin/bash

USE_DIR="legendary-company-infrastructure"

mkdir ../$USE_DIR
cd ../terraform-scripts
cp backend.tfvars bastion.tf config.tf gateways.tf provider.tf route-tables.tf security-group.tf subnet.tf terraform.tfvars variables.tf vpc.tf ../$USE_DIR
cp -r templates ../$USE_DIR
rm backend.tfvars bastion.tf config.tf gateways.tf provider.tf route-tables.tf security-group.tf subnet.tf terraform.tfvars variables.tf vpc.tf
rm -rf templates
cd ../$USE_DIR

S3_BUCKET_NAME=""
DYNAMO_DB_TABLE=""
IAM_ACCESS_KEY_FOR_S3="iam-access-key"
IAM_SECRET_KEY_FOR_S3="iam-secret-key"

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
terraform apply -auto-approve