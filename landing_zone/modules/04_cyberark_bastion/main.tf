resource "alicloud_security_group" "cyberark" {
  security_group_name = "cyberark-pam-sg"
  vpc_id              = var.vpc_id
  description         = "CyberArk PAM bastion (mock)"
  tags                = var.tags
}

resource "alicloud_security_group_rule" "ssh_in" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.cyberark.id
  cidr_ip           = var.admin_source_cidr
}

resource "alicloud_instance" "cyberark" {
  instance_name         = "cyberark-pam-bastion"
  instance_type         = var.instance_type
  image_id              = var.image_id
  vswitch_id            = var.ops_vswitch_id
  security_groups       = [alicloud_security_group.cyberark.id]
  system_disk_category  = "cloud_essd"
  system_disk_encrypted = true
  tags = merge(var.tags, { Role = "PAM-Bastion", Vendor = "CyberArk", Mock = "true" })
}
