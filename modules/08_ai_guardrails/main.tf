# LLM guardrails: defense-in-depth via content moderation + RAM-scoped logging.
# Input validation, retrieval-time inspection, and output screening are enforced
# at the AI gateway layer; this module provisions the supporting infra.

# OSS bucket holding guardrail policy configs (versioned)
resource "alicloud_oss_bucket" "guardrail_policies" {
  bucket = "ai-guardrail-policies-${var.environment}"
  tags   = merge(var.tags, { Purpose = "llm-guardrails" })
}

resource "alicloud_oss_bucket_versioning" "policy_ver" {
  bucket = alicloud_oss_bucket.guardrail_policies.bucket
  status = "Enabled"
}

# RAM role for the guardrail/moderation service (temp creds)
resource "alicloud_ram_role" "guardrail" {
  role_name = "ai-guardrail-service-${var.environment}"

  assume_role_policy_document = jsonencode({   # ⬅️ fixed
    Version = "1"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = ["ecs.aliyuncs.com"] }
    }]
  })

  max_session_duration = 3600
}


# NOTE: Content Moderation (Green) API handles prompt-injection / non-compliant
# content detection at input and output. Three checkpoints:
#   1. Retrieval-time content inspection (RAG source filtering)
#   2. Input validation before inference
#   3. Output screening after inference
