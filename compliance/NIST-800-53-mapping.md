## **Compliance/NIST-800-53-mapping.md**

```markdown
# NIST 800-53 Control Mapping

## Access Control (AC)

| NIST Control | Implementation | Evidence Location |
|--------------|----------------|-------------------|
| AC-2 Account Management | PIM workflows, access reviews | `playbooks/operational/access-review-workflow.md` |
| AC-3 Access Enforcement | Conditional Access policies | `policies/conditional-access/` |
| AC-4 Information Flow Enforcement | Network policies, resource scoping | `terraform/modules/network/` |
| AC-5 Separation of Duties | Role-based access, approval workflows | `GOVERNANCE.md` |
| AC-6 Least Privilege | JIT access, time-bound privileges | `terraform/modules/pim/` |
| AC-7 Unsuccessful Login Attempts | Account lockout policies | `policies/identity-protection/` |
| AC-8 System Use Notification | Sign-in terms of use | `documentation/user-guides/` |
| AC-17 Remote Access | Conditional Access, MFA | `policies/conditional-access/ca-policy-require-mfa.json` |
| AC-19 Access Control for Mobile Devices | Intune compliance policies | `terraform/modules/intune/` |
| AC-20 Use of External Systems | Guest access policies | `policies/conditional-access/` |

## Identification & Authentication (IA)

| NIST Control | Implementation | Evidence Location |
|--------------|----------------|-------------------|
| IA-2 Identification & Authentication | Azure AD authentication | `ARCHITECTURE.md` |
| IA-3 Device Identification | Intune device compliance | `terraform/modules/intune/` |
| IA-4 Identifier Management | Lifecycle management workflows | `playbooks/operational/` |
| IA-5 Authenticator Management | MFA, certificate auth | `scripts/azure-ad/` |
| IA-6 Authentication Feedback | Custom sign-in pages | `documentation/user-guides/` |
| IA-7 Cryptographic Module Authentication | FIPS 140-2 compliant | `SECURITY.md` |
| IA-8 Identification & Authentication (Non-Local Access) | Conditional Access | `policies/conditional-access/` |
| IA-9 Service Identification | Service principal auth | `scripts/azure-ad/rotate-service-principals.ps1` |
| IA-10 Adaptive Authentication | Risk-based policies | `policies/identity-protection/risky-signin-policy.json` |
| IA-11 Re-authentication | Step-up authentication | `policies/conditional-access/` |

## Audit & Accountability (AU)

| NIST Control | Implementation | Evidence Location |
|--------------|----------------|-------------------|
| AU-2 Auditable Events | Azure AD audit logs | `monitoring/sentinel/` |
| AU-3 Content of Audit Records | Standardized log schema | `monitoring/dashboards/` |
| AU-6 Audit Review & Analysis | Sentinel workbooks | `monitoring/sentinel/workbooks/` |
| AU-7 Audit Reduction & Report Generation | Custom reports | `monitoring/dashboards/` |
| AU-8 Time Stamps | Synchronized time sources | `ARCHITECTURE.md` |
| AU-9 Protection of Audit Information | Log encryption, access controls | `SECURITY.md` |
| AU-11 Audit Record Retention | 365-day retention policy | `terraform/main.tf` |
| AU-12 Audit Generation | Automated logging | `monitoring/sentinel/analytics-rules/` |

## Security Assessment & Authorization (CA)

| NIST Control | Implementation | Evidence Location |
|--------------|----------------|-------------------|
| CA-2 Security Assessments | Quarterly penetration testing | `testing/penetration-testing/` |
| CA-6 Security Authorization | Annual architecture review | `GOVERNANCE.md` |
| CA-7 Continuous Monitoring | Sentinel real-time monitoring | `monitoring/` |

---

**Audit Readiness:** This mapping provides direct evidence links for NIST 800-53 audits. All controls have implemented technical controls with documented evidence locations.
