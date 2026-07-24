# =============================================================================
# VARIABLE DEFINITIONS
# Enterprise Zero-Trust Identity Architecture
# =============================================================================

# -----------------------------------------------------------------------------
# Azure Configuration
# -----------------------------------------------------------------------------

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
  sensitive   = true
  
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.tenant_id))
    error_message = "Tenant ID must be a valid UUID format."
  }
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Resource group name for all resources"
  type        = string
  default     = "rg-identity-security-prod"
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "East US"
  
  validation {
    condition     = contains(["East US", "West US", "North Europe", "West Europe", "Southeast Asia"], var.location)
    error_message = "Location must be a supported Azure region."
  }
}

# -----------------------------------------------------------------------------
# Environment Configuration
# -----------------------------------------------------------------------------

variable "environment" {
  description = "Deployment environment (dev, staging, production)"
  type        = string
  default     = "production"
  
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be 'dev', 'staging', or 'production'."
  }
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "zero-trust-identity"
}

variable "owner" {
  description = "Resource owner (team or individual)"
  type        = string
  default     = "Security Architecture Team"
}

# -----------------------------------------------------------------------------
# Conditional Access Configuration
# -----------------------------------------------------------------------------

variable "enable_legacy_auth_block" {
  description = "Block legacy authentication protocols"
  type        = bool
  default     = true
}

variable "require_mfa_for_all_users" {
  description = "Require MFA for all user accounts"
  type        = bool
  default     = true
}

variable "require_compliant_device" {
  description = "Require Intune-compliant devices for access"
  type        = bool
  default     = true
}

variable "mfa_exempt_users" {
  description = "List of users exempt from MFA requirements (break-glass accounts)"
  type        = list(string)
  default     = ["break-glass-admin@company.com"]
}

variable "trusted_locations" {
  description = "List of trusted IP ranges (corporate offices)"
  type        = list(string)
  default     = ["203.0.113.0/24", "198.51.100.0/24"]
}

variable "blocked_countries" {
  description = "List of countries to block access from"
  type        = list(string)
  default     = ["CN", "RU", "KP", "IR"]
}

# -----------------------------------------------------------------------------
# PIM Configuration
# -----------------------------------------------------------------------------

variable "pim_approval_required" {
  description = "Require approval for PIM role activation"
  type        = bool
  default     = true
}

variable "pim_max_activation_duration" {
  description = "Maximum PIM activation duration (ISO 8601 format)"
  type        = string
  default     = "PT8H"
}

variable "pim_approvers" {
  description = "List of PIM approval administrators"
  type        = list(string)
  default     = ["security-lead@company.com", "ciso@company.com"]
}

variable "pim_notification_recipients" {
  description = "List of email addresses for PIM notifications"
  type        = list(string)
  default     = ["security-ops@company.com"]
}

# -----------------------------------------------------------------------------
# Service Principal Configuration
# -----------------------------------------------------------------------------

variable "service_principal_rotation_days" {
  description = "Days before expiration to rotate service principal secrets"
  type        = number
  default     = 90
}

variable "service_principal_notification_email" {
  description = "Email address for service principal rotation notifications"
  type        = string
  default     = "security-ops@company.com"
}

# -----------------------------------------------------------------------------
# PAM Integration (CyberArk & Kron)
# -----------------------------------------------------------------------------

variable "cyberark_vault_url" {
  description = "CyberArk PAS vault URL"
  type        = string
  sensitive   = true
}

variable "cyberark_api_key" {
  description = "CyberArk API authentication key"
  type        = string
  sensitive   = true
}

variable "kron_pam_url" {
  description = "Kron PAM enterprise URL"
  type        = string
  sensitive   = true
}

variable "kron_api_token" {
  description = "Kron PAM API authentication token"
  type        = string
  sensitive   = true
}

# -----------------------------------------------------------------------------
# Monitoring & Sentinel
# -----------------------------------------------------------------------------

variable "sentinel_workspace_id" {
  description = "Azure Sentinel Log Analytics Workspace ID"
  type        = string
  sensitive   = true
}

variable "enable_threat_detection" {
  description = "Enable automated threat detection and response"
  type        = bool
  default     = true
}

variable "security_alert_email" {
  description = "Email address for security alerts"
  type        = string
  default     = "soc@company.com"
}

variable "alert_severity_threshold" {
  description = "Minimum alert severity to notify (Low, Medium, High, Critical)"
  type        = string
  default     = "Medium"
  
  validation {
    condition     = contains(["Low", "Medium", "High", "Critical"], var.alert_severity_threshold)
    error_message = "Severity must be Low, Medium, High, or Critical."
  }
}

# -----------------------------------------------------------------------------
# Compliance & Governance
# -----------------------------------------------------------------------------

variable "compliance_frameworks" {
  description = "Compliance frameworks to implement"
  type        = list(string)
  default     = ["NIST-800-53", "ISO-27001", "SOX"]
}

variable "audit_log_retention_days" {
  description = "Number of days to retain audit logs"
  type        = number
  default     = 365
}

variable "enable_access_reviews" {
  description = "Enable quarterly access reviews"
  type        = bool
  default     = true
}

variable "access_review_frequency" {
  description = "Access review frequency in days"
  type        = number
  default     = 90
}

# -----------------------------------------------------------------------------
# Tags (Applied to all resources)
# -----------------------------------------------------------------------------

variable "default_tags" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "zero-trust-identity"
    Environment = "production"
    Owner       = "Security Architecture Team"
    CostCenter  = "IT-Security-001"
    Compliance  = "NIST-800-53,ISO-27001,SOX"
  }
}
