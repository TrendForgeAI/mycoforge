# ForgeOS Phase 1 — Bootstrap Design

**Date:** 2026-03-23
**Status:** Approved
**Scope:** Host bootstrap at `/docker/forgeos/` — from empty directory to built Docker image

---

## Context

ForgeOS is the optimized rebuild of mycoforge. It is a self-improving, containerized AI development environment. ForgeOS is the "workshop"; projects created within it are the "workpieces". ForgeOS itself is Project #0 and improves itself over time.

**What Phase 1 covers:** All files on the host, GitHub repo creation, Docker image build.
**What Phase 1 does NOT cover:** Claude login, running container, Superpowers integration, commands/agents/skills setup — all Phase 2 (documented in `SETUP-CONTINUE.md`).

**Predecessor:** mycoforge (`/docker/mycoforge/`, `TrendForgeAI/mycoforge`) — concepts are carried forward, no copy-paste.

---

## Architecture

### Container Base

- **Image:** `node:24-slim`
- **System packages:** git, curl, wget, ca-certificates, nano, jq, sqlite3, python3, python3-pip
- **Global npm:** `@anthropic-ai/claude-code`, `gh` (via apt)
- **Note:** `better-sqlite3` and `sqlite-vec` are NOT installed globally — the memory system (sqlite-vec) will be set up as a dedicated module with its own `package.json` in Phase 2
- **Node.js:** 24 LTS (upgrade from mycoforge's Node 22)

### Volume Strategy (ADR-002: Hybrid)

```yaml
volumes:
  - ./claude:/forgeos/claude          # bind mount — live editable without rebuild
  - forgeos_workspace:/workspace      # named volume — projects
  - forgeos_runtime:/forgeos/runtime  # named volume — traces, logs
  - forgeos_memory_db:/forgeos/memory/db  # named volume — SQLite (Phase 2)
```

**Rationale:** Infrastructure files (Dockerfile, entrypoint.sh, scripts) change rarely — baking them into the image via `COPY . /forgeos/` is appropriate. Commands, agents, and skills change frequently during development and Superpowers integration — bind-mounting `./claude` makes them live-editable without a rebuild.

**Consequence:** `claude/settings.json` must exist on the host before container start. This is guaranteed because it is created in Phase 1 Step 15 (directory structure).

**Symlink:** `ln -s /forgeos/claude /root/.claude` in Dockerfile — Claude Code finds its config at the expected path.

### Runtime Mode

- **CMD:** `tail -f /dev/null` — container runs 24/7 as daemon, Claude Code is NOT auto-started
- **Access:** `./start-claude.sh` (docker exec -it forgeos claude)
- **Updates:** `update.sh` (git pull → docker compose build → restart) for image changes

---

## Key Decisions

### ADR-001: When to activate Phase 2 (autonomous orchestrator)
**Status:** Intentionally deferred — trust must grow through actual usage, no automatic transition.

### ADR-002: Hybrid volume strategy (this design)
**Decision:** `./claude` as bind mount, everything else as named volumes or baked into image.
**Why:** Commands/agents/skills need live editing; infrastructure does not.

### ADR-003: Superpowers integration vs. own commands
**Status:** Intentionally deferred — evaluation happens in Phase 2 after Superpowers is installed.

---

## File Inventory (Phase 1)

| File | Description |
|------|-------------|
| `.env.example` | All required variables with comments |
| `.env` | Copied from `/docker/mycoforge/.env`, adapted for ForgeOS |
| `.gitignore` | Excludes `.env`, volumes, node_modules, claude session data |
| `Dockerfile` | node:24-slim, system packages, Claude Code, GitHub CLI, symlink |
| `docker-compose.yml` | Hybrid volumes, env_file, restart: unless-stopped |
| `entrypoint.sh` | Git identity, GitHub auth, provider detection, MEMORY.md generation |
| `start-claude.sh` | docker exec -it forgeos claude |
| `shell.sh` | docker exec -it forgeos bash |
| `update.sh` | git pull → build → restart |
| `setup.sh` | First-time install: build + claude auth login + start |
| `CLAUDE.md` | ForgeOS project context for Claude Code |
| `ARCHITECTURE.md` | System thinking, agent patterns, memory architecture, plugin system |
| `README.md` | Human-readable intro, install, usage |
| `SETUP-CONTINUE.md` | Phase 2 instructions for Claude Code inside the container |
| `claude/settings.json` | Max permissions: Bash(*), Read(*), Write(*), Edit(*), mcp__* |
| Directory structure | All dirs with `.gitkeep` where needed |

---

## Directory Structure

```
/docker/forgeos/
├── apps/                         # future Web-UI, Bot
├── claude/
│   ├── commands/                 # empty, Phase 2
│   ├── agents/                   # empty, Phase 2
│   └── settings.json             # permissions + model
├── config/                       # model-routing.yaml (Phase 2)
├── docs/decisions/               # ADRs
├── evals/
├── hooks/                        # Phase 2
├── knowledge/
├── manifests/                    # Phase 2
├── memory/
│   ├── markdown/
│   │   ├── system/
│   │   └── projects/forgeos/     # ForgeOS is Project #0
│   └── db/                       # .gitkeep (sqlite volume, in .gitignore)
├── plugins/
├── runtime/                      # .gitkeep (volume, in .gitignore)
│   ├── traces/
│   └── state/
├── scripts/
├── skills/                       # Phase 2
└── workspace/                    # .gitkeep (volume, in .gitignore)
```

---

## Execution Order (19 Steps)

1. Git init
2. `.env.example`
3. `.env` (copy + adapt from mycoforge)
4. `.gitignore`
5. `Dockerfile`
6. `docker-compose.yml`
7. `entrypoint.sh`
8. `start-claude.sh`
9. `shell.sh`
10. `update.sh`
11. `setup.sh`
12. `CLAUDE.md`
13. `ARCHITECTURE.md`
14. `README.md`
15. Directory structure + `claude/settings.json`
16. `SETUP-CONTINUE.md`
17. GitHub repo `TrendForgeAI/forgeos` (private), initial commit, push
18. `docker compose build`
19. Completion message to user

**Commit strategy:** Atomic commits per file or logical group, Conventional Commits (`feat:`, `docs:`, `chore:`).

---

## Success Criteria

- All files created with correct content
- `./claude` bind-mount in docker-compose.yml (not named volume)
- `sqlite-vec` NOT in Dockerfile (Phase 2)
- `claude/settings.json` exists on host with max permissions
- GitHub repo `TrendForgeAI/forgeos` private, initial commit pushed
- `docker compose build` exits 0
- `SETUP-CONTINUE.md` provides complete Phase 2 instructions
