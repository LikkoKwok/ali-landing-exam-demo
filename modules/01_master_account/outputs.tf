output "resource_directory_id" {
  value = alicloud_resource_manager_resource_directory.rd.id
}

output "root_folder_id" {
  value = alicloud_resource_manager_resource_directory.rd.root_folder_id
}

output "insurance_account_ids" {
  value = { for k, a in alicloud_resource_manager_account.insurance : k => a.id }
}

output "ai_account_ids" {
  value = { for k, a in alicloud_resource_manager_account.ai : k => a.id }
}
