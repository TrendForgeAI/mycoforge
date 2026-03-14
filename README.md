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

## Installation
```bash
git clone git@github.com:TrendForgeAI/mycoforge.git
cd mycoforge
cp .env.example .env
nano .env          # add your API keys
docker compose build
```

**First-time login (Claude Pro/Max):**
```bash
docker compose run --rm -it mycoforge claude auth login
```

**Or with API key:** just set `ANTHROPIC_API_KEY` in `.env` — no login needed.

## Usage

**Test that everything works:**
```bash
docker compose run --rm mycoforge claude -p "Say: mycoforge works"
```

**Start an interactive session:**
```bash
docker compose run --rm -it mycoforge claude
```

## Project structure
```
mycoforge/
├── CLAUDE.md             # Project context for Claude Code
├── Dockerfile            # Container definition
├── docker-compose.yml    # Deployment
├── entrypoint.sh         # First-run initialization
├── .env.example          # Required environment variables
├── claude/               # Claude Code configuration (local, not in Git)
└── workspace/            # Your projects live here
```

## Updating
```bash
git pull
docker compose build
```

That's it. The container rebuilds from the updated definition.

## AI Runtimes

| Runtime | Status |
|---|---|
| Claude Code | ✅ supported |
| Gemini CLI | 🔜 planned |
| OpenCode | 🔜 planned |
| Codex | 🔜 planned |

## Part of TrendForgeAI

mycoforge is the foundation for [TrendForgeAI](https://github.com/TrendForgeAI) projects. The first project built on top of it is a personal AI assistant with memory, model routing, and growing autonomy.

## License

MIT
