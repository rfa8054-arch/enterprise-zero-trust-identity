# Certification Mapping

This implementation demonstrates applied competency against
the certification domains below.

## Microsoft Cybersecurity Architect Expert (SC-100)

| Exam Domain | Implementation Evidence |
|-------------|------------------------|
| Design a Zero Trust architecture | End-to-end identity architecture, verify-explicitly controls, assume-breach monitoring |
| Design secured identity and access management | Conditional Access suite, PIM just-in-time elevation, PAM vault integration |
| Design a validated security architecture | Control-to-framework mapping, quarterly architecture review cadence in `GOVERNANCE.md` |
| Integrate security into cloud and IT operations | Pipeline-driven policy deployment, automated credential rotation, audit evidence generation |
| Drive business continuity and security governance | Risk register ownership, escalation paths, executive reporting in `BUSINESS-CASE.md` |

## Microsoft Identity & Access Administrator (SC-300)

| Exam Domain | Implementation Evidence |
|-------------|------------------------|
| Plan and configure an identity and access solution | Entra ID (Azure AD) tenant configuration, hybrid connectivity assumptions |
| Implement governance for identity and access | Access review workflow, eligible vs. active role assignment, approval requirements |
| Implement and configure hybrid identities | Azure AD Connect sync considerations, cloud-only vs hybrid policy exclusions |
| Implement and monitor authentication and authorization | MFA enforcement, compliant-device gating, risk-based step-up authentication |
| Plan and implement an authorization strategy | Directory role scoping, resource-level role assignment, service principal permissions |

## Certified in Cybersecurity — ISC² (CC)

| Domain | Implementation Evidence |
|--------|------------------------|
| Security principles | Least privilege, defense in depth, separation of duties |
| Business continuity | Access preservation during incident containment, recovery procedures |
| Access controls | RBAC, mandatory access via Conditional Access, PAM-controlled privileged access |
| Network security | Trusted location definitions, country blocking, legacy protocol denial |
| Security operations | Sentinel analytics, alerting thresholds, incident playbooks |

## CyberArk PAM Administration

| Competency | Implementation Evidence |
|-----------|------------------------|
| Vault integration and credential retrieval | `scripts/cyberark/vault-integration.ps1`, `credential-retrieval.ps1` |
| Credential lifecycle | Automated rotation cadence, compromised-account marking in incident playbook |
| Policy enforcement | Just-in-time access gated by vault approval workflow |

## Kron PAM Expert

| Competency | Implementation Evidence |
|-----------|------------------------|
| Session management and recording | `scripts/kron/session-recording.ps1`, session termination in containment step |
| PAM connector integration | `scripts/kron/pam-connector.ps1` |

## Azure AI Engineer Associate (AI-102)

| Competency | Implementation Evidence |
|-----------|------------------------|
| Anomaly detection applied to security telemetry | ML-assisted sign-in anomaly scoring feeding Sentinel analytics |
| Automation of analyst workflow | Playbook-driven classification and prioritization |

## Teams Administrator Associate (MS-700)

| Competency | Implementation Evidence |
|-----------|------------------------|
| Governance and lifecycle | Guest access review aligned to identity governance, retention and sensitivity labeling |
| Security controls in collaboration workloads | Conditional Access applied to Teams clients, access review coverage |

## NetApp Certified Data Administrator (NCDA)

| Competency | Implementation Evidence |
|-----------|------------------------|
| Storage security and data protection | Immutability and recovery considerations referenced in the data protection design |

---
