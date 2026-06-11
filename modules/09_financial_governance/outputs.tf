output "resource_group_ids" {
  value = { for k, rg in alicloud_resource_manager_resource_group.lines : k => rg.id }
}
