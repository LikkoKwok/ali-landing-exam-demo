# Versioned, encrypted model registry
resource "alicloud_oss_bucket" "model_registry" {
  bucket = "model-registry-${var.environment}"
  tags   = merge(var.tags, { Purpose = "model-registry" })
}

resource "alicloud_oss_bucket_versioning" "registry_ver" {
  bucket = alicloud_oss_bucket.model_registry.bucket
  status = "Enabled"
}

resource "alicloud_oss_bucket_server_side_encryption" "registry_enc" {
  bucket            = alicloud_oss_bucket.model_registry.bucket
  sse_algorithm     = "KMS"
  kms_master_key_id = var.kms_key_id
}

# Approval gate: only model_reviewer principals may write to production/ prefix
resource "alicloud_ram_policy" "promotion_gate" {
  policy_name = "model-promotion-gate-${var.environment}"
  policy_document = jsonencode({
    Version = "1"
    Statement = [{
      Effect    = "Deny"
      Action    = ["oss:PutObject"]
      Resource  = ["acs:oss:*:*:${alicloud_oss_bucket.model_registry.bucket}/production/*"]
      Condition = {
        StringNotEquals = { "acs:PrincipalTag/role" = "model_reviewer" }
      }
    }]
  })
}
