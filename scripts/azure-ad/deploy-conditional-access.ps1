<#
.SYNOPSIS
    Deploy Conditional Access Policies for Zero-Trust Architecture
.DESCRIPTION
    Automates deployment of enterprise Conditional Access policies
    with validation and rollback capability.
.AUTHOR
    ark Tiger - Cloud & Infrastructure Leader
.VERSION
    1.0.0
.LAST_UPDATED
    2024-01-15
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "staging", "production")]
    [string]$Environment,
    
    [Parameter(Mandatory=$false)]
    [string]$TenantId,
    
    [Parameter(Mandatory=$false)]
    [switch]$WhatIf,
    
    [Parameter(Mandatory=$false)]
    [switch]$ValidateOnly
)

# =============================================================================
# CONFIGURATION
# =============================================================================

$ErrorActionPreference = "Stop"
$startTime = Get-Date
$deploymentId = "CA-DEPLOY-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$logFile = "C:\Logs\CA-Deployment-$deploymentId.log"

# Policy definitions
$conditionalAccessPolicies = @(
    @{
        Name        = "CA-POLICY-001: Block Legacy Authentication"
        State       = "enabled"
        Users       = @{ Include = @("All"); Exclude = @() }
        Applications = @{ Include = @("All") }
        Conditions  = @{ ClientAppTypes = @("exchangeActiveSync", "other") }
        Controls    = @{ Operator = "OR"; BuiltIn = @("block") }
        Priority    = 1
    },
    @{
        Name        = "CA-POLICY-002: Require MFA for All Users"
        State       = "enabled"
        Users       = @{ Include = @("All"); Exclude = @("break-glass-admin@company.com") }
        Applications = @{ Include = @("All") }
        Conditions  = @{ }
        Controls    = @{ Operator = "OR"; BuiltIn = @("mfa") }
        Priority    = 2
    },
    @{
        Name        = "CA-POLICY-003: Require Compliant Device for Sensitive Apps"
        State       = "enabled"
        Users       = @{ Include = @("All"); Exclude = @() }
        Applications = @{ Include = @("00000003-0000-0000-c000-000000000000", "00000002-0000-0000-c000-000000000000") }
        Conditions  = @{ Platforms = @("windows", "iOS", "android") }
        Controls    = @{ Operator = "AND"; BuiltIn = @("compliantDevice", "mfa") }
        Priority    = 3
    },
    @{
        Name        = "CA-POLICY-004: Block High-Risk Sign-ins"
        State       = "enabled"
        Users       = @{ Include = @("All"); Exclude = @() }
        Applications = @{ Include = @("All") }
        Conditions  = @{ SignInRiskLevels = @("high") }
        Controls    = @{ Operator = "OR"; BuiltIn = @("block") }
        Priority    = 4
    },
    @{
        Name        = "CA-POLICY-005: Require MFA for Risky Sign-ins"
        State       = "enabled"
        Users       = @{ Include = @("All"); Exclude = @() }
        Applications = @{ Include = @("All") }
        Conditions  = @{ SignInRiskLevels = @("medium") }
        Controls    = @{ Operator = "OR"; BuiltIn = @("mfa") }
        Priority    = 5
    }
)

# =============================================================================
# FUNCTIONS
# =============================================================================

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error", "Success")]
        [string]$Level = "Info"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # Console output
    switch ($Level) {
        "Info"    { Write-Host $logEntry -ForegroundColor Cyan }
        "Warning" { Write-Host $logEntry -ForegroundColor Yellow }
        "Error"   { Write-Host $logEntry -ForegroundColor Red }
        "Success" { Write-Host $logEntry -ForegroundColor Green }
    }
    
    # File output
    Add-Content -Path $logFile -Value $logEntry
}

function Connect-ToAzureAD {
    Write-Log "Connecting to Azure AD..."
    
    try {
        if ($TenantId) {
            Connect-AzureAD -TenantId $TenantId -ErrorAction Stop
        } else {
            Connect-AzureAD -ErrorAction Stop
        }
        Write-Log "Successfully connected to Azure AD" -Level "Success"
        return $true
    }
    catch {
        Write-Log "Failed to connect to Azure AD: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Get-ExistingPolicies {
    Write-Log "Retrieving existing Conditional Access policies..."
    
    try {
        $existingPolicies = Get-AzureADMSConditionalAccessPolicy -All $true
        Write-Log "Found $($existingPolicies.Count) existing policies" -Level "Info"
        return $existingPolicies
    }
    catch {
        Write-Log "Failed to retrieve existing policies: $($_.Exception.Message)" -Level "Error"
        return @()
    }
}

function Create-ConditionalAccessPolicy {
    param(
        [hashtable]$PolicyConfig
    )
    
    Write-Log "Creating policy: $($PolicyConfig.Name)" -Level "Info"
    
    if ($WhatIf) {
        Write-Log "[WHATIF] Would create policy: $($PolicyConfig.Name)" -Level "Warning"
        return
    }
    
    try {
        # Build conditions object
        $conditions = New-Object -TypeName Microsoft.Open.MSGraphModel.ConditionalAccessConditionSet
        
        # Users
        $users = New-Object -TypeName Microsoft.Open.MSGraphModel.ConditionalAccessUsers
        $users.IncludeUsers = $PolicyConfig.Users.Include
        if ($PolicyConfig.Users.Exclude) {
            $users.ExcludeUsers = $PolicyConfig.Users.Exclude
        }
        $conditions.Users = $users
        
        # Applications
        $applications = New-Object -TypeName Microsoft.Open.MSGraphModel.ConditionalAccessApplications
        $applications.IncludeApplications = $PolicyConfig.Applications.Include
        $conditions.Applications = $applications
        
        # Build grant controls
        $grantControls = New-Object -TypeName Microsoft.Open.MSGraphModel.ConditionalAccessGrantControls
        $grantControls.Operator = $PolicyConfig.Controls.Operator
        $grantControls.BuiltInControls = $PolicyConfig.Controls.BuiltIn
        
        # Create policy
        $policy = New-Object -TypeName Microsoft.Open.MSGraphModel.ConditionalAccessPolicy
        $policy.DisplayName = $PolicyConfig.Name
        $policy.State = $PolicyConfig.State
        $policy.Conditions = $conditions
        $policy.GrantControls = $grantControls
        
        # Submit to Azure AD
        New-AzureADMSConditionalAccessPolicy -InputObject $policy
        
        Write-Log "Successfully created policy: $($PolicyConfig.Name)" -Level "Success"
        return $true
    }
    catch {
        Write-Log "Failed to create policy $($PolicyConfig.Name): $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Validate-PolicyDeployment {
    Write-Log "Validating policy deployment..." -Level "Info"
    
    $existingPolicies = Get-ExistingPolicies
    $expectedCount = $conditionalAccessPolicies.Count
    $actualCount = ($existingPolicies | Where-Object { $_.DisplayName -like "CA-POLICY-*" }).Count
    
    if ($actualCount -ge $expected
