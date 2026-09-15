# Governance Model

## Decision Rights (RACI)

| Decision | Accountable | Responsible | Consulted | Informed |
|----------|------------|-------------|-----------|----------|
| Conditional Access policy change | CISO | Identity Engineer | App Owners, Helpdesk | All Users |
| PIM role activation approval | Security Lead | Approver Group | Identity Engineer | SOC |
| Service principal secret rotation | Infrastructure Lead | Automation Pipeline | App Owners | SOC |
| Break-glass account usage | CISO | SOC Manager | Legal, HR | Executive Team |
| Access review sign-off | Data Owner | Identity Engineer | Line Manager | Audit |

## Approval Workflows

### Conditional Access Change
1. Engineer drafts policy in JSON, submits pull request
2. Peer review required — no self-approval
3. Test tenant validation with report-only mode
4. CISO sign-off recorded in pull request
5. Deploy in report-only for 7 days, then enforce

### Emergency / Break-Glass Access
1. Two-person rule for activation
2. Immediate alert to SOC, CISO, and Sentinel
3. Session recorded end to end
4. Post-use review within 24 hours
5. Credential rotation after every use

## Review Cadence

| Activity | Frequency | Owner |
|----------|-----------|-------|
| Access review attestation | Quarterly | Data Owners |
| Conditional Access policy tuning | Monthly | Identity Engineer |
| Service principal inventory and rotation | Monthly | Automation |
| Incident response drill | Quarterly | SOC Manager |
| Full architecture review | Annually | CISO |

## Change Control

Policy definitions live in source control. Enforcement
through the Azure portal outside the pipeline is treated
as configuration drift and is alerted on.
