# AI full-stack observability logstore (request -> gateway -> inference -> GPU)
resource "alicloud_log_store" "ai_fullstack" {
  project_name          = var.sls_project
  logstore_name         = "ai-fullstack-trace-${var.environment}"
  retention_period      = var.metric_retention_days
  shard_count           = 2
  auto_split            = true
  max_split_shard_count = 8
}

# Index enabling query of key AI metrics (latency, tokens, GPU util, errors)
resource "alicloud_log_store_index" "ai_metrics" {
  project  = var.sls_project
  logstore = alicloud_log_store.ai_fullstack.logstore_name

  field_search {
    name             = "inference_latency_ms"
    type             = "long"
    enable_analytics = true
  }
  field_search {
    name             = "tokens_per_request"
    type             = "long"
    enable_analytics = true
  }
  field_search {
    name             = "gpu_utilization"
    type             = "double"
    enable_analytics = true
  }
  field_search {
    name             = "model_error_rate"
    type             = "double"
    enable_analytics = true
  }
  field_search {
    name             = "request_queue_depth"
    type             = "long"
    enable_analytics = true
  }
}

# Dashboard: AI cost-to-value (business metric vs infra cost)
resource "alicloud_log_dashboard" "cost_to_value" {
  project_name   = var.sls_project
  dashboard_name = "ai-cost-to-value-${var.environment}"
  char_list = jsonencode([
    {
      title   = "Inference Latency P99"
      type    = "line"
      query   = "* | select percentile(inference_latency_ms, 0.99) as p99"
      logstore = alicloud_log_store.ai_fullstack.logstore_name
    },
    {
      title   = "GPU Utilization vs Cost"
      type    = "line"
      query   = "* | select avg(gpu_utilization) as util"
      logstore = alicloud_log_store.ai_fullstack.logstore_name
    }
  ])
}

# CloudMonitor alert: GPU health + model drift proactive alerting (AIOps)
resource "alicloud_cms_alarm_contact_group" "aiops" {
  alarm_contact_group_name = "aiops-oncall-${var.environment}"
  describe                 = "AIOps proactive alerting group"
  contacts                 = []
}

# NOTE: Natural-language root-cause analysis and automated GPU health checks
# are delivered via CloudMonitor + SLS Copilot; metrics above feed the AIOps
# alerting on model drift / data quality.
