# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Koda is a configuration and orchestration tool for running quantized GGUF models locally via `llama.cpp`. `make serve` exposes the built-in WebUI at `http://localhost:8080` and an OpenAI-compatible HTTP API at `http://localhost:8080/v1`. There is no application code, no build step, and no test suite.

There is also a containerized deployment path via `compose.yaml`, built around the official `ghcr.io/ggml-org/llama.cpp` server image.

## Commands

```bash
make serve    ENV=.env-<model>.<quant>   # Start built-in WebUI + OpenAI-compatible API server
make chat     ENV=.env-<model>.<quant>   # Interactive terminal chat session
make download ENV=.env-<model>.<quant>   # Download model from HuggingFace
make list                                 # List all available model profiles
make select                               # Interactively select a profile (fzf/gum)
make check                                # Verify required binaries are on PATH
make export-opencode ENV=.env-<model>.<quant>  # Print OpenCode config snippet for current profile
make export-vscode   ENV=.env-<model>.<quant>  # Print VS Code config snippet for current profile
```
*Note: Koda automatically prepends `profiles/` to the `ENV` path if not provided.*

**External dependencies:** `llama-server`, `llama-cli`, `hf` (huggingface-cli), `fzf` or `gum` (optional, for `make select`)

## Architecture

Three-layer configuration system:

1. **`.env`** — Global defaults (`CTX=0`, `HOST=0.0.0.0`, `PORT=8080`, `GPU_LAYERS=-1`, etc.)
2. **`profiles/.env-<model>.<quant>`** — Model-specific profiles defining `HF_REPO`, `MODEL_DIR`, `MODEL_FILE`, and `ALIAS`.
3. **Inline overrides** — Command-line variable assignments override both layers.

Primary targets are Apple Silicon (macOS), NVIDIA (CUDA), and AMD (ROCm/OpenCL).

## Key Behaviors

- **Smart Model Resolution**: The Makefile looks for models in `MODEL_DIR` first, then falls back to the default Hugging Face cache using `hf download`.
- **Model Identity (ALIAS)**: Always use `ALIAS` in profiles to ensure consistent IDs for external tools (OpenCode, VS Code).
- **Reasoning models**: Output appears in `<think>...</think>` blocks.
- **Context window**: `CTX=0` uses the model's native window.
- **GPU offload**: `GPU_LAYERS=-1` offloads maximum layers to GPU.
- **Prompt format**: Prefers embedded Jinja templates; set `PROMPT_FORMAT=template` to force `CHAT_TPL`.
- **Docker Compose**: Uses a healthcheck to ensure the model is loaded before reporting "healthy".

## Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Primary user guide, Quick Start, and TOC. |
| `profiles/README.md` | Bundled model catalog and profile-specific notes. |
| `AGENTS.md` | Technical reference for developers and AI agents. |
| `GEMINI.md` | Detailed Docker usage and agent-specific instructions. |
| `OPENCODE.md` | Verified configuration guide for OpenCode. |
| `VSCODE.md` | Integration guide for VS Code extensions. |
| `TAILSCALE.md` | Guide for private access and multi-machine RPC pooling. |
| `GGUF.md` | Explainer: what GGUF is and why to run locally. |
| `CHANGELOG.md` | Version history (Keep a Changelog format). |
