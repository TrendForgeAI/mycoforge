# mycoforge 🍄

> An organic AI development environment that grows with you

mycoforge is a containerized AI development environment that lets you develop projects with multiple AI runtimes — and improve itself in the process. Like mycelium, it grows invisibly beneath the surface, connecting everything and expanding where needed.

## What it does

mycoforge gives you a clean, reproducible AI development environment. You define it in Git, deploy it via Docker, and use it to build projects with Claude Code — and later with Gemini, OpenCode, and Codex.

The environment itself is just another project. You can improve it the same way you improve anything else: define, build, ship.

## Deployment

mycoforge runs on any Docker host — local VPS, Coolify, Hostinger Docker Panel, or any container platform.

### Local VPS

```bash
# 1. Clone the repo
git clone git@github.com:TrendForgeAI/mycoforge.git
cd mycoforge

# 2. Run setup (interactive, run once)
./setup.sh
```

`setup.sh` will guide you through:
- Git identity configuration
- SSH key creation for GitHub
- `.env` creation from `.env.example`
- Claude credentials check
- Docker container build

A `docker-compose.override.yml` is automatically used for local dev — it adds live code editing and SSH key mounts on top of the base config.

### Coolify / Hostinger / Any Platform

1. Point the platform at this GitHub repo
2. Set environment variables via the platform UI (see `.env.example`)
3. Deploy — no manual setup needed

The image is self-contained: all code is baked in via `COPY` in the Dockerfile. Named Docker volumes persist data across restarts:
- `mycoforge_workspace` → `/workspace` (your projects)
- `mycoforge_claude` → `/mycoforge/claude` (Claude credentials, session history)
- `mycoforge_runtime` → `/mycoforge/runtime` (session traces, project state)

## Environment Variables

See `.env.example` for all available variables:

| Variable | Required | Description |
|----------|----------|-------------|
| `ANTHROPIC_API_KEY` | Yes* | Claude API key |
| `GH_TOKEN` | Yes | GitHub Personal Access Token (`repo`, `workflow`, `read:org`) |
| `GH_ORG` | Yes | GitHub user or org name |
| `GIT_USER_NAME` | Yes | Git commit author name |
| `GIT_USER_EMAIL` | Yes | Git commit author email |
| `OPENAI_API_KEY` | No | OpenAI API key (optional provider) |
| `GEMINI_API_KEY` | No | Google Gemini API key (optional provider) |
| `XAI_API_KEY` | No | xAI Grok API key (optional provider) |
| `DEBUG_MODE` | No | `on` = show agent/model info per response |

*Or use Claude Pro/Max plan via browser auth.

## How it works

mycoforge uses a multi-agent system built on top of Claude Code. When you give it a task, it doesn't just respond — it routes the task to the right pattern:

| Pattern | When | Example |
|---------|------|---------|
| **Orchestrator** | Defined task, multiple files | `/implement` a new feature |
| **Council** | Decision or review | `/discuss` two architectural options |
| **Swarm** | Open-ended exploration | `/explore` an unclear problem |
| **Direct** | Simple tasks | `/commit`, `/route` |

Each pattern uses specialized agents (Planner, Developer, Reviewer, Committer, …) assigned to the right model tier (small/medium/large) based on task complexity.

## Slash Commands

| Command | Pattern | Description |
|---------|---------|-------------|
| `/plan` | Plan & Solve | Break down a task into steps |
| `/implement` | Orchestrator | Execute a plan with sub-agents |
| `/review` | Council (3 rounds) | Code review from 3 perspectives |
| `/discuss` | Council (2–5 rounds) | Discuss two approaches, reach consensus |
| `/explore` | Swarm | Open-ended exploration of a complex problem |
| `/verify` | ReAct | Check that an implementation actually works |
| `/finish-branch` | ReAct | Close a branch — tests, merge/PR/discard |
| `/worktree` | ReAct | Manage Git worktrees for parallel work |
| `/release` | Wizard | Create a versioned release (SemVer + GitHub Release) |
| `/new-project` | HitL + Orchestrator | Interactive wizard to scaffold a new project |
| `/commit` | ReAct (small) | Smart commit with generated message |
| `/route` | ReAct (small) | Classify a task and pick the best model |
| `/pause` | ReAct | Save session state before interrupting |

## Usage

**Start an interactive session:**
```bash
./start.sh
```

**Shell into the running container:**
```bash
./shell.sh
```

**Start a new project:**
```
> /new-project
```
Claude will ask for all required information before starting.

**Implement a feature:**
```
> /plan add user authentication to the API
> /implement
```

**Review code:**
```
> /review
```

## Updating

```bash
./update.sh
```

Pulls latest changes from GitHub, rebuilds the image, and restarts the container if running. Works from any directory — the script resolves its own path.

## Project structure

```
mycoforge/
├── CLAUDE.md              # Project context for Claude Code
├── MEMORY.md              # System memory (auto-generated on start)
├── README.md              # This file
├── Dockerfile             # Container definition
├── docker-compose.yml     # Base config (Platform-Modus)
├── docker-compose.override.yml  # Local dev overrides (gitignored)
├── setup.sh               # One-time setup for local VPS
├── entrypoint.sh          # Container initialization on every start
├── update.sh              # Update workflow
├── start.sh               # Start Claude (Terminal 1)
├── shell.sh               # Shell into container (Terminal 2)
├── .env.example           # Required environment variables
├── config/                # Canonical configuration
│   └── model-routing.yaml # Single source of truth for tiers, providers, models
├── manifests/             # Machine-readable system registry
│   ├── commands.yaml      # All 13 commands (name, pattern, tier, agents)
│   └── agents.yaml        # All 12 agents (name, tier, pattern)
├── scripts/               # Runtime scripts
│   └── generate-memory.sh # Generates MEMORY.md from config + manifests
├── evals/                 # Deterministic test suites (run: bash evals/run-evals.sh)
│   ├── run-evals.sh       # Test runner (exit 1 on failures, CI-compatible)
│   ├── routing/           # Routing config schema + model extraction tests
│   ├── manifests/         # Manifest↔filesystem consistency tests
│   ├── hooks/             # secrets-scan unit tests
│   └── generator/         # MEMORY.md generator output tests
├── claude/                # Claude Code config (~/.claude symlink → here)
│   ├── commands/          # Custom slash commands (not in Git)
│   └── agents/            # Agent definitions (not in Git)
├── workspace/             # Your projects (not in Git, named volume)
├── runtime/               # Session traces + state (not in Git, named volume)
│   ├── traces/            # JSONL event logs per session
│   └── state/             # Persistent project registry and state
├── hooks/                 # Shell hooks (SessionStart, PreToolUse, etc.)
├── skills/                # Skill definitions (loaded on demand)
├── docs/                  # Documentation
│   ├── usage.md           # Full usage guide
│   ├── agent-guide.md     # Guide for creating new agents
│   └── decisions/         # Architecture Decision Records (ADRs)
└── knowledge/             # Context loaded on demand
    ├── models.md          # AI models & routing explanation (see config/ for data)
    ├── git-workflow.md    # Git conventions
    ├── project-wizard.md  # How to start a new project
    └── docker.md          # Container changes
```

## Scripts

| Script | When | Who |
|--------|------|-----|
| `setup.sh` | Once after clone | You, manually |
| `start.sh` | Start a session | You, manually |
| `shell.sh` | Debug / inspect | You, manually |
| `entrypoint.sh` | Every container start | Docker, automatically |
| `update.sh` | When updating | You, manually |

## AI Runtimes

| Runtime | Status |
|---------|--------|
| Claude Code | ✅ supported |
| Gemini CLI | 🔜 planned |
| OpenCode | 🔜 planned |
| Codex | 🔜 planned |

## Documentation

- [`docs/usage.md`](docs/usage.md) — full usage guide (all commands, workflows, examples)
- [`docs/agent-guide.md`](docs/agent-guide.md) — developer guide for creating new agents
- [`ARCHITECTURE.md`](ARCHITECTURE.md) — system design & agent patterns
- [`CLAUDE.md`](CLAUDE.md) — context for Claude Code (project conventions, routing)

## License

MIT
