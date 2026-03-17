# OWASP Top 10

**Kategorien:** security, testing-quality | **Rollen:** reviewer, developer, architect, devops | **Tier:** 3
**Referenz:** OWASP Foundation — https://owasp.org/Top10/ (aktuell: 2021)

## Core Concepts

| Rang | Risiko | Kern-Mitigation |
|------|--------|-----------------|
| **A01** | Broken Access Control | Zugriffsrechte serverseitig erzwingen, Least Privilege |
| **A02** | Cryptographic Failures | Starke Verschlüsselung für Daten at-rest und in-transit |
| **A03** | Injection | Prepared Statements, Input-Validierung, Parameterized Queries |
| **A04** | Insecure Design | Threat Modeling, Security Requirements, Secure Design Patterns |
| **A05** | Security Misconfiguration | Hardening, sichere Defaults, keine Default-Credentials |
| **A06** | Vulnerable & Outdated Components | Dependency-Scanning, regelmäßige Updates |
| **A07** | Auth & Authentication Failures | MFA, sichere Session-Verwaltung |
| **A08** | Software & Data Integrity Failures | Code-Signing, CI/CD-Sicherheit |
| **A09** | Security Logging & Monitoring Failures | Zentrales Logging, Alerting, Audit Trails |
| **A10** | Server-Side Request Forgery (SSRF) | URL-Validierung, Allowlists für externe Requests |

## Wann einsetzen

- Code Review: systematisch auf Security-Lücken prüfen
- Security Risk Assessments für Web-Applikationen
- Threat Modeling und Security Design Reviews

## Prompt Pattern

```
Prüfe diesen Code auf OWASP Top 10 Schwachstellen:
[Code]

Fokus auf: [A01-A10 oder alle]
```
