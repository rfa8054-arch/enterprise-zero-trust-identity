
---

## **ARCHITECTURE.md**

```markdown
# Architecture Decision Records

## ADR-001: Azure AD (Entra ID) as Primary Identity Provider

**Status:** Accepted  
**Date:** 2026-03-15

### Context
Enterprise requires unified identity management across cloud and on-premises resources.

### Decision
Use Azure AD as primary IdP with hybrid connectivity to on-prem AD.

### Consequences
- ✅ Single sign-on across all applications
- ✅ Unified conditional access policies
- ⚠️ Requires Azure AD Connect synchronization
- ⚠️ Licensing costs for P1/P2 features

---

## ADR-002: CyberArk + Kron PAM Integration

**Status:** Accepted  
**Date:** 2026-03-20

### Context
Privileged accounts require vault storage, session recording, and JIT access.

### Decision
Deploy CyberArk for credential vaulting, Kron for session management.

### Consequences
- ✅ Centralized privileged credential management
- ✅ Full session audit trail
- ⚠️ Two PAM systems require integration effort
- ⚠️ Additional licensing costs

---

## ADR-003: Terraform for Identity Infrastructure

**Status:** Accepted  
**Date:** 2026-04-01

### Context
Identity configurations need version control, repeatability, and drift detection.

### Decision
Use Terraform with Azure AD provider for all identity infrastructure.

### Consequences
- ✅ Infrastructure as Code benefits
- ✅ Environment parity (dev/staging/prod)
- ⚠️ Terraform state file security critical
- ⚠️ Learning curve for operations team
