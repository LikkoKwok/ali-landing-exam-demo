region           = "cn-hongkong"
secondary_region = "ap-southeast-1"
environment      = "prod"

hub_account_id = "2222222222222222"
log_account_id = "3333333333333333"
app_account_id = "4444444444444444"
ai_account_id  = "5555555555555555"

vpc_cidr               = "10.10.0.0/16"
az_count               = 3
enable_gpu_cluster     = true
enable_cyberark        = true
gpu_instance_type      = "ecs.gn7-c12g1.3xlarge"
firewall_instance_type = "ecs.g7.2xlarge"
backbone_bandwidth_mbps = 1000
log_retention_days     = 1095
azure_ad_metadata_url  = "https://login.microsoftonline.com/<tenant>/federationmetadata/2007-06/federationmetadata.xml"

common_tags = {
  CostCenter = "insurance-core"
  Compliance = "HKMA,IA,MAS-TRM,PDPO,PDPA,PCI-DSS"
  DataClass  = "confidential"
  Region     = "cn-hongkong"
}
