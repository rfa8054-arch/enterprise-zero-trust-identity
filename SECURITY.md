# Security Policy

## Scope

This repository documents an identity security reference
architecture. It contains no production secrets, tenant
identifiers, or customer data.

## Reporting a Vulnerability

If you identify a security weakness in the architecture,
policies, or automation logic, please report it privately.

- Open a private security advisory via the **Security** tab
  of this repository.
- Do not open a public issue for security findings.

## Response Commitment

- Acknowledgement: 3 business days
- Assessment and remediation plan: 15 business days

## Out of Scope

Findings relating to placeholder values intentionally
substituted for production identifiers.

## Standing Assumption

This is a reference implementation. Validate every policy
in a non-production tenant before applying it to a live
directory — Conditional Access misconfiguration can lock
out administrative access.
