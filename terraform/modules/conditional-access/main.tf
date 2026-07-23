# Conditional Access Policy - Require MFA
resource "azuread_conditional_access_policy" "require_mfa" {
  display_name = "CA-POLICY-001: Require MFA for All Users"
  state        = "enabled"

  conditions {
    users {
      included_users = ["All"]
      excluded_users = ["break-glass-admin@company.com"]
    }

    applications {
      included_applications = ["All"]
    }

    client_applications {
      included_client_applications = ["All"]
    }

    locations {
      included_locations = ["All"]
    }

    platforms {
      included_platforms = ["All"]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}

# Conditional Access Policy - Block Legacy Authentication
resource "azuread_conditional_access_policy" "block_legacy_auth" {
  display_name = "CA-POLICY-002: Block Legacy Authentication"
  state        = "enabled"

  conditions {
    users {
      included_users = ["All"]
    }

    applications {
      included_applications = ["All"]
    }

    client_app_types = ["exchangeActiveSync", "other"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

# Conditional Access Policy - Compliant Device Required
resource "azuread_conditional_access_policy" "require_compliant_device" {
  display_name = "CA-POLICY-003: Require Compliant Device for Sensitive Apps"
  state        = "enabled"

  conditions {
    users {
      included_users = ["All"]
    }

    applications {
      included_applications = [
        "00000003-0000-0000-c000-000000000000", # Microsoft Graph
        "00000002-0000-0000-c000-000000000000"  # Exchange Online
      ]
    }

    platforms {
      included_platforms = ["windows", "iOS", "android"]
    }
  }

  grant_controls {
    operator          = "AND"
    built_in_controls = ["compliantDevice", "mfa"]
  }
}
