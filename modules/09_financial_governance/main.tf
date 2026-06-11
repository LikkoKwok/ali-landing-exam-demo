# Resource Group per business line for cost attribution
locals {
  business_lines = ["claims", "actuarial", "customer-service", "shared"]
}

resource "alicloud_resource_manager_resource_group" "lines" {
  for_each            = toset(local.business_lines)
  resource_group_name = "rg-${each.key}-${var.environment}"
  display_name        = "${each.key}-${var.environment}"
}

# Budget with hard cap + alert at AI project level
resource "alicloud_bss_business_budget" "ai_budget" {
  for_each       = var.project_budgets
  budget_name    = "budget-${each.key}-${var.environment}"
  budget_type    = "cost"
  budget_cycle   = "Monthly"
  total_amount   = each.value.amount
  currency       = "USD"

  notifications {
    threshold_type        = "percentage"
    threshold_amount      = 80
    notification_channels = ["email"]
  }
  notifications {
    threshold_type        = "percentage"
    threshold_amount      = 100
    notification_channels = ["email"]
  }
}

# NOTE: Hard-stop (auto-pause training on budget breach) is enforced in the
# MLOps pipeline via a budget-check gate that queries BSS before scaling GPUs.
