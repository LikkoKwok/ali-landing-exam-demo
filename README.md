# ali-landing-exam-demo

## First test by terraform plan (overwrite existing tfplan file):
terraform plan -out tfplan

## To test for config, terraform apply:
terraform apply -var-file="environments/demo.tfvars"

## Or:
terraform apply "tfplan"

## If needed to manual enable services on console:
cd landing_zone
terraform refresh -var-file="environments/demo.tfvars"

## Last Resort:

Delete state file in OSS:
aliyun oss rm oss://oss-alicloud-sso-demo-tfstate-01/landing-zone/state/terraform.tfstate

Clean local state:
run clean_apply.sh

## apply modules one by one to figure out bottleneck:

terraform apply -target=module.hub_security -var-file="environments/demo.tfvars"
terraform apply -target=module.core_insurance_app -var-file="environments/demo.tfvars"

terraform apply -target=module.pai_platform -var-file="environments/demo.tfvars"
terraform apply -target=module.ai_data_security -var-file="environments/demo.tfvars"
terraform apply -target=module.master_account -var-file="environments/demo.tfvars"



# 1. At DataWorks console locate project ID
# 2. Import
terraform import module.ai_data_security.alicloud_data_works_project.dsc_pipeline <project-id>