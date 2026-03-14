# mycoforge 🍄

> An organic AI development environment that grows with you

mycoforge is a containerized AI development environment that lets you develop projects with multiple AI runtimes — and improve itself in the process. Like mycelium, it grows invisibly beneath the surface, connecting everything and expanding where needed.

## What it does

mycoforge gives you a clean, reproducible AI development environment on your VPS. You define it in Git, deploy it via Docker, and use it to build projects with Claude Code — and later with Gemini, OpenCode, and Codex.

The environment itself is just another project. You can improve it the same way you improve anything else: define, build, ship.

## Requirements

- Ubuntu VPS with Docker
- GitHub account
- Anthropic API key or Claude Pro/Max plan
- GitHub Personal Access Token (scopes: `repo`, `workflow`, `read:org`)

## Installation
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

## Usage

**Test that everything works:**
```bash
docker compose run --rm mycoforge claude -p "Say: mycoforge works"
```

**Start an interactive session:**
```bash
docker compose run --rm -it mycoforge claude
```

**Start a new project:**
```bash
docker compose run --rm -it mycoforge claude
# Then tell Claude: "Create a new project called <name>"
# Claude will ask for all required information before starting
```

## Updating
```bash
./update.sh
```

Pulls latest changes from GitHub, rebuilds the container, and restarts if running.

## Project structure
```
mycoforge/
├── CLAUDE.md              # Project context for Claude Code
├── MEMORY.md              # System memory (auto-generated on start)
├── README.md              # This file
├── Dockerfile             # Container definition
├── docker-compose.yml     # Deployment
├── setup.sh               # One-time setup script
├── entrypoint.sh          # Container initialization on every start
├── update.sh              # Update workflow
├── .env.example           # Required environment variables
├── claude/                # Claude Code configuration (local, not in Git)
├── workspace/             # Your projects live here (local, not in Git)
└── knowledge/             # Context loaded on demand
    ├── models.md          # AI models & routing logic
    ├── git-workflow.md    # Git conventions
    ├── new-project.md     # How to start a new project
    └── docker.md          # Container changes
```

## Scripts

| Script | When | Who |
|--------|------|-----|
| `setup.sh` | Once after clone | You, manually |
| `entrypoint.sh` | Every container start | Docker, automatically |
| `update.sh` | When updating | You, manually |

## AI Runtimes

| Runtime | Status |
|---------|--------|
| Claude Code | ✅ supported |
| Gemini CLI | 🔜 planned |
| OpenCode | 🔜 planned |
| Codex | 🔜 planned |

## Part of TrendForgeAI

mycoforge is the foundation for [TrendForgeAI](https://github.com/TrendForgeAI) projects. The first project built on top of it is a personal AI assistant with memory, model routing, and growing autonomy.

## License

MIT
