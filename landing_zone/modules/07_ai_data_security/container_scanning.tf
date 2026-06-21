# ============================================
# CONTAINER IMAGE SCANNING ENFORCEMENT
# Production: Use ACR Enterprise with built-in scanning
# ============================================

# Valid instance_type values: Basic, Standard, Advanced (not Enterprise)
# Use free personal edition
resource "alicloud_cr_ee_instance" "acr" {
  count          = 0  # Disable enterprise version for cost saving demo purpo
  instance_name  = "ai-acr-${var.environment}"
  instance_type  = "Basic"
  payment_type   = "Subscription"
  period         = 1
}