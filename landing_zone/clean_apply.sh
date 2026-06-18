#!/bin/bash

cd landing_zone

# use local backend for development; switch to OSS for production with proper access controls and encryption
cp backend.dev.tf.bak backend.tf

echo "Cleaning old Terraform state..."
rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup tfplan

echo "Initializing Terraform..."
terraform init -reconfigure

echo "Running terraform plan..."
# -detailed-exitcode returns:
# 0 = Succeeded, no changes
# 1 = Error/Failed
# 2 = Succeeded, changes present
set +e
terraform plan -var-file="environments/demo.tfvars" -out=tfplan
PLAN_STATUS=$?
set -e

if [ $PLAN_STATUS -eq 0 ]; then
  echo "Plan succeeded! No infrastructure changes required."

elif [ $PLAN_STATUS -eq 2 ]; then
  echo "Plan succeeded! Changes detected. Proceeding to apply..."
  terraform apply -auto-approve tfplan

else
  echo "Error: Terraform plan failed. Halting deployment."
  exit 1
fi