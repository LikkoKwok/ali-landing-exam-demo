variable "environment"             { type = string }
variable "region"                  { type = string }
variable "secondary_region"        { type = string }

variable "firewall_instance_type"  { 
    type = string
    default = "ecs.g6.large"
    }

variable "backbone_bandwidth_mbps" { 
    type = number
    default = 2
    }

variable "az_count" { 
    type = number
    default = 2 
    }

variable "image_id" { 
    type = string
    default = "aliyun_3_x64_20G_alibase_20240528.vhd"
    }

variable "tags" { 
    type = map(string)
    default = {} 
    }

# Add this variable
variable "hub_vpc_cidr" {
  description = "CIDR block for Hub Security VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "dataworks_vpc_id" {
  description = "VPC ID of DataWorks resource group"
  type        = string
  default     = "vpc-j6cdk2e6cx03izj1kuc3w"
}

variable "dataworks_vswitch_id" {
  description = "VSwitch ID of DataWorks resource group"
  type        = string
  default     = "vsw-j6cnw80zcmukfa848xe3a"
}

variable "transit_router_id" {
  description = "Existing Transit Router ID (manually created)"
  type        = string
  default     = "tr-j6c5jwesgz9rc5ir9tqxn"
}
