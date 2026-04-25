# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Koda is a configuration and orchestration tool for running quantized GGUF models locally via `llama.cpp`. `make serve` exposes the built-in WebUI at `http://localhost:8080` and an OpenAI-compatible HTTP API at `http://localhost:8080/v1`. There is no application code, no build step, and no test suite.

There is also a containerized deployment path via `compose.yaml`, built around the official `ghcr.io/ggml-org/llama.cpp` server image.

## Commands

```bash
make serve       ENV=.env-<model>.<quant>   # Start built-in WebUI + OpenAI-compatible API server
make chat        ENV=.env-<model>.<quant>   # Interactive terminal chat session
make download    ENV=.env-<model>.<quant>   # Download model from HuggingFace
make list                                    # List all available model profiles
make select                                  # Interactively select a profile (fzf/gum)
make cache                                   # Show local Hugging Face cache contents
make check                                   # Verify required binaries are on PATH
make check-model ENV=.env-<model>.<quant>   # Verify the model file is present
make smoke-test                              # Check the server is responding on HOST:PORT
make export-opencode ENV=.env-<model>.<quant>  # Print OpenCode config snippet for current profile
make export-vscode   ENV=.env-<model>.<quant>  # Print VS Code config snippet for current profile
```
*Note: Koda automatically prepends `models/` to the `ENV` path if not provided.*

**External dependencies:** `llama-server`, `llama-cli`, `hf` (huggingface-cli), `fzf` or `gum` (optional, for `make select`)

**Windows:** Docker is the recommended path (no local binaries needed). For the native `make` path, use WSL: `sudo apt update && sudo apt install git make`.

**Docker:** `docker compose --env-file models/<org>/<repo>.<quant>.env up -d` — no local binaries needed. GPU works on NVIDIA/AMD Linux only; Apple Silicon and Windows are CPU-only in Docker. For Traefik: `docker compose -f compose.yaml -f compose.traefik.yml --env-file models/... up -d` (assumes Traefik is already running).

## Architecture

Three-layer configuration system:

1. **`.env`** — Global defaults (`CTX=0`, `HOST=0.0.0.0`, `PORT=8080`, `GPU_LAYERS=-1`, etc.)
2. **`models/<org>/<repo>.<quant>.env`** — Model-specific profiles defining `HF_REPO`, `MODEL_DIR`, `MODEL_FILE`, and `ALIAS`.
3. **Inline overrides** — Command-line variable assignments override both layers.

Primary targets are Apple Silicon (macOS), NVIDIA (CUDA), and AMD (ROCm/OpenCL).

## Key Behaviors

- **Smart Model Resolution**: The Makefile looks for models in `MODEL_DIR` first, then searches `~/.cache/huggingface/hub` directly. Never triggers an implicit download — run `make download ENV=...` explicitly if the model is missing.
- **Model Identity (ALIAS)**: Always use `ALIAS` in profiles to ensure consistent IDs for external tools (OpenCode, VS Code).
- **Reasoning models**: Output appears in `<think>...</think>` blocks.
- **Context window**: `CTX=0` uses the model's native window.
- **GPU offload**: `GPU_LAYERS=-1` offloads maximum layers to GPU.
- **Prompt format**: Prefers embedded Jinja templates; set `PROMPT_FORMAT=template` to force `CHAT_TPL`.
- **Docker Compose**: Uses a healthcheck to ensure the model is loaded before reporting "healthy". GPU passthrough works on NVIDIA/AMD Linux; Apple Silicon and Windows are CPU-only in Docker. Traefik integration is via `compose.traefik.yml` override — never add Traefik network/labels to `compose.yaml` directly.
- **API key warning**: `make serve` warns if `HOST` is not `127.0.0.1` and `API_KEY` is empty.
- **Multimodal**: Koda auto-detects `mmproj` files in `MODEL_DIR`. For multimodal profiles, `DOWNLOAD_INCLUDE` fetches both the model and mmproj in one `make download` call.
- **Bundled profiles**: See `models/README.md` for the full catalog (Gemma 4, Qwen3.5, Qwen3.6, GPT-OSS, DeepSeek, Nemotron, GLM, MiniMax, Kimi-K2.5). Hardware tiers from 4 GB to ~584 GB are covered.

## Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Primary user guide, Quick Start, and TOC. |
| `models/README.md` | Bundled model catalog and profile-specific notes. |
| `AGENTS.md` | Technical reference for developers and AI agents. |
| `GEMINI.md` | Detailed Docker usage and agent-specific instructions. |
| `OPENCODE.md` | Verified configuration guide for OpenCode. |
| `VSCODE.md` | Integration guide for VS Code extensions. |
| `CURSOR.md` | Integration guide for Cursor (HTTPS required — Caddy, Tailscale, or Traefik). |
| `HERMES-AGENT.md` | Integration guide for Hermes Agent (CLI, messaging gateway). |
| `PI-CODING-AGENT.md` | Integration guide for Pi Coding Agent. |
| `CADDY.md` | HTTPS termination for native `make serve` (local/LAN without Tailscale). |
| `TAILSCALE.md` | Guide for private access and multi-machine RPC pooling. |
| `CONTRIBUTING.md` | How to add a model profile and pre-PR checklist. |
| `MCP-PLAYWRIGHT.md` | Playwright MCP browser tools for OpenCode, Cursor, and VS Code. |
| `CHANGELOG.md` | Version history (CalVer, Keep a Changelog format). |
