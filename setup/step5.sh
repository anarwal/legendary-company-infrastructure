#!/bin/bash

USE_DIR="legendary-company-infrastructure"

cd ../
cp -r ./ansible ./$USE_DIR
rm -rf ./ansible
cd ./$USE_DIR

brew install ansible
# you may also need to install xcode tools, examine the output from the above command
ansible-galaxy install aloisbarreras.ebs-raid-array,0.1.1 geerlingguy.nfs

cd ../terraform-scripts
cp ansible-role.tf iam.tf ../$USE_DIR
rm ansible-role.tf iam.tf
# Ensure you have Uncommented iam_instance_profile in ./legendary-company-infrastructure/nfs.tf
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