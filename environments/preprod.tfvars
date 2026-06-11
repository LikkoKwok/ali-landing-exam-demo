region           = "cn-hongkong"
secondary_region = "ap-southeast-1"
environment      = "preprod"

hub_account_id = "2222222222222222"
log_account_id = "3333333333333333"
app_account_id = "8888888888888888"
ai_account_id  = "9999999999999999"

vpc_cidr               = "10.60.0.0/16"
az_count               = 3
enable_gpu_cluster     = true
enable_cyberark        = true
gpu_instance_type      = "ecs.gn7-c12g1.3xlarge"
firewall_instance_type = "ecs.g7.large"
backbone_bandwidth_mbps = 100
log_retention_days     = 1095
azure_ad_metadata_url  = "https://login.microsoftonline.com/<tenant>/federationmetadata/2007-06/federationmetadata.xml"

common_tags = {
  CostCenter = "insurance-preprod"
  Compliance = "HKMA,IA,MAS-TRM,PDPO,PDPA"
  DataClass  = "confidential"
  Region     = "cn-hongkong"
}
