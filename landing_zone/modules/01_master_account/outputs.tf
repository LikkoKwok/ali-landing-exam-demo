# output "resource_directory_id" {
#   value = alicloud_resource_manager_resource_directory.rd.id
# }

# output "root_folder_id" {
#   value = alicloud_resource_manager_resource_directory.rd.root_folder_id
# }


output "account_ids" {
  value = {
    shared_service = "5947182043430388"
    hub_security   = "5204482043670830"
    log            = "5512782043745792"
    app            = "5641082043830083"
    ai_inference   = "5025582043875056"
    ai_training    = "5977182043911351"
  }
}