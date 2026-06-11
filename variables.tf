variable "region" {
  description = "Primary Alibaba Cloud region"
  type        = string
  default     = "cn-hongkong"
}

variable "secondary_region" {
  description = "Secondary region for HK<->SG backbone"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Deployment environment: demo, sit, uat, preprod, prod"
  type        = string
}

variable "hub_account_id" { type = string }
variable "log_account_id" { type = string }
variable "app_account_id" { type = string }
variable "ai_account_id"  { type = string }

variable "vpc_cidr" {
  description = "CIDR for the environment spoke VPC"
  type        = string
}

variable "az_count" {
  description = "Number of availability zones to span"
  type        = number
  default     = 2
}

variable "enable_gpu_cluster" {
  description = "Toggle GPU/AI training workloads"
  type        = bool
  default     = false
}

variable "enable_cyberark" {
  description = "Deploy CyberArk PAM mock"
  type        = bool
  default     = false
}

variable "gpu_instance_type" {
  type    = string
  default = "ecs.gn7-c12g1.3xlarge"
}

variable "firewall_instance_type" {
  type    = string
  default = "ecs.g6.large"
}

variable "backbone_bandwidth_mbps" {
  type    = number
  default = 2
}

variable "azure_ad_metadata_url" {
  type    = string
  default = ""
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
