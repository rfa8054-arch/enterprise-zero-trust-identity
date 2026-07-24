# Privileged Identity Management (PIM) Configuration
# Implements Just-In-Time access with time-bound privileges

# PIM Role Setting - Global Administrator
resource "azuread_privileged_access_role_setting" "global_admin" {
  scope_type        = "Directory"
  scope_id          = data.azuread_client_config.current.tenant_id
  role_definition_id = azuread_directory_role.global_admin.id

  # Approval required for activation
  approval_required       = true
  approved_users         = ["admin-approver@company.com"]
  
  # Justification required
  justification_required  = true
  
  # Time-bound activation
  activation_duration     = "PT8H"  # 8 hours max
  expiration_duration     = "P30D"  # 30 days assignment max
  
  # MFA required for activation
  mfa_required           = true
  
  # Notification settings
  notification_recipients = ["security-ops@company.com", "ciso@company.com"]
}

# PIM Role Setting - Security Administrator
resource "azuread_privileged_access_role_setting" "security_admin" {
  scope_type        = "Directory"
  scope_id          = data.azuread_client_config.current.tenant_id
  role_definition_id = azuread_directory_role.security_admin.id

  approval_required       = true
  approved_users         = ["security-lead@company.com"]
  justification_required  = true
  activation_duration     = "PT4H"  # 4 hours max
  expiration_duration     = "P14D"  # 14 days assignment max
  mfa_required           = true
  notification_recipients = ["security-ops@company.com"]
}

# PIM Role Setting - Exchange Administrator
resource "azuread_privileged_access_role_setting" "exchange_admin" {
  scope_type        = "Directory"
  scope_id          = data.azuread_client_config.current.tenant_id
  role_definition_id = azuread_directory_role.exchange_admin.id

  approval_required       = false  # Pre-approved for IT team
  justification_required  = true
  activation_duration     = "PT2H"  # 2 hours max
  expiration_duration     = "P7D"   # 7 days assignment max
  mfa_required           = true
  notification_recipients = ["it-ops@company.com"]
}

# Eligible Role Assignment - Break Glass Account
resource "azuread_privileged_access_role_assignment" "break_glass" {
  scope_type        = "Directory"
  scope_id          = data.azuread_client_config.current.tenant_id
  role_definition_id = azuread_directory_role.global_admin.id
  principal_id      = azuread_user.break_glass.object_id
  
  # Permanent eligible assignment (requires activation)
  assignment_type   = "Eligible"
  
  # Start and end dates for eligibility
  start_date        = "2024-01-01T00:00:00Z"
  end_date          = "2025-12-31T23:59:59Z"
}

# Alert: Multiple privileged roles assigned to same user
resource "azuread_privileged_access_alert" "multiple_roles" {
  display_name = "ALERT: Multiple Privileged Roles"
  severity     = "High"
  
  conditions {
    operator = "GreaterThanOrEqual"
    threshold = 2
    metric    = "PrivilegedRoleCount"
  }
  
  notification_recipients = ["security-ops@company.com", "ciso@company.com"]
  enabled                 = true
}

# Alert: Activation outside business hours
resource "azuread_privileged_access_alert" "after_hours_activation" {
  display_name = "ALERT: After-Hours Privileged Access"
  severity     = "Medium"
  
  conditions {
    time_range = "OutsideBusinessHours"
    business_hours_start = "08:00"
    business_hours_end   = "18:00"
    timezone             = "UTC"
  }
  
  notification_recipients = ["security-ops@company.com"]
  enabled                 = true
}

# Data sources
data "azuread_client_config" "current" {}

data "azuread_user" "break_glass" {
  user_principal_name = "break-glass-admin@company.com"
}

# Outputs
output "pim_role_settings" {
  description = "List of configured PIM role settings"
  value = {
    global_admin   = azuread_privileged_access_role_setting.global_admin.id
    security_admin = azuread_privileged_access_role_setting.security_admin.id
    exchange_admin = azuread_privileged_access_role_setting.exchange_admin.id
  }
}

output "pim_alerts_enabled" {
  description = "PIM alert configuration status"
  value = {
    multiple_roles      = azuread_privileged_access_alert.multiple_roles.enabled
    after_hours_activation = azuread_privileged_access_alert.after_hours_activation.enabled
  }
}
