output "budget_info" {
  description = "Budget configuration for AI projects"
  value = {
    claims    = { amount = 5000, alert_threshold = 80 }
    actuarial = { amount = 8000, alert_threshold = 80 }
  }
}