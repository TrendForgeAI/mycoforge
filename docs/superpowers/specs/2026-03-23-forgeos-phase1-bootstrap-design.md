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

**Bind mount shadowing:** The `COPY . /forgeos/` in the Dockerfile also copies `claude/` into the image layer. At runtime the bind mount `./claude:/forgeos/claude` fully shadows the image layer — there is NO fallback to the baked-in copy if the host `./claude` is missing or empty. This is correct and intentional: `claude/settings.json` is guaranteed to exist on the host because it is created in Phase 1 Step 15 before the container ever starts.

**Auth state:** Claude Code writes its OAuth token to `~/.claude.json` (i.e., `/root/.claude.json`). Because `/root/.claude` is a symlink to `/forgeos/claude`, any `.claude.json` written there lands in `/forgeos/claude/.claude.json` which is on the host bind mount — it persists automatically across container restarts without any symlink hacks. `claude/.claude.json` must be in `.gitignore`.

### Dockerfile Instruction Order

The `ln -s /forgeos/claude /root/.claude` symlink instruction MUST appear BEFORE `COPY . /forgeos/` in the Dockerfile. If `COPY` runs first, it creates `/forgeos/claude` as a real directory, making the subsequent `ln -s` fail.

Correct order:
```dockerfile
RUN ln -s /forgeos/claude /root/.claude   # symlink first
COPY . /forgeos/                           # copy after
```

### entrypoint.sh Behavior

The entrypoint runs once per container start, then hands off to CMD via `exec "$@"`.

Steps in order:
1. Configure git identity (`GIT_USER_NAME`, `GIT_USER_EMAIL`)
2. GitHub auth via `gh auth login --with-token` (using `GH_TOKEN`)
3. Configure git credential URL rewrite for HTTPS GitHub access
4. Detect active providers (check env vars: `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `GEMINI_API_KEY`, `XAI_API_KEY`; check `claude/.credentials.json` for Pro plan)
5. Ensure runtime subdirs exist: `mkdir -p /forgeos/runtime/traces /forgeos/runtime/state /workspace /forgeos/memory/db /forgeos/memory/markdown/system /forgeos/memory/markdown/projects`
6. Generate `MEMORY.md` with: timestamp, active providers, DEBUG_MODE, FORGEOS_AUTO_COMMIT, list of projects in `/workspace/`
7. `exec "$@"` — hand off to CMD (`tail -f /dev/null`)

### Runtime Mode

- **CMD:** `tail -f /dev/null` — container runs 24/7 as daemon, Claude Code is NOT auto-started
- **Access:** `./start-claude.sh` (docker exec -it forgeos claude)
- **Updates:** `update.sh` (git pull → docker compose build → restart) for image changes

### setup.sh Scope

`setup.sh` is the first-time install script for the HOST. It covers:
1. Copy `.env.example` → `.env` if not present, prompt to fill in
2. `docker compose build`
3. `docker compose up -d`
4. Print next steps including `./start-claude.sh` and the Phase 2 instruction

`setup.sh` does NOT run `claude auth login` — this is an interactive step that happens inside the running container as the first step of Phase 2. It is documented in `SETUP-CONTINUE.md`.

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

## .gitignore Patterns

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

---

## File Inventory (Phase 1)

| File | Description |
|------|-------------|
| `.env.example` | All required variables with comments |
| `.env` | Copied from `/docker/mycoforge/.env`, adapted for ForgeOS |
| `.gitignore` | See patterns above |
| `Dockerfile` | node:24-slim, symlink before COPY, no sqlite-vec global |
| `docker-compose.yml` | Hybrid volumes (`./claude` bind mount), env_file |
| `entrypoint.sh` | Git/GitHub config, provider detection, mkdir -p, MEMORY.md, exec "$@" |
| `start-claude.sh` | docker exec -it forgeos claude |
| `shell.sh` | docker exec -it forgeos bash |
| `update.sh` | git pull → build → restart |
| `setup.sh` | Host-only: build + start + next-step hints (no auth login) |
| `CLAUDE.md` | ForgeOS project context for Claude Code |
| `ARCHITECTURE.md` | System thinking, agent patterns, memory architecture, plugin system |
| `README.md` | Human-readable intro, install, usage |
| `SETUP-CONTINUE.md` | Phase 2 instructions for Claude Code inside the container |
| `claude/settings.json` | Max permissions: Bash(*), Read(*), Write(*), Edit(*), mcp__* |
| Directory structure | All dirs with `.gitkeep` where needed (see below) |

---

## Directory Structure

```
/docker/forgeos/
├── apps/                              # future Web-UI, Bot (.gitkeep)
├── claude/
│   ├── commands/                      # empty, Phase 2 (.gitkeep)
│   ├── agents/                        # empty, Phase 2 (.gitkeep)
│   └── settings.json                  # permissions + model
├── config/                            # model-routing.yaml, Phase 2 (.gitkeep)
├── docs/decisions/                    # ADRs (.gitkeep)
├── evals/                             # (.gitkeep)
├── hooks/                             # Phase 2 (.gitkeep)
├── knowledge/                         # (.gitkeep)
├── manifests/                         # Phase 2 (.gitkeep)
├── memory/
│   ├── markdown/
│   │   ├── system/                    # .gitkeep
│   │   └── projects/
│   │       └── forgeos/               # .gitkeep (ForgeOS is Project #0)
│   └── db/                            # .gitkeep (in .gitignore — volume)
├── plugins/                           # (.gitkeep)
├── runtime/                           # .gitkeep (in .gitignore — volume)
│   ├── traces/                        # created by entrypoint.sh at runtime
│   └── state/                         # created by entrypoint.sh at runtime
├── scripts/                           # (.gitkeep)
├── skills/                            # Phase 2 (.gitkeep)
└── workspace/                         # .gitkeep (in .gitignore — volume)
```

**Note:** `runtime/traces/` and `runtime/state/` are created by `entrypoint.sh` via `mkdir -p` at container start (not `.gitkeep`), because `runtime/` is a named volume that starts empty.

---

## Execution Order (19 Steps)

1. Git init
2. `.env.example`
3. `.env` (copy + adapt from mycoforge)
4. `.gitignore`
5. `Dockerfile` (symlink before COPY, no sqlite-vec)
6. `docker-compose.yml` (hybrid volumes)
7. `entrypoint.sh` (all 7 behavior steps, ends with exec "$@")
8. `start-claude.sh`
9. `shell.sh`
10. `update.sh`
11. `setup.sh` (host-only, no auth login)
12. `CLAUDE.md`
13. `ARCHITECTURE.md`
14. `README.md`
15. Directory structure + `claude/settings.json` + `.gitkeep` files
16. `SETUP-CONTINUE.md` (Phase 2 scope: auth login as first step, then Superpowers etc.)
17. GitHub repo `TrendForgeAI/forgeos` (private), initial commit, push
18. `docker compose build`
19. Completion message to user

**Commit strategy:** Atomic commits per file or logical group, Conventional Commits (`feat:`, `docs:`, `chore:`).

---

## Success Criteria

- All files created with correct content
- `./claude` bind-mount in docker-compose.yml (not named volume)
- `sqlite-vec` NOT in Dockerfile (Phase 2)
- `ln -s` instruction appears before `COPY . /forgeos/` in Dockerfile
- `claude/.claude.json` in `.gitignore`
- `claude/settings.json` exists on host with max permissions
- `setup.sh` does NOT contain `claude auth login`
- `SETUP-CONTINUE.md` exists and documents as first step: `claude auth login` inside container
- `memory/markdown/system/` and `memory/markdown/projects/forgeos/` have `.gitkeep` files
- GitHub repo `TrendForgeAI/forgeos` private, initial commit pushed
- `docker compose build` exits 0
