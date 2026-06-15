output "hub_vpc_id" {
  value = alicloud_vpc.hub.id
}

output "ops_vswitch_id" {
  value = alicloud_vswitch.ops.id
}

output "trusted_vswitch_id" {
  value = alicloud_vswitch.trusted.id
}

output "transit_router_id" {
  value = alicloud_cen_transit_router.tr.transit_router_id
}

output "cen_id" {
  value = alicloud_cen_instance.backbone.id
}

output "kms_key_id" {
  value = alicloud_kms_key.hub.id
}

output "ingress_slb_id" {
  value = alicloud_slb_load_balancer.ingress.id
}

output "firewall_instance_ids" {
  value = alicloud_instance.palo_alto[*].id
}

output "palo_alto_trust_eni_id" {
  value       = data.alicloud_network_interfaces.palo_alto_eni.ids[0]
  description = "ENI ID of Palo Alto primary interface for route table next-hop"
}