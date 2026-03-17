# STRIDE

**Kategorien:** security | **Rollen:** reviewer, architect, devops | **Tier:** 3
**Referenz:** Microsoft — Loren Kohnfelder & Praerit Garg (1999), Adam Shostack — *Threat Modeling* (2014)

## Core Concepts

| Buchstabe | Bedrohung | Mitigation |
|-----------|-----------|------------|
| **S** — Spoofing | Identitätsfälschung | Authentifizierung, Zertifikate |
| **T** — Tampering | Unautorisierte Datenmodifikation | Integritätsprüfungen, Signaturen |
| **R** — Repudiation | Aktionen abstreiten | Audit-Logs, digitale Signaturen |
| **I** — Information Disclosure | Datenleck | Verschlüsselung, Access Control |
| **D** — Denial of Service | Verfügbarkeit unterbrechen | Rate Limiting, Redundanz |
| **E** — Elevation of Privilege | Unautorisierte Berechtigungserweiterung | Least Privilege, Sandboxing |

## Wann einsetzen

- Threat Modeling für neue Features oder Architekturen
- Security Review vor dem Deployment
- Systematische Schwachstellenanalyse von Systemkomponenten

## Prompt Pattern

```
Führe eine STRIDE-Analyse für folgende Komponente durch:
[Komponente / Architektur / Datenfluss]

Für jede Bedrohungskategorie: Risiko bewerten + Mitigation vorschlagen.
```
