# ============================================
# DATA SOURCES
# ============================================
data "alicloud_zones" "available" {
  available_resource_creation = "VSwitch"
}

# ============================================
# SHARED SERVICE VPC
# Contains: Unified Ingress SLB, CyberArk, Ops Bastion
# ============================================
resource "alicloud_vpc" "shared_service" {
  vpc_name   = "${var.environment}-shared-service-vpc"
  cidr_block = var.shared_service_vpc_cidr
  tags       = merge(var.tags, { Service = "shared-services" })

  lifecycle {
    prevent_destroy = true
  }
}

# Shared Service Subnets
resource "alicloud_vswitch" "unified_ingress" {
  vpc_id       = alicloud_vpc.shared_service.id
  cidr_block   = cidrsubnet(var.shared_service_vpc_cidr, 8, 1)
  zone_id      = data.alicloud_zones.available.zones[0].id
  vswitch_name = "${var.environment}-unified-ingress"
  tags         = merge(var.tags, { Tier = "ingress" })
}

resource "alicloud_vswitch" "ai_gateway" {
  vpc_id       = alicloud_vpc.shared_service.id
  cidr_block   = cidrsubnet(var.shared_service_vpc_cidr, 8, 10)
  zone_id      = data.alicloud_zones.available.zones[0].id
  vswitch_name = "${var.environment}-ai-gateway"
  tags         = merge(var.tags, { Tier = "ai-gateway" })
}

resource "alicloud_vswitch" "cyberark_pvwa" {
  vpc_id       = alicloud_vpc.shared_service.id
  cidr_block   = cidrsubnet(var.shared_service_vpc_cidr, 8, 20)
  zone_id      = data.alicloud_zones.available.zones[0].id
  vswitch_name = "${var.environment}-cyberark-pvwa"
  tags         = merge(var.tags, { Tier = "cyberark" })
}

resource "alicloud_vswitch" "cyberark_vault" {
  vpc_id       = alicloud_vpc.shared_service.id
  cidr_block   = cidrsubnet(var.shared_service_vpc_cidr, 8, 21)
  zone_id      = data.alicloud_zones.available.zones[0].id
  vswitch_name = "${var.environment}-cyberark-vault"
  tags         = merge(var.tags, { Tier = "cyberark" })
}

resource "alicloud_vswitch" "ops_bastion" {
  vpc_id       = alicloud_vpc.shared_service.id
  cidr_block   = cidrsubnet(var.shared_service_vpc_cidr, 8, 30)
  zone_id      = data.alicloud_zones.available.zones[0].id
  vswitch_name = "${var.environment}-ops-bastion"
  tags         = merge(var.tags, { Tier = "ops" })
}

# ============================================
# UNIFIED INGRESS SLB
# ============================================
resource "alicloud_slb_load_balancer" "unified_ingress" {
  load_balancer_name   = "${var.environment}-unified-ingress"
  vswitch_id           = alicloud_vswitch.unified_ingress.id
  load_balancer_spec   = "slb.s2.small"
  address_type         = "intranet"
  tags                 = var.tags
}

# ============================================
# BASTION HOST (Jump server)
# ============================================
resource "alicloud_security_group" "bastion_sg" {
  vpc_id      = alicloud_vpc.shared_service.id
  security_group_name        = "${var.environment}-bastion-sg"
  description = "Security group for bastion host"
  tags        = merge(var.tags, { Service = "bastion" })
}

# Inbound: SSH from your public IP
resource "alicloud_security_group_rule" "bastion_ssh_from_me" {
  count             = var.my_public_ip != "" ? 1 : 0
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.bastion_sg.id
  cidr_ip           = var.my_public_ip
  description       = "SSH from my public IP"
}

# Outbound: SSH to all internal VPCs (10.0.0.0/8)
resource "alicloud_security_group_rule" "bastion_to_internal" {
  type              = "egress"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.bastion_sg.id
  cidr_ip           = "10.0.0.0/8"
  description       = "SSH to all internal VPCs"
}

# Bastion ECS instance
resource "alicloud_instance" "bastion" {
  instance_name   = "${var.environment}-bastion-host"
  instance_type   = var.instance_type
  image_id        = var.image_id
  vswitch_id      = alicloud_vswitch.ops_bastion.id
  security_groups = [alicloud_security_group.bastion_sg.id]
  
  # Bind a public IP
  internet_max_bandwidth_out = 5
  
  system_disk_category  = "cloud_essd"
  system_disk_encrypted = true
  
  tags = merge(var.tags, { 
    Service = "bastion-host",
    Role    = "management"
  })
}

# ============================================
# ATTACH SHARED SERVICE VPC TO CEN
# ============================================
resource "alicloud_cen_transit_router_vpc_attachment" "shared_service" {
  # count             = var.cen_id != "" ? 1 : 0    # count will affect terraform planning
  cen_id            = var.cen_id
  transit_router_id = var.transit_router_id
  vpc_id            = alicloud_vpc.shared_service.id
  zone_mappings {
    zone_id    = data.alicloud_zones.available.zones[0].id
    vswitch_id = alicloud_vswitch.unified_ingress.id
  }
}