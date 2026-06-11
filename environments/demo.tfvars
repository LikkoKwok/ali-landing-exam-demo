region           = "cn-hongkong"
secondary_region = "ap-southeast-1"
environment      = "demo"

# Single-account demo: all aliases point to one account
hub_account_id = "1111111111111111"
log_account_id = "1111111111111111"
app_account_id = "1111111111111111"
ai_account_id  = "1111111111111111"

vpc_cidr               = "10.90.0.0/16"
az_count               = 1
enable_gpu_cluster     = false
enable_cyberark        = true
firewall_instance_type = "ecs.t6-c1m1.large"
backbone_bandwidth_mbps = 2
log_retention_days     = 7
azure_ad_metadata_url  = "https://samltest.id/saml/idp"

common_tags = {
  CostCenter = "demo"
  Owner      = "exam-candidate"
  Region     = "cn-hongkong"
}
