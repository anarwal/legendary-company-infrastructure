#!/bin/bash

USE_DIR="legendary-company-infrastructure"

cd ../terraform-scripts
cp datastore.tf ../$USE_DIR
rm datastore.tf
cd ../$USE_DIR

terraform plan
terraform apply
