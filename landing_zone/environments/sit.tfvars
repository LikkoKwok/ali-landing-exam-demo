region           = "cn-hongkong"
secondary_region = "ap-southeast-1"
environment      = "sit"

hub_account_id = "2222222222222222"
log_account_id = "3333333333333333"
app_account_id = "4444444444444444"
ai_account_id  = "5555555555555555"

vpc_cidr               = "10.40.0.0/16"
az_count               = 2
enable_gpu_cluster     = false
enable_cyberark        = true
firewall_instance_type = "ecs.g6.large"
backbone_bandwidth_mbps = 5
log_retention_days     = 90
azure_ad_metadata_url  = "https://login.microsoftonline.com/<tenant>/federationmetadata/2007-06/federationmetadata.xml"

common_tags = {
  CostCenter = "insurance-sit"
  DataClass  = "internal"
  Region     = "cn-hongkong"
}
