output "vpc_id"            { value = alicloud_vpc.webapp.id }
output "internal_vpc_id"   { value = alicloud_vpc.internal.id }
output "resource_group_id" { value = alicloud_resource_manager_resource_group.insurance.id }
output "db_connection"     { value = alicloud_db_instance.core.connection_string }
