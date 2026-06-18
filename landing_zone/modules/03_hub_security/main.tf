data "alicloud_zones" "available" {
  available_resource_creation = "VSwitch"
}

# Hub VPC
resource "alicloud_vpc" "hub" {
  vpc_name   = "${var.environment}-hub-vpc"
  cidr_block = var.hub_vpc_cidr
  tags       = var.tags
}

# VSwitches
resource "alicloud_vswitch" "untrusted" {
  vpc_id       = alicloud_vpc.hub.id
  cidr_block   = cidrsubnet(var.hub_vpc_cidr, 8, 1)
  zone_id      = data.alicloud_zones.available.zones[0].id
  vswitch_name = "${var.environment}-untrusted"
  tags         = var.tags
}

resource "alicloud_vswitch" "trusted" {
  vpc_id       = alicloud_vpc.hub.id
  cidr_block   = cidrsubnet(var.hub_vpc_cidr, 8, 2)
  zone_id      = data.alicloud_zones.available.zones[0].id
  vswitch_name = "${var.environment}-trusted"
  tags         = var.tags
}

resource "alicloud_vswitch" "ops" {
  vpc_id       = alicloud_vpc.hub.id
  cidr_block   = cidrsubnet(var.hub_vpc_cidr, 8, 3)
  zone_id      = data.alicloud_zones.available.zones[0].id
  vswitch_name = "${var.environment}-ops"
  tags         = var.tags
}

# KMS Key
# resource "alicloud_kms_key" "hub" {
#   description            = "Central KMS for at-rest encryption"
#   pending_window_in_days = 7
#   status                 = "Enabled"
# }

# Security Group for Palo Alto
resource "alicloud_security_group" "fw" {
  security_group_name = "${var.environment}-palo-alto-sg"
  vpc_id              = alicloud_vpc.hub.id
  tags                = var.tags
}

# Palo Alto Instances
resource "alicloud_instance" "palo_alto" {
  count                 = 2
  instance_name         = "${var.environment}-palo-alto-${count.index}"
  instance_type         = var.firewall_instance_type
  image_id              = var.image_id
  vswitch_id            = alicloud_vswitch.untrusted.id
  security_groups       = [alicloud_security_group.fw.id]
  system_disk_category  = "cloud_essd"
  system_disk_encrypted = true
  tags                  = merge(var.tags, { Role = "Firewall", Vendor = "PaloAlto", Mock = "true" })
}

# Data source to get ENI ID after instance creation
data "alicloud_network_interfaces" "palo_alto_eni" {
  depends_on  = [alicloud_instance.palo_alto]
  instance_id = alicloud_instance.palo_alto[0].id
}

# Route Table for Trusted Subnet - force traffic through Palo Alto
resource "alicloud_route_table" "trusted_rt" {
  vpc_id           = alicloud_vpc.hub.id
  route_table_name = "${var.environment}-trusted-rt"
}

resource "alicloud_route_table_attachment" "trusted" {
  vswitch_id     = alicloud_vswitch.trusted.id
  route_table_id = alicloud_route_table.trusted_rt.id
}

resource "alicloud_route_entry" "to_firewall" {
  route_table_id        = alicloud_route_table.trusted_rt.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NetworkInterface"
  nexthop_id            = data.alicloud_network_interfaces.palo_alto_eni.ids[0]
}

# Unified Ingress SLB
resource "alicloud_slb_load_balancer" "ingress" {
  load_balancer_name = "${var.environment}-unified-ingress"
  vswitch_id         = alicloud_vswitch.trusted.id
  load_balancer_spec = "slb.s2.small"
  address_type       = "intranet"
  tags               = var.tags
}

# CEN
resource "alicloud_cen_instance" "backbone" {
  cen_instance_name = "${var.environment}-hk-sg-backbone"
  description       = "HongKong primary CEN backbone"
  tags              = var.tags
}


resource "alicloud_cen_transit_router_vpc_attachment" "hub" {
  cen_id            = alicloud_cen_instance.backbone.id
  transit_router_id = var.transit_router_id
  vpc_id            = alicloud_vpc.hub.id
  zone_mappings {
    zone_id    = data.alicloud_zones.available.zones[0].id
    vswitch_id = alicloud_vswitch.trusted.id
  }
}

# CEN Bandwidth Package (temp disable KMS for budget reason)
# resource "alicloud_cen_bandwidth_package" "cross_border" {
#   geographic_region_a_id     = "China"
#   geographic_region_b_id     = "Asia-Pacific"
#   bandwidth                  = var.backbone_bandwidth_mbps
#   cen_bandwidth_package_name = "${var.environment}-hk-sg-bwp"
# }

# resource "alicloud_cen_bandwidth_package_attachment" "attach" {
#   instance_id          = alicloud_cen_instance.backbone.id
#   bandwidth_package_id = alicloud_cen_bandwidth_package.cross_border.id
# }

# ============================================
# ATTACH DATAWORKS VPC TO CEN
# ============================================

resource "alicloud_cen_transit_router_vpc_attachment" "dataworks" {
  count = var.dataworks_vpc_id != "" ? 1 : 0
  
  cen_id            = alicloud_cen_instance.backbone.id
  transit_router_id = var.transit_router_id
  vpc_id            = var.dataworks_vpc_id
  
  zone_mappings {
    zone_id    = data.alicloud_zones.available.zones[0].id
    vswitch_id = var.dataworks_vswitch_id
  }
}
