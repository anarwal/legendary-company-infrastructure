#!/bin/bash

USE_DIR="legendary-company-infrastructure"

cd ../terraform-scripts
cp example-slave.tf rds.tf s3.tf ../$USE_DIR
rm example-slave.tf rds.tf s3.tf nexus.tf
cd ../$USE_DIR

terraform plan
terraform apply