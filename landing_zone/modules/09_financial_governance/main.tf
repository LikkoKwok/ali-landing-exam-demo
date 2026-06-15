# Comment out or remove the budget resource
# Alibaba Cloud budgets are managed via the BSS Console or API
# Terraform support is limited. For demo, explain in HLD.

# resource "alicloud_bss_business_budget" "ai_budget" { ... }  # COMMENT OUT

# Instead, use a local variable to document the budget configuration
locals {
  budget_config = {
    claims    = { amount = 5000, alert_threshold = 80 }
    actuarial = { amount = 8000, alert_threshold = 80 }
  }
}

locals {
  business_lines = ["claims", "actuarial", "customer-service", "shared"]
}

resource "alicloud_resource_manager_resource_group" "lines" {
  for_each            = toset(local.business_lines)
  resource_group_name = "rg-${each.key}-${var.environment}"
  display_name        = "${each.key}-${var.environment}"
}
# Note: Budget enforcement is documented in HLD. Actual budgets
# are created via Alibaba Cloud BSS console or API.