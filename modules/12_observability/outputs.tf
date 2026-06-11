output "ai_trace_logstore" {
  value = alicloud_log_store.ai_fullstack.logstore_name
}

output "cost_dashboard" {
  value = alicloud_log_dashboard.cost_to_value.dashboard_name
}

output "aiops_contact_group" {
  value = alicloud_cms_alarm_contact_group.aiops.id
}
