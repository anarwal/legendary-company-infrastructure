#!/bin/bash

USE_DIR="legendary-company-infrastructure"

cd ../terraform-scripts
cp nfs.tf ebs.tf ../$USE_DIR
rm nfs.tf ebs.tf
cd ../$USE_DIR

terraform plan
terraform apply

