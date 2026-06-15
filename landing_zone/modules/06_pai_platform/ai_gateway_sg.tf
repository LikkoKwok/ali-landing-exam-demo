# ============================================
# AI GATEWAY SECURITY GROUP
# Requirement: Centralized API key management, rate limiting, canary deployments
# ============================================

resource "alicloud_security_group" "ai_gateway_sg" {
  vpc_id      = alicloud_vpc.shared_service.id
  security_group_name        = "sg-ai-gateway-${var.environment_prefix}"
  description = "AI Gateway - API key validation, rate limiting, routing to AI services"
  tags        = merge(var.tags, { Service = "AI-Gateway" })
}

# ============================================
# INBOUND FROM PALO ALTO (internet traffic after inspection)
# ============================================
resource "alicloud_security_group_rule" "gateway_from_palo_alto" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "443/443"
  security_group_id = alicloud_security_group.ai_gateway_sg.id
  cidr_ip    = "10.20.2.0/24"  # Palo Alto Trust subnet
  description       = "HTTPS from Palo Alto after inspection"
}

# ============================================
# INBOUND FROM INTERNAL SERVICES (if any)
# ============================================
resource "alicloud_security_group_rule" "gateway_from_internal" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "443/443"
  security_group_id = alicloud_security_group.ai_gateway_sg.id
  cidr_ip    = "10.0.0.0/8"
  description       = "Internal service calls"
}

# ============================================
# OUTBOUND TO AI SERVICES (Claims, Customer Service, etc.)
# ============================================
resource "alicloud_security_group_rule" "gateway_to_claims" {
  type              = "egress"
  ip_protocol       = "tcp"
  port_range        = "8443/8443"
  security_group_id = alicloud_security_group.ai_gateway_sg.id
  cidr_ip           = "10.2.40.0/24"  # Claims subnet
  description       = "Route to AI Claims service"
}

resource "alicloud_security_group_rule" "gateway_to_customer_service" {
  type              = "egress"
  ip_protocol       = "tcp"
  port_range        = "8443/8443"
  security_group_id = alicloud_security_group.ai_gateway_sg.id
  cidr_ip           = "10.2.60.0/24"  # Customer Service subnet
  description       = "Route to AI Customer Service"
}

resource "alicloud_security_group_rule" "gateway_to_model_studio" {
  type              = "egress"
  ip_protocol       = "tcp"
  port_range        = "443/443"
  security_group_id = alicloud_security_group.ai_gateway_sg.id
  cidr_ip           = "0.0.0.0/0"
  description       = "To Alibaba Cloud Model Studio (SaaS)"
}