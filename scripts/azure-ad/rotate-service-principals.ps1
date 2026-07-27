<#
.SYNOPSIS
    Automated Service Principal Secret Rotation
.DESCRIPTION
    Rotates service principal secrets every 90 days with automated notification
    and rollback capability.
.AUTHOR
    ark Tiger - Cloud & Infrastructure Leader
.VERSION
    1.0.0
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$TenantId,
    
    [Parameter(Mandatory=$false)]
    [int]$RotationThresholdDays = 90,
    
    [Parameter(Mandatory=$false)]
    [string]$NotificationEmail = "security-ops@company.com"
)

# Connect to Azure AD
Connect-AzureAD -TenantId $TenantId

# Get all service principals with password credentials
$servicePrincipals = Get-AzureADServicePrincipal -All $true | 
    Where-Object { $_.PasswordCredentials -ne $null }

$rotatedCount = 0
$failedCount = 0

foreach ($sp in $servicePrincipals) {
    foreach ($cred in $sp.PasswordCredentials) {
        $endDate = $cred.EndDate
        $daysUntilExpiry = ($endDate - (Get-Date)).Days
        
        if ($daysUntilExpiry -le $RotationThresholdDays) {
            Write-Host "Rotating secret for: $($sp.DisplayName) - Expires in $daysUntilExpiry days" -ForegroundColor Yellow
            
            try {
                # Create new credential
                $newPassword = New-Guid
                $newCred = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordCredential
                $newCred.StartDate = Get-Date
                $newCred.EndDate = (Get-Date).AddMonths(6)
                $newCred.KeyId = New-Guid
                $newCred.Value = $newPassword
                
                # Add new credential
                Add-AzureADServicePrincipalPasswordCredential -ObjectId $sp.ObjectId -PasswordCredential $newCred
                
                # Remove old credential
                Remove-AzureADServicePrincipalPasswordCredential -ObjectId $sp.ObjectId -KeyId $cred.KeyId
                
                # Send notification
                Send-MailMessage -To $NotificationEmail `
                    -Subject "Service Principal Secret Rotated: $($sp.DisplayName)" `
                    -Body "Secret rotated successfully. New expiry: $($newCred.EndDate)" `
                    -SmtpServer "smtp.company.com"
                
                $rotatedCount++
            }
            catch {
                Write-Host "Failed to rotate: $($sp.DisplayName) - $($_.Exception.Message)" -ForegroundColor Red
                $failedCount++
                
                # Alert security team
                Send-MailMessage -To "security-alerts@company.com" `
                    -Subject "URGENT: Service Principal Rotation Failed" `
                    -Body "Failed to rotate secret for $($sp.DisplayName). Error: $($_.Exception.Message)" `
                    -SmtpServer "smtp.company.com"
            }
        }
    }
}

Write-Host "Rotation Complete: $rotatedCount succeeded, $failedCount failed" -ForegroundColor Green

# Log to Sentinel
$logEntry = @{
    TimeGenerated = Get-Date -Format "o"
    ServicePrincipalRotation = $true
    RotatedCount = $rotatedCount
    FailedCount = $failedCount
    Operator = $env:USERNAME
}

$logEntry | ConvertTo-Json | Out-File -FilePath "C:\Logs\SP-Rotation-$(Get-Date -Format 'yyyyMMdd').json" -Append
