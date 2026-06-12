output "guardrail_policy_bucket" { value = alicloud_oss_bucket.guardrail_policies.bucket }
output "guardrail_role_arn"      { value = alicloud_ram_role.guardrail.arn }
