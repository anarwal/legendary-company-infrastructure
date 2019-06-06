#!/bin/bash

USE_DIR="spring-2019"

cd ../
cp -r ./packer ./$USE_DIR
rm -rf ./packer
cd ./$USE_DIR/packer

brew install packer
# update credentials with the values supplied to provider.tf
export AWS_DEFAULT_REGION="us-east-1"
export AWS_ACCESS_KEY_ID="$ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$SECRET_KEY"
packer build -var 'name=infra-gitlab' -var 'profile=infra-project' gitlab.json

# Now update variables.tf
# - gitlab_application_ami.default = "the ami id that was just created"