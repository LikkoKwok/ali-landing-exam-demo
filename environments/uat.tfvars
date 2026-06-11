region           = "cn-hongkong"
secondary_region = "ap-southeast-1"
environment      = "uat"

hub_account_id = "2222222222222222"
log_account_id = "3333333333333333"
app_account_id = "6666666666666666"
ai_account_id  = "7777777777777777"

vpc_cidr               = "10.50.0.0/16"
az_count               = 2
enable_gpu_cluster     = true
enable_cyberark        = true
gpu_instance_type      = "ecs.gn6i-c4g1.xlarge"
firewall_instance_type = "ecs.g6.large"
backbone_bandwidth_mbps = 20
log_retention_days     = 365
azure_ad_metadata_url  = "https://login.microsoftonline.com/<tenant>/federationmetadata/2007-06/federationmetadata.xml"

common_tags = {
  CostCenter = "insurance-uat"
  DataClass  = "confidential"
  Region     = "cn-hongkong"
}
