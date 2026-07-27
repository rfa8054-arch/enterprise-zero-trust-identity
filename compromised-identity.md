# Incident Response Playbook: Compromised Identity

**Classification:** CRITICAL  
**Response Time:** < 30 minutes  
**Owner:** Security Operations Center

---

## 🚨 Detection Triggers

- Impossible travel sign-in detected
- Anonymous IP address sign-in
- Multiple failed authentication attempts
- Privileged account activity outside business hours
- Service principal anomalous usage

---

## 🔧 Immediate Containment (0-15 minutes)

### Step 1: Confirm Compromise
```powershell
# Check recent sign-ins
Get-AzureADUserSignInLogs -UserId <userPrincipalName> -Top 50

# Check risky sign-ins
Get-AzureADRiskySignIn -UserId <userObjectId>

### Step 2: Block Access

# Revoke all sessions
Revoke-AzureADUserAllRefreshToken -ObjectId <userObjectId>

# Disable account temporarily
Update-AzureADUser -ObjectId <userObjectId> -AccountEnabled $false

# Reset password
Set-AzureADUserPassword -ObjectId <userObjectId> -Password (ConvertTo-SecureString -String (New-Guid) -AsPlainText -Force) -ForceChangePasswordNextLogin $true

### Step 3: PAM Credential Revocation

# CyberArk: Mark credentials as compromised
Invoke-RestMethod -Uri "https://vault.cyberark.com/api/Accounts/<accountId>/MarkCompromised" `
    -Method POST `
    -Headers @{Authorization="Bearer $token"}

# Kron: Terminate active sessions
Invoke-KronSessionTerminate -UserId <userId>


Investigation (15-60 minutes)
Evidence Collection

Export sign-in logs (last 30 days)
Export audit logs for privileged actions
Capture PAM session recordings
Document all affected resources
Preserve forensic artifacts


Impact Assessment

List all accessed resources
Identify data exposure risk
Check for lateral movement
Review service principal usage

Assess compliance implications

🛠️ Recovery (1-4 hours)
Step 1: Identity Restoration
Verify user identity through secondary authentication
Reset credentials in CyberArk vault
Re-enable account with enhanced monitoring

Issue new MFA registration
Step 2: Access Review

Review all group memberships
Audit application assignments
Validate PIM role assignments
Remove unnecessary privileges

Step 3: Enhanced Monitoring
Add to high-risk user watchlist
Enable additional Sentinel analytics rules
Schedule daily access reviews for 30 days

Configure real-time alerting for this identity
📊 Post-Incident (24-48 hours)
Documentation

Complete incident report
Update threat intelligence database
Review and update playbooks
Conduct lessons learned session


Metrics to Capture
|      Metric     |      Target     |     Actual    |

| Time to Detect  |    < 15 min     |               |
| Time to Contain |    < 30 min     |               |
| Time to Recover |    < 4 hours    |               |
| Data Exposed    | 0 bytes         |               |



 Escalation Contacts
|        Role     |   Name   | Contact |

|      SOC Lead   |  [Name]  | soc-lead@company.com |
| Identity Admin  | [Name]   | identity-admin@company.com |
|        CISO     | [Name]   | ciso@company.com |
|        Legal    | [Name]    legal@company.com |
