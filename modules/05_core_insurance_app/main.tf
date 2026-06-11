data "alicloud_zones" "available" {
  available_resource_creation = "VSwitch"
}

# Web/App VPC
resource "alicloud_vpc" "webapp" {
  vpc_name   = "${var.environment}-webapp-vpc"
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Tier = "web-app" })
}

resource "alicloud_vswitch" "webapp" {
  count        = var.az_count
  vpc_id       = alicloud_vpc.webapp.id
  cidr_block   = cidrsubnet(var.vpc_cidr, 8, count.index)
  zone_id      = data.alicloud_zones.available.zones[count.index].id
  vswitch_name = "${var.environment}-webapp-${count.index}"
  tags         = var.tags
}

# Internal VPC (RDS / OSS access / NAS)
resource "alicloud_vpc" "internal" {
  vpc_name   = "${var.environment}-internal-vpc"
  cidr_block = cidrsubnet(var.vpc_cidr, 0, 0) == var.vpc_cidr ? "10.20.0.0/16" : "10.20.0.0/16"
  tags       = merge(var.tags, { Tier = "internal" })
}

resource "alicloud_vswitch" "internal" {
  count        = var.az_count
  vpc_id       = alicloud_vpc.internal.id
  cidr_block   = cidrsubnet("10.20.0.0/16", 8, count.index)
  zone_id      = data.alicloud_zones.available.zones[count.index].id
  vswitch_name = "${var.environment}-internal-${count.index}"
  tags         = var.tags
}

# Resource Group for cost attribution
resource "alicloud_resource_manager_resource_group" "insurance" {
  resource_group_name = "rg-insurance-${var.environment}"
  display_name        = "Insurance-${var.environment}"
}

# Encrypted RDS (MSSQL) in internal VPC
resource "alicloud_db_instance" "core" {
  engine               = "SQLServer"
  engine_version       = "2019_ent"
  instance_type        = var.db_instance_class
  instance_storage     = var.db_storage_gb
  vswitch_id           = alicloud_vswitch.internal[0].id
  instance_name        = "${var.environment}-core-insurance-db"
  encryption_key       = var.kms_key_id
  resource_group_id    = alicloud_resource_manager_resource_group.insurance.id
  tags                 = var.tags
}

# Encrypted OSS for application data
resource "alicloud_oss_bucket" "app_data" {
  bucket = "insurance-app-${var.environment}"
  tags   = var.tags
}

resource "alicloud_oss_bucket_server_side_encryption" "app_enc" {
  bucket            = alicloud_oss_bucket.app_data.bucket
  sse_algorithm     = "KMS"
  kms_master_key_id = var.kms_key_id
}

# Attach app VPC to the CEN Transit Router
resource "alicloud_cen_transit_router_vpc_attachment" "webapp" {
  cen_id            = var.cen_id
  transit_router_id = var.transit_router
  vpc_id            = alicloud_vpc.webapp.id
  zone_mappings {
    zone_id    = data.alicloud_zones.available.zones[0].id
    vswitch_id = alicloud_vswitch.webapp[0].id
  }
}
