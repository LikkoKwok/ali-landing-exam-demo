# ============================================
# Terraform does not support automatic member account creation with Reseller Account,
# manually creation of member accounts via console is required before terraform can manage the accounts. 
# Please follow the steps below to create member accounts under reseller account:
# ============================================

# resource "alicloud_resource_manager_resource_directory" "rd" {
#   status = "Enabled"
# }

# resource "alicloud_resource_manager_folder" "management" {
#   folder_name      = "Management-OU"
#   parent_folder_id = alicloud_resource_manager_resource_directory.rd.root_folder_id
# }

# resource "alicloud_resource_manager_folder" "core_insurance" {
#   folder_name      = "Core-Insurance-OU"
#   parent_folder_id = alicloud_resource_manager_resource_directory.rd.root_folder_id
# }

# resource "alicloud_resource_manager_folder" "ai_lab" {
#   folder_name      = "AI-Innovation-Lab-OU"
#   parent_folder_id = alicloud_resource_manager_resource_directory.rd.root_folder_id
# }

# resource "alicloud_resource_manager_account" "reseller_member_account" {
#   display_name        = "Project-Account-Terraform"
#   resell_account_type = "resell"  
# }


# ============================================
# Control Policy: forbid deletion of central log store (Requirement 6)
# Action Trail
# ============================================

resource "alicloud_resource_manager_control_policy" "protect_logs" {
  control_policy_name = "deny-logstore-deletion"
  description         = "Prevents deletion of central audit logs"
  effect_scope        = "RAM"
  policy_document = jsonencode({
    Version = "1"
    Statement = [{
      Effect   = "Deny"
      Action   = ["log:DeleteLogStore", "log:DeleteProject"]
      Resource = "*"
    }]
  })
}

resource "alicloud_resource_manager_control_policy_attachment" "root" {
  policy_id = alicloud_resource_manager_control_policy.protect_logs.id
  target_id = alicloud_resource_manager_resource_directory.rd.root_folder_id
}

# Control Policy: deny disabling ActionTrail
resource "alicloud_resource_manager_control_policy" "protect_trail" {
  control_policy_name = "deny-actiontrail-stop"
  description         = "Prevents stopping or deleting ActionTrail"
  effect_scope        = "RAM"
  policy_document = jsonencode({
    Version = "1"
    Statement = [{
      Effect   = "Deny"
      Action   = ["actiontrail:DeleteTrail", "actiontrail:StopLogging"]
      Resource = "*"
    }]
  })
}

resource "alicloud_resource_manager_control_policy_attachment" "trail_root" {
  policy_id = alicloud_resource_manager_control_policy.protect_trail.id
  target_id = alicloud_resource_manager_resource_directory.rd.root_folder_id
}


locals {
  # manual creation of member accounts under reseller account
  manual_accounts = {
    shared_service = "5947182043430388"
    hub_security    = "5204482043670830"
    log    = "5512782043745792"
    app    = "5641082043830083"
    ai_inference = "5025582043875056"
    ai_training = "5977182043911351"
  }
}