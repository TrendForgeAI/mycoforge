# ForgeOS Phase 1 Bootstrap — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bootstrap ForgeOS at `/docker/forgeos/` — from empty directory to committed GitHub repo and built Docker image, ready for Phase 2 (Claude login + Superpowers setup inside the container).

**Architecture:** All infrastructure files are baked into a `node:24-slim` Docker image via `COPY . /forgeos/`. The `claude/` directory (commands, agents, settings) is bind-mounted from the host so it can be edited live without rebuilding. Named volumes handle workspace, runtime, and the future SQLite memory DB.

**Tech Stack:** Docker, docker-compose v2, node:24-slim, Claude Code (`@anthropic-ai/claude-code`), GitHub CLI (`gh`), bash

---

## Environment

All commands run on the **HOST** in `/docker/forgeos/` unless noted otherwise.

```bash
cd /docker/forgeos
```

The directory already exists and is empty. `/docker/mycoforge/.env` exists and will be used as the source for secret values.

---

## File Map

| File | Task | Responsibility |
|------|------|---------------|
| `.env.example` | 2 | Documents all required env vars |
| `.env` | 2 | Runtime secrets — never in git |
| `.gitignore` | 2 | Excludes secrets, volumes, session data |
| `Dockerfile` | 3 | Image definition — node:24-slim, symlink before COPY |
| `docker-compose.yml` | 4 | Hybrid volumes, bind mount for `./claude` |
| `entrypoint.sh` | 5 | Container init — git, gh, providers, MEMORY.md |
| `start-claude.sh` | 6 | Host shortcut: docker exec -it forgeos claude |
| `shell.sh` | 6 | Host shortcut: docker exec -it forgeos bash |
| `update.sh` | 6 | git pull → build → restart |
| `setup.sh` | 6 | First-time host install (no auth login) |
| `CLAUDE.md` | 7 | ForgeOS project context for Claude Code |
| `ARCHITECTURE.md` | 8 | System thinking, agent patterns, memory, plugins |
| `README.md` | 9 | Human-readable intro, install, usage |
| `claude/settings.json` | 10 | Max permissions, no confirmation dialogs |
| `claude/commands/` | 10 | Empty placeholder (Phase 2) |
| `claude/agents/` | 10 | Empty placeholder (Phase 2) |
| `memory/markdown/system/` | 10 | System-level memory (Phase 2) |
| `memory/markdown/projects/forgeos/` | 10 | ForgeOS Project #0 memory (Phase 2) |
| All other dirs | 10 | `.gitkeep` placeholders |
| `SETUP-CONTINUE.md` | 11 | Phase 2 instructions for Claude Code in container |

---

## Task 1: Git Init

**Files:**
- Create: `/docker/forgeos/.git/` (via git init)

- [ ] **Step 1: Initialize git repository**

```bash
cd /docker/forgeos
git init
git config user.name "TrendForgeAI"
git config user.email "trendforge.ai@gmail.com"
```

Expected: `Initialized empty Git repository in /docker/forgeos/.git/`

---

## Task 2: Environment Files + .gitignore

**Files:**
- Create: `/docker/forgeos/.env.example`
- Create: `/docker/forgeos/.env`
- Create: `/docker/forgeos/.gitignore`

- [ ] **Step 1: Create .env.example**

```
# === Required ===
GH_TOKEN=                     # GitHub PAT (repo, workflow, read:org)
GH_ORG=TrendForgeAI           # GitHub User/Org
GIT_USER_NAME=                # Git commit author
GIT_USER_EMAIL=               # Git commit email

# === AI Providers (mindestens einer) ===
ANTHROPIC_API_KEY=            # Claude API (optional wenn Pro Plan)
OPENAI_API_KEY=               # OpenAI (optional)
GEMINI_API_KEY=               # Google Gemini (optional)
XAI_API_KEY=                  # xAI Grok (optional)

# === ForgeOS Config ===
TZ=Europe/Berlin
DEBUG_MODE=on                 # on = Agent/Modell-Info pro Antwort
FORGEOS_AUTO_COMMIT=on        # on = Memory-Dateien regelmäßig committen
SWARM_MAX_ITERATIONS=3        # Max Iterationen pro /explore

# === Optional ===
CLOUDFLARE_TUNNEL_TOKEN=      # Für Remote-Zugriff via Web-UI
```

Write this to `/docker/forgeos/.env.example`.

- [ ] **Step 2: Create .env from mycoforge source**

Copy the existing secrets from mycoforge and adapt:

```bash
cp /docker/mycoforge/.env /docker/forgeos/.env
```

Then open `/docker/forgeos/.env` and make these changes:
- Remove the line `PORT=3000` (not used in ForgeOS)
- Add `FORGEOS_AUTO_COMMIT=on` after DEBUG_MODE
- Add `SWARM_MAX_ITERATIONS=3` after FORGEOS_AUTO_COMMIT

The result should have all mycoforge API keys intact, with these ForgeOS-specific additions.

- [ ] **Step 3: Create .gitignore**

Write to `/docker/forgeos/.gitignore`:

```
.env
.env.local
claude/.claude.json
claude/.credentials.json
claude/.statsig/
claude/statsig/
claude/debug/
claude/file-history/
claude/tasks/
claude/todos/
claude/stats-cache.json
claude/history.jsonl
*.sqlite
*.sqlite-journal
node_modules/
workspace/
runtime/
memory/db/
*.log
.DS_Store
Thumbs.db
```

- [ ] **Step 4: Verify .gitignore covers secrets**

```bash
cd /docker/forgeos
git check-ignore -v .env
```

Expected: `.gitignore:1:.env    .env`

- [ ] **Step 5: Commit**

```bash
cd /docker/forgeos
git add .env.example .gitignore
git commit -m "chore: add env example and gitignore"
```

Note: `.env` is intentionally NOT staged (it's gitignored).

---

## Task 3: Dockerfile

**Files:**
- Create: `/docker/forgeos/Dockerfile`

**Critical:** `RUN ln -s /forgeos/claude /root/.claude` MUST appear before `COPY . /forgeos/`. If COPY runs first, it creates `/forgeos/claude` as a real directory, and the subsequent `ln -s` fails with "File exists".

- [ ] **Step 1: Create Dockerfile**

Write to `/docker/forgeos/Dockerfile`:

```dockerfile
# ForgeOS – Self-improving AI Development Environment
FROM node:24-slim

LABEL org.opencontainers.image.title="forgeos"
LABEL org.opencontainers.image.description="A self-improving AI development environment"
LABEL org.opencontainers.image.source="https://github.com/TrendForgeAI/forgeos"

# System-Dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    ca-certificates \
    nano \
    jq \
    sqlite3 \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Claude Code
RUN npm install -g @anthropic-ai/claude-code

# GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install -y gh && rm -rf /var/lib/apt/lists/*

# Claude Code Config-Symlink (MUST be before COPY)
RUN ln -s /forgeos/claude /root/.claude

# Umgebung
ENV TZ=Europe/Berlin
ENV NODE_ENV=production

# ForgeOS ins Image
COPY . /forgeos/
WORKDIR /forgeos

RUN chmod +x /forgeos/entrypoint.sh \
    && chmod +x /forgeos/start-claude.sh \
    && chmod +x /forgeos/shell.sh \
    && chmod +x /forgeos/update.sh \
    && chmod +x /forgeos/setup.sh

ENTRYPOINT ["/forgeos/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]
```

- [ ] **Step 2: Verify symlink is before COPY**

```bash
grep -n "ln -s\|^COPY" /docker/forgeos/Dockerfile
```

Expected output (ln -s line number must be LOWER than COPY line number):
```
21: RUN ln -s /forgeos/claude /root/.claude
26: COPY . /forgeos/
```

- [ ] **Step 3: Commit**

```bash
cd /docker/forgeos
git add Dockerfile
git commit -m "feat: add Dockerfile (node:24-slim, symlink-before-copy)"
```

---

## Task 4: docker-compose.yml

**Files:**
- Create: `/docker/forgeos/docker-compose.yml`

**Critical:** `./claude` is a bind mount (not a named volume). This allows live editing of commands, agents, and settings without rebuilding the image.

- [ ] **Step 1: Create docker-compose.yml**

Write to `/docker/forgeos/docker-compose.yml`:

```yaml
services:
  forgeos:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: forgeos
    env_file:
      - path: .env
        required: false
    volumes:
      - ./claude:/forgeos/claude
      - forgeos_workspace:/workspace
      - forgeos_runtime:/forgeos/runtime
      - forgeos_memory_db:/forgeos/memory/db
    networks:
      - forgeos_network
    restart: unless-stopped
    stdin_open: true
    tty: true

volumes:
  forgeos_workspace:
  forgeos_runtime:
  forgeos_memory_db:

networks:
  forgeos_network:
    driver: bridge
```

- [ ] **Step 2: Verify bind mount is correct**

```bash
grep "claude" /docker/forgeos/docker-compose.yml
```

Expected: `      - ./claude:/forgeos/claude` (NOT `forgeos_claude:`)

- [ ] **Step 3: Validate YAML syntax**

```bash
cd /docker/forgeos
docker compose config --quiet 2>&1 | head -5 || echo "Syntax check done"
```

This may warn about missing .env values but must not show YAML parse errors.

- [ ] **Step 4: Commit**

```bash
cd /docker/forgeos
git add docker-compose.yml
git commit -m "feat: add docker-compose.yml (hybrid volume strategy)"
```

---

## Task 5: entrypoint.sh

**Files:**
- Create: `/docker/forgeos/entrypoint.sh`

The entrypoint runs 7 steps then calls `exec "$@"` to hand off to CMD (`tail -f /dev/null`).

- [ ] **Step 1: Create entrypoint.sh**

Write to `/docker/forgeos/entrypoint.sh`:

```bash
#!/bin/bash
set -e

echo "🔧 ForgeOS starting..."

# === 1. Git Identity ===
if [ -n "$GIT_USER_NAME" ]; then
  git config --global user.name "$GIT_USER_NAME"
fi
if [ -n "$GIT_USER_EMAIL" ]; then
  git config --global user.email "$GIT_USER_EMAIL"
fi

# === 2. GitHub Auth ===
if [ -n "$GH_TOKEN" ]; then
  echo "$GH_TOKEN" | gh auth login --with-token 2>/dev/null || true
fi

# === 3. Git HTTPS Credential Rewrite ===
if [ -n "$GH_TOKEN" ]; then
  git config --global url."https://${GH_TOKEN}@github.com/".insteadOf "https://github.com/"
fi

# === 4. Provider Detection ===
PROVIDERS=""
if [ -n "$ANTHROPIC_API_KEY" ]; then PROVIDERS="${PROVIDERS}anthropic,"; fi
if [ -f "/forgeos/claude/.credentials.json" ]; then PROVIDERS="${PROVIDERS}anthropic-pro,"; fi
if [ -n "$OPENAI_API_KEY" ]; then PROVIDERS="${PROVIDERS}openai,"; fi
if [ -n "$GEMINI_API_KEY" ]; then PROVIDERS="${PROVIDERS}gemini,"; fi
if [ -n "$XAI_API_KEY" ]; then PROVIDERS="${PROVIDERS}xai,"; fi
PROVIDERS=${PROVIDERS%,}

# === 5. Ensure Runtime Directories ===
mkdir -p \
  /forgeos/runtime/traces \
  /forgeos/runtime/state \
  /workspace \
  /forgeos/memory/db \
  /forgeos/memory/markdown/system \
  /forgeos/memory/markdown/projects

# === 6. Generate MEMORY.md ===
PROJECTS=$(ls /workspace/ 2>/dev/null | head -20 || echo "Keine Projekte")

cat > /forgeos/MEMORY.md << MEMORY_EOF
# ForgeOS System Memory
Generated: $(date -Iseconds)

## Verfügbare Provider
${PROVIDERS:-"Keine Provider konfiguriert"}

## Konfiguration
DEBUG_MODE: ${DEBUG_MODE:-off}
FORGEOS_AUTO_COMMIT: ${FORGEOS_AUTO_COMMIT:-off}
SWARM_MAX_ITERATIONS: ${SWARM_MAX_ITERATIONS:-3}

## Aktive Projekte
${PROJECTS}
MEMORY_EOF

echo "✅ ForgeOS ready."
echo "   Providers: ${PROVIDERS:-none}"
echo "   Connect:   docker exec -it forgeos claude"

# === 7. Hand off to CMD ===
exec "$@"
```

- [ ] **Step 2: Verify bash syntax**

```bash
bash -n /docker/forgeos/entrypoint.sh && echo "Syntax OK"
```

Expected: `Syntax OK`

- [ ] **Step 3: Verify exec "$@" is present**

```bash
grep 'exec "\$@"' /docker/forgeos/entrypoint.sh
```

Expected: `exec "$@"`

- [ ] **Step 4: Commit**

```bash
cd /docker/forgeos
git add entrypoint.sh
git commit -m "feat: add entrypoint.sh (7 init steps, exec handoff)"
```

---

## Task 6: Helper Scripts

**Files:**
- Create: `/docker/forgeos/start-claude.sh`
- Create: `/docker/forgeos/shell.sh`
- Create: `/docker/forgeos/update.sh`
- Create: `/docker/forgeos/setup.sh`

- [ ] **Step 1: Create start-claude.sh**

Write to `/docker/forgeos/start-claude.sh`:

```bash
#!/bin/bash
# Startet Claude Code im laufenden ForgeOS-Container

if ! docker ps --format '{{.Names}}' | grep -q '^forgeos$'; then
    echo "❌ ForgeOS läuft nicht. Starte mit: docker compose up -d"
    exit 1
fi

docker exec -it forgeos claude
```

- [ ] **Step 2: Create shell.sh**

Write to `/docker/forgeos/shell.sh`:

```bash
#!/bin/bash
# Shell in den laufenden ForgeOS-Container

if ! docker ps --format '{{.Names}}' | grep -q '^forgeos$'; then
    echo "❌ ForgeOS läuft nicht. Starte mit: docker compose up -d"
    exit 1
fi

docker exec -it forgeos bash
```

- [ ] **Step 3: Create update.sh**

Write to `/docker/forgeos/update.sh`:

```bash
#!/bin/bash
# ForgeOS updaten: git pull → rebuild → restart
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "📦 Pulling latest changes..."
git pull

echo "🔨 Rebuilding..."
docker compose build

echo "🔄 Restarting..."
docker compose down
docker compose up -d

echo "✅ ForgeOS updated and running."
```

- [ ] **Step 4: Create setup.sh**

`setup.sh` is the HOST-ONLY first-time installer. It does NOT run `claude auth login` — that is Phase 2 (first step inside the running container, documented in SETUP-CONTINUE.md).

Write to `/docker/forgeos/setup.sh`:

```bash
#!/bin/bash
# Einmalige Erstinstallation von ForgeOS auf dem Host
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "⚙️  ForgeOS Setup"
echo "================"

# .env prüfen
if [ ! -f .env ]; then
    echo "📋 Erstelle .env aus .env.example..."
    cp .env.example .env
    echo ""
    echo "⚠️  Bitte .env mit deinen API-Keys befüllen:"
    echo "   nano .env"
    echo ""
    echo "Dann erneut ausführen: ./setup.sh"
    exit 1
fi

# Docker Build
echo "🔨 Baue Docker-Image..."
docker compose build

# Container starten
echo "🚀 Starte ForgeOS-Container..."
docker compose up -d

echo ""
echo "✅ ForgeOS läuft!"
echo ""
echo "Nächste Schritte:"
echo "  ./start-claude.sh     → Claude Code starten (Phase 2 beginnt hier)"
echo "  ./shell.sh            → Shell im Container"
echo "  ./update.sh           → ForgeOS aktualisieren"
echo ""
echo "Phase 2: Im Container SETUP-CONTINUE.md lesen und abarbeiten."
echo "  Erster Schritt: claude auth login (einmaliger Browser-Login)"
```

- [ ] **Step 5: Verify all scripts have correct syntax**

```bash
for f in start-claude.sh shell.sh update.sh setup.sh; do
  bash -n /docker/forgeos/$f && echo "$f: OK"
done
```

Expected:
```
start-claude.sh: OK
shell.sh: OK
update.sh: OK
setup.sh: OK
```

- [ ] **Step 6: Commit**

```bash
cd /docker/forgeos
git add start-claude.sh shell.sh update.sh setup.sh
git commit -m "feat: add helper scripts (start-claude, shell, update, setup)"
```

---

## Task 7: CLAUDE.md

**Files:**
- Create: `/docker/forgeos/CLAUDE.md`

This is the most important file — Claude Code reads it at session start for full project context.

- [ ] **Step 1: Create CLAUDE.md**

Write to `/docker/forgeos/CLAUDE.md`:

````markdown
# ForgeOS

Eine selbst-verbessernde, containerisierte KI-Entwicklungsumgebung.

## Was ist ForgeOS?

ForgeOS ist eine containerisierte KI-Entwicklungsumgebung auf einem Ubuntu VPS.
Sie wird genutzt um Projekte zu entwickeln – und kann sich dabei selbst weiterentwickeln.
ForgeOS ist die Werkstatt. Die Projekte die darin entstehen sind die Werkstücke.
ForgeOS selbst ist **Projekt #0** und verbessert sich kontinuierlich selbst.

## Wichtige Pfade

- **Im Container:** `/forgeos/` (dieses Projekt), `/workspace/` (Projekte)
- **Auf dem Host:** `/docker/forgeos/`
- **GitHub:** https://github.com/TrendForgeAI/forgeos (private)

## Namenskonventionen

| Bereich | Regel | Beispiel |
|---------|-------|---------|
| Dateinamen | Englisch, `lowercase-kebab-case` | `finish-branch.md`, `cc-pre-bash.sh` |
| Verzeichnisnamen | Englisch, `lowercase-kebab-case` | `skills/git-workflow/`, `claude/agents/` |
| Inhalte (Agent-Rollen, Skill-Trigger, Commands) | Deutsch | „Wenn ein Branch abgeschlossen wird…" |
| Inhalte (Code, technische Namen, knowledge/anchors) | Englisch | `SOLID`, `ReAct`, `kebab-case` |
| Skill-Dir-Name | = Command-Name wenn Pendant existiert | `finish-branch/` ↔ `/finish-branch` |
| Skill-Dir-Name | Konzept-Name wenn kein Command | `planning/`, `council/`, `model-routing/` |

## Projektstruktur

```
forgeos/
├── CLAUDE.md              ← Projektkontext (dieser File)
├── ARCHITECTURE.md        ← Systemdenken & Agent-Patterns
├── MEMORY.md              ← Systemgedächtnis (wird beim Start generiert, nicht in Git)
├── README.md              ← für Menschen
├── TODO.md                ← Arbeitsplan & offene Punkte
├── Dockerfile             ← Container-Definition (node:24-slim)
├── docker-compose.yml     ← Hybrid-Volume-Deployment
├── entrypoint.sh          ← Container-Initialisierung
├── start-claude.sh        ← Claude Code starten (vom Host)
├── shell.sh               ← Shell im Container (vom Host)
├── update.sh              ← Update-Workflow
├── setup.sh               ← Erstinstallation (Host)
├── SETUP-CONTINUE.md      ← Phase-2-Anleitung (im Container lesen)
├── .env                   ← Secrets (nie in Git)
├── .env.example           ← Dokumentation der benötigten Variablen
├── apps/                  ← Web-UI, Bot (geplant)
├── claude/                ← Claude Code Konfiguration (Bind-Mount vom Host)
│   ├── commands/          ← Slash Commands (Phase 2)
│   ├── agents/            ← Agent-Definitionen (Phase 2)
│   └── settings.json      ← Maximale Berechtigungen
├── config/                ← model-routing.yaml (Phase 2)
├── docs/decisions/        ← ADRs
├── evals/                 ← Tests & Evaluierungen
├── hooks/                 ← Session- und Tool-Hooks (Phase 2)
├── knowledge/             ← Wissensbasis
├── manifests/             ← Provider-Manifests (Phase 2)
├── memory/
│   ├── markdown/
│   │   ├── system/        ← Globale Learnings & Konventionen (in Git)
│   │   └── projects/      ← Pro-Projekt-Gedächtnis (in Git)
│   │       └── forgeos/   ← ForgeOS als Projekt #0
│   └── db/                ← SQLite + sqlite-vec Embeddings (Volume, nicht in Git)
├── plugins/               ← Installierte Plugins (z.B. Superpowers)
├── runtime/               ← Session-Traces, State (Volume, nicht in Git)
├── scripts/               ← Shell-Hilfsskripte
├── skills/                ← SKILL.md Dateien (Phase 2)
└── workspace/             ← Projekte (geklonte Repos, Volume)
```

## DEBUG_MODE

`DEBUG_MODE` wird aus `.env` geladen und von `entrypoint.sh` in MEMORY.md geschrieben.

**Falls `DEBUG_MODE: on` in MEMORY.md steht, MUSS am Ende jeder Antwort folgendes ausgegeben werden:**

```
[🔀 <Agent>]  Provider: <provider> | Modell: <modell> | Runden: <n> | Tool-Calls: <n> | Dauer: ~<Xs> | Token: ~<n> (geschätzt)
```

Felder:
- **Agent**: Name des Skills/Agents — bei normaler Chat-Antwort: `Chat`
- **Provider**: z.B. `Anthropic`, `OpenAI`, `Google`
- **Modell**: z.B. `claude-sonnet-4-6`
- **Runden**: Council-/Orchestrator-Runden — bei Chat: `1`
- **Tool-Calls**: Anzahl ausgeführter Tool-Calls
- **Dauer**: geschätzte Zeit in Sekunden
- **Token**: grobe Schätzung Input + Output, auf 100 gerundet

## Claude Code Berechtigungen

`claude/settings.json` hat maximale Berechtigungen — **kein Bestätigungsdialog** für normale Operationen.
Bash(*), Read(*), Write(*), Edit(*) und MCP-Tools sind automatisch genehmigt.

## Gedächtnis-System

Vier Ebenen (Details: ARCHITECTURE.md):

1. **System-Memory** — `/forgeos/memory/markdown/system/` — global, in Git
2. **Projekt-Memory** — `/forgeos/memory/markdown/projects/{name}/` — pro Projekt, in Git
3. **Session-Memory** — `/forgeos/runtime/state/` — kurzfristig, nicht in Git
4. **Learnings-Store** — `/forgeos/memory/db/` — SQLite + Embeddings, Volume

## Plugin-System

Plugins werden über `forgeos-plugins.yaml` verwaltet.
Primäres Plugin: **Superpowers** (`obra/superpowers`) — wird in Phase 2 installiert.
Plugins liegen in `/forgeos/plugins/` als geklonte Git-Repos.

## Modell-Routing

Verfügbare Provider stehen in MEMORY.md (wird beim Start generiert).
Kanonische Tier-Definitionen: `config/model-routing.yaml` (Single Source of Truth — Phase 2).
Grundprinzip: **Klein wenn möglich, Groß wenn nötig.**

## Neue Projekte anlegen

1. Lies ZUERST `knowledge/project-wizard.md`
2. Befolge die Schritte dort EXAKT
3. Lege das GitHub Repo mit `gh` an
4. Klone es in `/workspace/`
5. Erstelle CLAUDE.md, README.md, .gitignore
6. Mache den ersten Commit und pushe

## ForgeOS selbst verbessern

ForgeOS ist Projekt #0 — Änderungen folgen demselben Prozess:

1. Änderung verstehen und planen
2. Umsetzen und testen
3. Atomic Commit im Container: `git -C /forgeos add ... && git -C /forgeos commit && git -C /forgeos push`
4. `./update.sh` auf dem Host ausführen (rebuild + restart)

## Arbeitsweise

- Jede Änderung wird verstanden bevor sie gemacht wird
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git — immer `.env.example` statt `.env`
- Entscheidungen in `docs/decisions/` als ADR dokumentieren
- Learnings sofort in `memory/markdown/` festhalten

## KI-Runtimes

- Claude Code ✅ (primär, installiert)
- Gemini CLI 🔜 (geplant)
- OpenCode 🔜 (geplant)
- Codex 🔜 (geplant)
````

- [ ] **Step 2: Verify key sections are present**

```bash
grep -c "DEBUG_MODE\|Gedächtnis\|Plugin\|Modell-Routing\|Projekt #0" /docker/forgeos/CLAUDE.md
```

Expected: `5` (one match per pattern)

- [ ] **Step 3: Commit**

```bash
cd /docker/forgeos
git add CLAUDE.md
git commit -m "docs: add CLAUDE.md (ForgeOS project context)"
```

---

## Task 8: ARCHITECTURE.md

**Files:**
- Create: `/docker/forgeos/ARCHITECTURE.md`

This file explains the system thinking. It carries forward mycoforge's agent patterns and adds two new chapters: Memory Architecture and Plugin System.

- [ ] **Step 1: Create ARCHITECTURE.md**

Write to `/docker/forgeos/ARCHITECTURE.md`:

````markdown
# ForgeOS Architecture

> **Zweck dieser Datei:** Erklärt das *Systemdenken* hinter ForgeOS — Warum ist es so gebaut?
> Welche Patterns liegen zugrunde? Was ist bewusst offen?
>
> **Nicht hier:** Dateilisten, Pfade, Commands, Skills → siehe `CLAUDE.md`

---

## Vision

ForgeOS ist eine selbst-verbessernde KI-Entwicklungsumgebung.
Ein Multi-Agent-System das Aufgaben intelligent zerlegt, parallelisiert, diskutiert
und mit dem jeweils optimalen Modell ausführt.
ForgeOS ist Projekt #0 — es verbessert sich selbst durch die gleichen Prozesse,
die es für andere Projekte bereitstellt.

---

## Systemarchitektur

Vier Schichten von der Infrastruktur bis zur Nutzer-Interaktion:

```
┌─────────────────────────────────────────────────────────┐
│  LAYER 4: Commands & Hooks                              │
│  Slash Commands, automatische Trigger                   │
├─────────────────────────────────────────────────────────┤
│  LAYER 3: Multi-Agent System                            │
│  Router → Orchestrator / Council / Swarm                │
├─────────────────────────────────────────────────────────┤
│  LAYER 2: Model Router                                  │
│  Provider- und Modellauswahl pro Task                   │
├─────────────────────────────────────────────────────────┤
│  LAYER 1: Infrastruktur                                 │
│  Docker, Git, GitHub, MEMORY.md, Skills, Memory-System  │
└─────────────────────────────────────────────────────────┘
```

**Designprinzip:** Jede Schicht kennt nur die Schicht darunter.
Layer 4 (Commands) ruft Layer 3 (Agents) auf — niemals umgekehrt.

---

## Agent-Grundmuster: ReAct

Jeder einzelne Agent arbeitet nach dem **ReAct-Muster** (Reason → Act → Observe):

```
Nutzeranfrage / Teilaufgabe
    ↓
Reasoning  → Agent denkt über Problem nach, entscheidet Handlungsschritt
    ↓
Acting     → Agent nutzt Werkzeuge (Bash, Edit, Read, gh, git, …)
    ↓
Observe    → Agent betrachtet Ergebnis, reichert Kontext an
    ↓
Aufgabe erledigt? → Nein → zurück zu Reasoning
                 → Ja  → Finale Antwort / Übergabe
```

---

## Muster 1: Orchestrator (Plan & Solve)

Für mittlere und große Entwicklungsaufgaben.

```
Nutzeranfrage
    ↓
Orchestrator (großes Modell)
    → erstellt Gesamtplan
    → analysiert Abhängigkeiten zwischen Tasks
    → entscheidet: parallel oder sequentiell
    ↓
Unabhängige Tasks → parallel an Subagenten
Abhängige Tasks   → sequentiell
    ↓
Reviewer prüft Ergebnisse (Two-Stage: Spec + Qualität)
    ↓
Committer → atomarer Commit
```

**Wann Orchestrator:**
- ✅ Klar definierte Aufgabe mit bekanntem Lösungsweg
- ✅ Mehrere Dateien oder Komponenten betroffen
- ❌ Offene Exploration ohne klare Richtung → Swarm

---

## Muster 2: Council (Mehr-Augen-Prinzip)

Für Entscheidungen, Reviews und Variantenvergleiche.

```
Nutzeranfrage / Architektur-Frage
    ↓
Council-Mitglieder (parallel, verschiedene Perspektiven)
    ├── Generalist  → Gesamtbild, Machbarkeit, Konsequenzen
    ├── Developer   → Technische Umsetzung, Aufwand
    └── Reviewer    → Qualität, Security, Risiken
    ↓
Konsens gefunden?
    Ja  → Entscheidung + Nächste Schritte
    Nein → HitL: Nutzer entscheidet
```

### Diskussions-Governance

| Parameter | Default | Beschreibung |
|-----------|---------|-------------|
| `discussion_rounds` | 3 | Maximale Ping-Pong-Runden |
| `min_rounds` | 1 | Mindestens diese Anzahl |
| `early_stop` | true | Stoppe bei Konsens vor Limit |

**Wann Council:**
- ✅ Architektur-Entscheidungen mit mehreren validen Optionen
- ✅ Code Reviews, Sicherheitsbewertungen
- ❌ Standardisierte Aufgaben mit klarem Lösungsweg → Orchestrator

---

## Muster 3: Swarm (Exploration)

Nur für offene, komplexe Probleme ohne klaren Lösungsweg.
Das teuerste Muster — bewusst und selten einsetzen.

```
Offene Frage / Architektur-Exploration
    ↓
Swarm-Coordinator (steuert Iteration)
    ├── wählt 2–4 Agents pro Iteration (gezielt, nicht alle)
    ├── sammelt Erkenntnisse, Offene Fragen, Widersprüche
    ↓
Council-Swarm (Governance nach jeder Iteration)
    ├── Erkenntnisgewinn substanziell?
    ├── Konvergiert der Swarm?
    └── Lohnt weitere Iteration? → WEITER | KONVERGIERT | CHECKPOINT
    ↓
WEITER        → nächste Iteration (sofern < Limit)
KONVERGIERT   → Abschlussbericht
CHECKPOINT    → HitL: Nutzer entscheidet ob weitere Iterationen
```

**Iterations-Governance:** Limit konfigurierbar (default: 3 via `SWARM_MAX_ITERATIONS`).

**Wann Swarm:**
- ✅ Hohe Problemoffenheit, keine klare Lösungsrichtung
- ❌ Klar definierte Aufgaben → Orchestrator
- ❌ Entscheidung zwischen Optionen → Council

---

## Gedächtnis-Architektur

ForgeOS hat ein strukturiertes 4-Ebenen-Gedächtnis:

```
┌─────────────────────────────────────────────────────────┐
│  EBENE 1: System-Memory                                 │
│  Global, ForgeOS-weit, in Git versioniert               │
│  /forgeos/memory/markdown/system/                       │
│  Inhalt: globale Konventionen, Provider-Status,         │
│  installierte Plugins, systemweite Learnings            │
│  Geladen: bei jedem Session-Start                       │
├─────────────────────────────────────────────────────────┤
│  EBENE 2: Projekt-Memory                                │
│  Pro Projekt (inkl. ForgeOS = Projekt #0), in Git       │
│  /forgeos/memory/markdown/projects/{projekt-name}/      │
│  Inhalt: ADRs, Tech-Stack, Konventionen, Learnings      │
│  Geladen: beim Wechsel in ein Projekt                   │
├─────────────────────────────────────────────────────────┤
│  EBENE 3: Session-Memory                                │
│  Kurzfristig, nicht in Git (Volume)                     │
│  /forgeos/runtime/state/                                │
│  Inhalt: aktuelle Arbeit, offene Tasks, Zwischenstände  │
│  Lebenszeit: eine Session                               │
│  Bei Session-Ende → Zusammenfassung in Ebene 1 oder 2  │
├─────────────────────────────────────────────────────────┤
│  EBENE 4: Learnings-Store                               │
│  Semantisch durchsuchbar, nicht in Git (Volume)         │
│  /forgeos/memory/db/forgeos.sqlite (sqlite-vec)         │
│  Inhalt: Embeddings aller Learnings, Session-Summ.,     │
│  gelöste Probleme aus allen Projekten                   │
│  Ermöglicht: "Finde ähnliche Probleme"                  │
└─────────────────────────────────────────────────────────┘
```

**Datenfluss:**
```
Session endet
    → Zusammenfassung erstellen
    → in Projekt-Memory (Markdown, Ebene 2) schreiben
    → Embedding erstellen → in Learnings-Store (Ebene 4)

Projekt-Learning besonders wertvoll?
    → in System-Memory promoten (Ebene 1)
    → fließt in alle zukünftigen Projekte ein
```

**Implementation:** Ebenen 1–3 sind aktiv ab Phase 2.
Ebene 4 (sqlite-vec) wird als dediziertes Node.js-Modul in Phase 2 eingerichtet.

---

## Plugin-System

Plugins erweitern ForgeOS ohne den Core zu ändern.

```
forgeos-plugins.yaml
    ↓
/forgeos/plugins/{name}/     ← geklontes Git-Repo
    ↓
Claude Code lädt Skills/Commands aus dem Plugin
```

**Plugin-Lifecycle:**
- Installation: `git clone` in `/forgeos/plugins/`
- Update: `git pull` (manuell oder per `/update-plugins` Command)
- Deinstallation: Verzeichnis entfernen + Eintrag in forgeos-plugins.yaml löschen

**Primäres Plugin: Superpowers** (`obra/superpowers`)
- Wird als erstes Plugin in Phase 2 installiert
- Bringt Skills für Planning, TDD, Debugging, Code Review u.v.m.
- ADR-003 (offen): Welche mycoforge-Commands werden durch Superpowers ersetzt?

**Überlappungs-Strategie:**
- Wird nach Superpowers-Installation evaluiert (Phase 2, Schritt 2)
- ForgeOS-eigene Commands nur für Bereiche die Superpowers nicht abdeckt

---

## Human-in-the-Loop (HitL)

HitL ist ein vollwertiges Muster, kein Übergangszustand.

**Phase 1 — Standard (aktiv):**
Orchestrator und Council legen Entscheidungen dem Nutzer vor.
Der Nutzer hat das finale Wort bei allen wichtigen Entscheidungen.

**Phase 2 — Autonom (explizit aktivierbar):**
Orchestrator entscheidet autonom.
HitL nur bei kritischen oder unbekannten Situationen.
Aktivierung: bewusste Entscheidung des Nutzers — kein automatischer Übergang.

---

## Offene Entscheidungen

### ADR-001: Ab wann wird Phase 2 (autonomer Orchestrator) aktiviert?
**Status:** Offen — Vertrauen muss durch tatsächliche Nutzung wachsen.

### ADR-002: Hybrid Volume-Strategie
**Status:** Entschieden — `./claude` als Bind-Mount, Rest als Named Volumes / Image.
**Dokument:** `docs/decisions/ADR-002-hybrid-volumes.md`

### ADR-003: Superpowers-Integration vs. eigene Commands
**Status:** Offen — Evaluation in Phase 2 nach Superpowers-Installation.
````

- [ ] **Step 2: Verify key chapters are present**

```bash
grep -c "Gedächtnis-Architektur\|Plugin-System\|Human-in-the-Loop\|Muster 1\|Muster 2\|Muster 3" /docker/forgeos/ARCHITECTURE.md
```

Expected: `6`

- [ ] **Step 3: Commit**

```bash
cd /docker/forgeos
git add ARCHITECTURE.md
git commit -m "docs: add ARCHITECTURE.md (agent patterns, memory, plugins)"
```

---

## Task 9: README.md

**Files:**
- Create: `/docker/forgeos/README.md`

- [ ] **Step 1: Create README.md**

Write to `/docker/forgeos/README.md`:

````markdown
# ForgeOS

A self-improving, containerized AI development environment.

ForgeOS is the workshop. Projects created within it are the workpieces.
ForgeOS itself is Project #0 — it improves itself through the same processes it provides for other projects.

> **Rebuilt from:** [mycoforge](https://github.com/TrendForgeAI/mycoforge) — learnings carried forward, everything written fresh.

---

## Requirements

- Docker + Docker Compose v2
- GitHub account with a PAT (`repo`, `workflow`, `read:org`)
- At least one AI provider API key (Anthropic, OpenAI, Gemini, or xAI)

---

## First-Time Setup

```bash
# 1. Clone
git clone https://github.com/TrendForgeAI/forgeos.git /docker/forgeos
cd /docker/forgeos

# 2. Configure
cp .env.example .env
nano .env   # fill in GH_TOKEN and at least one API key

# 3. Build and start
./setup.sh
```

---

## Daily Use

```bash
./start-claude.sh    # Open Claude Code in the running container
./shell.sh           # Open a bash shell in the container
./update.sh          # Pull latest + rebuild + restart
```

---

## Phase 2 (first start)

After `./setup.sh`, open Claude Code in the container and follow `SETUP-CONTINUE.md`:

```bash
./start-claude.sh
# Inside container: read SETUP-CONTINUE.md
```

Phase 2 sets up: Claude auth login, Superpowers plugin, commands, agents, memory system.

---

## Project Structure

```
forgeos/
├── claude/          ← Commands, agents, settings (bind-mounted, live editable)
├── memory/          ← 4-layer memory system (markdown + sqlite)
├── plugins/         ← Installed plugins (Superpowers etc.)
├── workspace/       ← Your projects (cloned repos)
└── apps/            ← Web-UI, Bot (planned)
```

See `CLAUDE.md` for full structure, `ARCHITECTURE.md` for system design.

---

## License

Private repository — TrendForgeAI
````

- [ ] **Step 2: Commit**

```bash
cd /docker/forgeos
git add README.md
git commit -m "docs: add README.md"
```

---

## Task 10: Directory Structure + settings.json

**Files:**
- Create: `/docker/forgeos/claude/settings.json`
- Create: `.gitkeep` files in all tracked empty directories

- [ ] **Step 1: Create claude/settings.json**

```bash
mkdir -p /docker/forgeos/claude/commands
mkdir -p /docker/forgeos/claude/agents
```

Write to `/docker/forgeos/claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)",
      "mcp__*"
    ],
    "deny": []
  },
  "model": "claude-sonnet-4-6"
}
```

- [ ] **Step 2: Validate settings.json**

```bash
python3 -m json.tool /docker/forgeos/claude/settings.json > /dev/null && echo "JSON valid"
```

Expected: `JSON valid`

- [ ] **Step 3: Verify permissions include all four**

```bash
grep -c '"Bash(\*)\|Read(\*)\|Write(\*)\|Edit(\*)"' /docker/forgeos/claude/settings.json || \
python3 -c "
import json
s = json.load(open('/docker/forgeos/claude/settings.json'))
required = {'Bash(*)', 'Read(*)', 'Write(*)', 'Edit(*)'}
found = set(s['permissions']['allow']) & required
print(f'Found {len(found)}/4 required permissions: {found}')
assert len(found) == 4
print('OK')
"
```

Expected: `Found 4/4 required permissions: ...` and `OK`

- [ ] **Step 4: Create all remaining directories with .gitkeep**

```bash
cd /docker/forgeos

# Directories that need .gitkeep (tracked, empty)
dirs=(
  "apps"
  "claude/commands"
  "claude/agents"
  "config"
  "docs/decisions"
  "evals"
  "hooks"
  "knowledge"
  "manifests"
  "memory/markdown/system"
  "memory/markdown/projects/forgeos"
  "plugins"
  "scripts"
  "skills"
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
  touch "$d/.gitkeep"
done

# Gitignored volume directories — just mkdir, no .gitkeep needed
# (entrypoint.sh creates runtime subdirs at container start)
mkdir -p memory/db
touch memory/db/.gitkeep   # kept for dir visibility on host; gitignored so no git tracking
mkdir -p runtime
touch runtime/.gitkeep     # same — gitignored
mkdir -p workspace
touch workspace/.gitkeep   # same — gitignored
```

- [ ] **Step 5: Verify critical .gitkeep files exist**

```bash
for path in \
  "claude/commands/.gitkeep" \
  "claude/agents/.gitkeep" \
  "memory/markdown/system/.gitkeep" \
  "memory/markdown/projects/forgeos/.gitkeep"; do
  test -f "/docker/forgeos/$path" && echo "✓ $path" || echo "✗ MISSING: $path"
done
```

Expected: 4 lines starting with `✓`

- [ ] **Step 6: Commit**

```bash
cd /docker/forgeos
git add claude/settings.json
git add $(git ls-files --others --exclude-standard -- '**/.gitkeep' '.gitkeep')
git status  # review what's staged
git commit -m "chore: add directory structure, settings.json, gitkeep placeholders"
```

---

## Task 11: SETUP-CONTINUE.md

**Files:**
- Create: `/docker/forgeos/SETUP-CONTINUE.md`

This is the Phase 2 handoff document — Claude Code reads it inside the running container.
**Critical:** `claude auth login` must be documented as the first step.

- [ ] **Step 1: Create SETUP-CONTINUE.md**

Write to `/docker/forgeos/SETUP-CONTINUE.md`:

````markdown
# ForgeOS — Phase 2: Setup im Container

> Diese Datei wird von Claude Code **im Container** gelesen.
> Kontext: Phase 1 (Bootstrap auf dem Host) ist abgeschlossen.
> Der ForgeOS-Container läuft als Daemon.

## Deine Aufgabe

Du bist Claude Code innerhalb des ForgeOS-Containers.
Lies zuerst `CLAUDE.md` und `ARCHITECTURE.md` um den vollen Kontext zu bekommen.
Dann arbeite die folgenden Schritte der Reihe nach ab.
Frage den Nutzer bei wichtigen Entscheidungen (HitL Phase 1).

---

## Schritt 1: Claude Code Auth Login

```bash
claude auth login
```

Dies öffnet einen Browser-Login (OAuth). Der Token wird in `/forgeos/claude/.claude.json`
gespeichert und persistiert über Container-Neustarts (Bind-Mount auf den Host).

**Wichtig:** `claude/.claude.json` ist in `.gitignore` — der Token kommt nie in Git.

---

## Schritt 2: Superpowers Plugin installieren

- Installiere das Superpowers-Plugin über den offiziellen Marketplace
- Prüfe welche Skills und Commands Superpowers mitbringt
- Dokumentiere die installierten Skills in `memory/markdown/system/plugins.md`
- Erstelle `forgeos-plugins.yaml` im Root-Verzeichnis und trage Superpowers ein

---

## Schritt 3: Superpowers evaluieren (ADR-003)

- Vergleiche Superpowers-Commands mit den mycoforge-Commands
  (Referenz: https://github.com/TrendForgeAI/mycoforge — `CLAUDE.md` und `claude/commands/`)
- Identifiziere: Was übernimmt Superpowers komplett? Wo braucht ForgeOS eigene Ergänzungen?
- Erstelle Entscheidungs-Übersicht in `docs/decisions/ADR-003-superpowers-integration.md`
- Frage den Nutzer bei wichtigen Entscheidungen

---

## Schritt 4: ForgeOS-eigene Commands erstellen

Basierend auf der Evaluation aus Schritt 3: Erstelle Commands die Superpowers NICHT abdeckt.
Orientierung: mycoforge `claude/commands/` als Referenz (nicht kopieren — neu schreiben).
Mindestens prüfen: `/commit`, `/route`, `/pause`, `/new-project`

---

## Schritt 5: Agent-Definitionen erstellen

- Übernimm bewährte Agents aus mycoforge `claude/agents/` als Orientierung
- Mindestens: `planner`, `developer`, `reviewer`, `committer`, Council-Agents, Swarm-Coordinator
- Passe sie an die ForgeOS-Architektur an

---

## Schritt 6: Hooks einrichten

- Session-Start Hook (`cc-session-start.sh`): MEMORY.md laden, Provider anzeigen, offene TODOs
- Pre-Bash Hook (`cc-pre-bash.sh`): Secrets-Scan vor `git commit`
- Context-Monitor Hook (`cc-context-monitor.sh`): Warnung bei hoher Kontext-Auslastung

---

## Schritt 7: Memory-System aufsetzen (Ebene 4)

- Node.js-Modul in `/forgeos/memory/` anlegen mit eigener `package.json`
- Dependencies: `better-sqlite3`, `sqlite-vec`
- SQLite-DB initialisieren: `/forgeos/memory/db/forgeos.sqlite`
- Tabellen erstellen: `sessions`, `learnings`, `embeddings`
- Test: Embedding erstellen und Ähnlichkeitssuche durchführen

---

## Schritt 8: Model-Routing konfigurieren

- `config/model-routing.yaml` erstellen (mycoforge `config/` als Referenz)
- Aktuelle Modellnamen prüfen und aktualisieren (Stand: März 2026)
- `manifests/` Dateien erstellen

---

## Schritt 9: Weitere Plugins evaluieren

- GSD (https://github.com/gsd-build/get-shit-done) durchsuchen — nicht 1:1 übernehmen,
  nach sinnvollen Ergänzungen suchen
- Marketplace nach weiteren nützlichen Plugins durchsuchen
- Für jedes: Qualität prüfen, Nutzen bewerten, ggf. installieren

---

## Schritt 10: ForgeOS Projekt-Memory initialisieren

- ForgeOS ist Projekt #0
- `memory/markdown/projects/forgeos/decisions.md` erstellen
- Alle Architektur-Entscheidungen (ADR-001, ADR-002, ADR-003) dokumentieren
- `memory/markdown/projects/forgeos/learnings.md` erstellen

---

## Schritt 11: TODO.md + Abschluss

- `TODO.md` mit nächsten Schritten erstellen (Web-UI, Bot, weitere Plugins)
- Finaler Commit und Push
- Diese Datei (`SETUP-CONTINUE.md`) als erledigt markieren

---

## Wichtige Regeln für Phase 2

- HitL Phase 1 ist aktiv — Nutzer bei wichtigen Entscheidungen fragen
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git
- Entscheidungen in `docs/decisions/` als ADR dokumentieren
- Learnings sofort in `memory/markdown/` festhalten
````

- [ ] **Step 2: Verify claude auth login is the first documented step**

```bash
grep -n "claude auth login" /docker/forgeos/SETUP-CONTINUE.md | head -3
```

Expected: A line showing `claude auth login` in Schritt 1 (line numbers in the 20s–30s range).

- [ ] **Step 3: Commit**

```bash
cd /docker/forgeos
git add SETUP-CONTINUE.md
git commit -m "docs: add SETUP-CONTINUE.md (Phase 2 instructions)"
```

---

## Task 12: GitHub Repo + Initial Push

**Prerequisites:** `GH_TOKEN` and `GH_ORG` must be set (they are in `.env`, but these commands run on the host — export them first).

- [ ] **Step 1: Export GitHub credentials**

```bash
export GH_TOKEN=$(grep ^GH_TOKEN /docker/forgeos/.env | cut -d= -f2-)
export GH_ORG=$(grep ^GH_ORG /docker/forgeos/.env | cut -d= -f2-)
echo "GH_TOKEN: ${GH_TOKEN:0:4}****"
echo "GH_ORG: $GH_ORG"
```

Verify both values are set (non-empty).

- [ ] **Step 2: Authenticate gh on host**

```bash
echo "$GH_TOKEN" | gh auth login --with-token
gh auth status
```

Expected: authenticated as a user in `TrendForgeAI`.

- [ ] **Step 3: Create GitHub repo**

```bash
gh repo create "${GH_ORG}/forgeos" \
  --description "A self-improving AI development environment" \
  --private
```

Expected: URL output like `https://github.com/TrendForgeAI/forgeos`

- [ ] **Step 4: Add remote and push**

```bash
cd /docker/forgeos
git remote add origin "https://github.com/${GH_ORG}/forgeos.git"
git branch -M main
git push -u origin main
```

Expected: `Branch 'main' set up to track remote branch 'main' from 'origin'.`

- [ ] **Step 5: Verify repo exists and is private**

```bash
gh repo view "${GH_ORG}/forgeos" --json name,isPrivate,url \
  | python3 -m json.tool
```

Expected: `"isPrivate": true`

---

## Task 13: Docker Image Build

**Prerequisites:** All files are committed and the `docker-compose.yml` uses the correct bind mount.

- [ ] **Step 1: Verify bind mount in docker-compose.yml**

```bash
grep "claude" /docker/forgeos/docker-compose.yml
```

Expected: `      - ./claude:/forgeos/claude` (a bind mount, not a named volume reference)

- [ ] **Step 2: Verify symlink order in Dockerfile**

```bash
awk '/^RUN ln -s/{ ln=NR } /^COPY \. /{ cp=NR } END { if (ln < cp) print "OK: ln -s on line " ln " before COPY on line " cp; else print "ERROR: wrong order" }' /docker/forgeos/Dockerfile
```

Expected: `OK: ln -s on line N before COPY on line M` (where N < M)

- [ ] **Step 3: Build the Docker image**

```bash
cd /docker/forgeos
docker compose build 2>&1 | tail -5
```

Expected: Last lines show `=> exporting to image` and the process exits 0. No error messages.

- [ ] **Step 4: Confirm image exists**

```bash
docker images | grep forgeos
```

Expected: A line with `forgeos` and a recent timestamp.

- [ ] **Step 5: Smoke test — container starts**

```bash
cd /docker/forgeos
docker compose up -d
sleep 3
docker compose ps
```

Expected: `forgeos` container shows `running` status.

- [ ] **Step 6: Smoke test — symlink is correct inside container**

```bash
docker exec forgeos ls -la /root/.claude
```

Expected: `lrwxrwxrwx ... /root/.claude -> /forgeos/claude`

- [ ] **Step 7: Smoke test — settings.json is accessible**

```bash
docker exec forgeos cat /root/.claude/settings.json
```

Expected: The JSON with `Bash(*)`, `Read(*)`, `Write(*)`, `Edit(*)` permissions.

- [ ] **Step 8: Stop container (Phase 2 handles the real start)**

```bash
cd /docker/forgeos
docker compose down
```

---

## Task 14: Completion

- [ ] **Step 1: Print completion message to user**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ ForgeOS Phase 1 abgeschlossen!

  Repo:  https://github.com/TrendForgeAI/forgeos
  Lokal: /docker/forgeos

  Nächste Schritte:

  1. Einmaliger Claude-Login (Pro Plan):
       docker compose run --rm -it forgeos claude auth login
     ODER: Container starten und dann:
       ./start-claude.sh

  2. ForgeOS als Daemon starten:
       cd /docker/forgeos && docker compose up -d

  3. Claude Code im Container starten:
       ./start-claude.sh

  4. Im Container Phase 2 starten:
       Lies SETUP-CONTINUE.md und arbeite die Schritte ab.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Success Checklist

Before declaring Phase 1 complete, verify ALL of the following:

- [ ] `git log --oneline` shows atomic commits for each task
- [ ] `git check-ignore .env` confirms .env is gitignored
- [ ] `claude/.claude.json` is in `.gitignore`
- [ ] `grep "ln -s" Dockerfile` line number is LOWER than `grep "^COPY" Dockerfile` line number
- [ ] `docker-compose.yml` uses `./claude:/forgeos/claude` (bind mount, not named volume)
- [ ] `claude/settings.json` contains `Bash(*)`, `Read(*)`, `Write(*)`, `Edit(*)`
- [ ] `setup.sh` does NOT contain `claude auth login`
- [ ] `SETUP-CONTINUE.md` contains `claude auth login` as Schritt 1
- [ ] `memory/markdown/system/.gitkeep` exists
- [ ] `memory/markdown/projects/forgeos/.gitkeep` exists
- [ ] GitHub repo `TrendForgeAI/forgeos` is private
- [ ] `docker compose build` exited 0
- [ ] Container smoke test passed (symlink + settings.json accessible)
