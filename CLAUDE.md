# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Koda is a configuration and orchestration tool for running quantized GGUF models locally via `llama.cpp`. `make serve` exposes the built-in WebUI at `http://localhost:8080` and an OpenAI-compatible HTTP API at `http://localhost:8080/v1`. There is no application code, no build step, and no test suite.

## Commands

```bash
make serve    ENV=.env-<model>.<quant>   # Start built-in WebUI + OpenAI-compatible API server
make chat     ENV=.env-<model>.<quant>   # Interactive terminal chat session
make download ENV=.env-<model>.<quant>   # Download model from HuggingFace
make check                                # Verify required binaries are on PATH
make help                                 # List available targets
```

Runtime variables from `.env` can be overridden inline alongside `ENV`.

**External dependencies (installed via Homebrew):** `llama-server`, `llama-cli`, `hf`

## Architecture

Three-layer configuration system:

1. **`.env`** — Global defaults applied to all commands (`CTX=0`, `HOST=0.0.0.0`, `PORT=8080`, `GPU_LAYERS=99`, `PROMPT_FORMAT=jinja`, `CHAT_TPL=chatml`, `RPC=`, `BATCH=512`, `UBATCH=512`, `TEMP=0.6`, `TOP_P=0.95`)
2. **`.env-<model>.<quant>`** — Model-specific profile defining `HF_REPO`, `MODEL_DIR`, `MODEL_FILE`, and optionally `DOWNLOAD_INCLUDE`
3. **Inline overrides** — Command-line variable assignments override both layers

The Makefile validates that `HF_REPO`, `MODEL_DIR`, and `MODEL_FILE` are set for `serve`, `chat`, and `download`; `check` only verifies local dependencies.

## Bundled Model Profiles

Profiles follow the naming convention `.env-<ModelName>.<Quantization>`. Currently bundled: Qwen3.5 variants at 9B, 27B, and 35B-A3B sizes, plus `gpt-oss-20b`, `gpt-oss-120b`, `DeepSeek-R1-Distill-Qwen-32B`, and `Kimi-K2.5`. Sharded GGUF models use `DOWNLOAD_INCLUDE` to fetch all required parts.

## Key Behaviors

- **Reasoning models**: Output appears in `<think>...</think>` blocks before the final answer
- **Context window**: `CTX=0` uses the model's native window; set explicitly to constrain RAM/VRAM
- **GPU offload**: `GPU_LAYERS=99` offloads all layers; set to `0` to run on CPU only
- **Prompt format**: Koda prefers the GGUF model's embedded Jinja template by default; set `PROMPT_FORMAT=template` to force `CHAT_TPL`
- **RPC offload**: Set `RPC=<host:port>` to pass `--rpc` through to `llama-server` or `llama-cli`
- **Batching**: `BATCH=512` and `UBATCH=512` are conservative server defaults that can be tuned per machine
- **Advanced flags**: Use `SERVER_EXTRA_ARGS` or `CHAT_EXTRA_ARGS` instead of editing the Makefile when you need extra llama.cpp options

## Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Primary user guide, model table, runtime variables reference |
| `AGENTS.md` | Technical reference for agents/automation |
| `GGUF.md` | Explainer: what GGUF is and why to run locally |
| `OPENCODE.md` | Integration with OpenCode IDE |
| `VSCODE.md` | Integration with VS Code (Copilot Chat BYOM, Continue, Roo Cline) |
| `GEMINI.md` | Agent context and instructions for Gemini CLI |
| `CHANGELOG.md` | Version history (Keep a Changelog format) |
