#!/bin/bash

USE_DIR="legendary-company-infrastructure"

cd ../terraform-scripts
cp gitlab-runner.tf ../$USE_DIR
rm gitlab-runner.tf nexus.tf
cd ../$USE_DIR

terraform plan
terraform apply