# Anchors: Reviewer

> Lade diese Datei wenn du als Reviewer-Agent arbeitest und Security/Qualitätsmethodiken benötigst.

---

## OWASP Top 10
**Kategorien:** testing-quality, security | **Rollen:** reviewer, developer, architect, devops | **Tier:** 3
**Referenz:** OWASP Foundation — https://owasp.org/Top10/ (aktuell: 2021)

### Core Concepts

| Rang | Risiko | Kern-Mitigation |
|------|--------|-----------------|
| **A01** | Broken Access Control | Zugriffsrechte serverseitig erzwingen, Least Privilege |
| **A02** | Cryptographic Failures | Starke Verschlüsselung für Daten at-rest und in-transit |
| **A03** | Injection | Prepared Statements, Input-Validierung, Parameterized Queries |
| **A04** | Insecure Design | Threat Modeling, Security Requirements, Secure Design Patterns |
| **A05** | Security Misconfiguration | Hardening, sichere Defaults, keine Default-Credentials |
| **A06** | Vulnerable & Outdated Components | Dependency-Scanning, regelmäßige Updates, SCA-Tools |
| **A07** | Auth & Authentication Failures | MFA, sichere Session-Verwaltung, starke Passwort-Policy |
| **A08** | Software & Data Integrity Failures | Code-Signing, CI/CD-Sicherheit, Dependency Integrity |
| **A09** | Security Logging & Monitoring Failures | Zentrales Logging, Alerting, Audit Trails |
| **A10** | Server-Side Request Forgery (SSRF) | URL-Validierung, Allowlists für externe Requests |

### Wann einsetzen

- Code Review: systematisch auf Security-Lücken prüfen
- Security Risk Assessments für Web-Applikationen
- Threat Modeling und Security Design Reviews
- Prioritisierung von Security Findings

### Prompt Pattern

```
Prüfe diesen Code auf OWASP Top 10 Schwachstellen:
[Code]

Fokus auf: [A01-A10 oder alle]
```

---

## STRIDE
**Kategorien:** security | **Rollen:** reviewer, architect, devops | **Tier:** 3
**Referenz:** Microsoft — Loren Kohnfelder & Praerit Garg (1999), Adam Shostack — *Threat Modeling* (2014)

### Core Concepts

| Buchstabe | Bedrohung | Mitigation |
|-----------|-----------|------------|
| **S** — Spoofing | Identitätsfälschung / Impersonation | Authentifizierung, Zertifikate |
| **T** — Tampering | Unautorisierte Datenmodifikation | Integritätsprüfungen, Signaturen, HMAC |
| **R** — Repudiation | Aktionen abstreiten können | Audit-Logs, digitale Signaturen |
| **I** — Information Disclosure | Datenleck / unberechtigte Dateneinsicht | Verschlüsselung, Access Control |
| **D** — Denial of Service | Verfügbarkeit unterbrechen | Rate Limiting, Redundanz, Auto-Scaling |
| **E** — Elevation of Privilege | Unautorisierte Berechtigungserweiterung | Least Privilege, Sandboxing |

### Wann einsetzen

- Threat Modeling für neue Features oder Architekturen
- Security Review vor dem Deployment
- Red Teaming und Penetration Test Planung
- Systematische Schwachstellenanalyse von Systemkomponenten

### Prompt Pattern

```
Führe eine STRIDE-Analyse für folgende Komponente durch:
[Komponente / Architektur / Datenfluss]

Für jede Bedrohungskategorie: Risiko bewerten + Mitigation vorschlagen.
```

---

## Devil's Advocate
**Kategorien:** problem-solving | **Rollen:** reviewer, architect, team-lead | **Tier:** 3
*Auch bekannt als: Advocatus Diaboli, Red Teaming*
**Referenz:** Katholische Kirche (Promotor Fidei, formalisiert 1587), in Software: Critical Thinking, Pre-Mortem

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Systematic Counter-Argumentation** | Gegenpositionen einnehmen auch wenn man sie nicht persönlich vertritt |
| **Assumption Challenging** | Prämissen hinterfragen, versteckte Annahmen aufdecken |
| **Steelmanning** | Das stärkste Argument für die Gegenposition formulieren — kein Strohmann |
| **Pre-Mortem Thinking** | Szenarien des Scheiterns imaginieren bevor etwas passiert |
| **Dialectical Reasoning** | These + Antithese → Synthese |
| **Intellectual Honesty** | Idee von Ego trennen — Kritik an der Idee ist kein persönlicher Angriff |
| **Risk Identification** | Probleme proaktiv benennen bevor sie auftreten |

### Wann einsetzen

- Kritische Architektur- oder Design-Entscheidungen mit hohem Fehlerpreis
- Security Threat Modeling (Red Teaming)
- Code Reviews: Annahmen im Code challengen
- Jede hochriskante Entscheidung wo Irrtum teuer ist

### Prompt Pattern

```
Ich schlage vor: [Idee / Design / Entscheidung].
Spiele Devil's Advocate: Was sind die stärksten Argumente GEGEN diesen Ansatz?
Steelmann die Gegenposition.
```

---

## Secure by Design
**Kategorien:** security, software-architecture | **Rollen:** reviewer, architect | **Tier:** 2
**Referenz:** NIST SP 800-160, OWASP Secure Design Principles

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Least Privilege** | Jede Komponente bekommt nur die Rechte die sie braucht |
| **Defense in Depth** | Mehrschichtige Sicherheit — kein Single Point of Failure |
| **Fail Secure** | Bei Fehler in sicheren Zustand fallen, nicht in unsicheren |
| **Threat Modeling** | Bedrohungen systematisch identifizieren bevor Code geschrieben wird |
| **Zero Trust (Networking)** | Kein implizites Vertrauen durch Netzwerklage — immer verifizieren |
| **Separation of Concerns** | Security-Logik von Business-Logik trennen |
| **Input Validation** | Alle externen Inputs als potenziell bösartig behandeln |

### Wann einsetzen

- Architektur-Reviews auf Security-Implikationen
- Design neuer Features mit sensitiven Daten
- Infrastructure und API-Design
- Überprüfung von Authentication/Authorization-Konzepten
