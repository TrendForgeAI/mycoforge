# Secure by Design

**Kategorien:** security, software-architecture | **Rollen:** reviewer, architect | **Tier:** 2
**Referenz:** NIST SP 800-160, OWASP Secure Design Principles

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Least Privilege** | Jede Komponente bekommt nur die Rechte die sie braucht |
| **Defense in Depth** | Mehrschichtige Sicherheit — kein Single Point of Failure |
| **Fail Secure** | Bei Fehler in sicheren Zustand fallen, nicht in unsicheren |
| **Threat Modeling** | Bedrohungen systematisch identifizieren bevor Code geschrieben wird |
| **Zero Trust** | Kein implizites Vertrauen durch Netzwerklage — immer verifizieren |
| **Separation of Concerns** | Security-Logik von Business-Logik trennen |
| **Input Validation** | Alle externen Inputs als potenziell bösartig behandeln |

## Wann einsetzen

- Architektur-Reviews auf Security-Implikationen
- Design neuer Features mit sensitiven Daten
- Infrastructure und API-Design
- Überprüfung von Authentication/Authorization-Konzepten
