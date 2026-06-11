output "registry_bucket"      { value = alicloud_oss_bucket.model_registry.bucket }
output "promotion_policy_name" { value = alicloud_ram_policy.promotion_gate.policy_name }
