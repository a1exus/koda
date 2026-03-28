# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Koda is a configuration and orchestration tool for running quantized GGUF models locally via `llama.cpp`. It exposes an OpenAI-compatible HTTP API at `http://localhost:8080/v1`. There is no application code, no build step, and no test suite.

## Commands

```bash
make serve    ENV=.env-<model>.<quant>   # Start OpenAI-compatible API server (port 8080)
make chat     ENV=.env-<model>.<quant>   # Interactive terminal chat session
make download ENV=.env-<model>.<quant>   # Download model from HuggingFace
make help                                 # List available targets
```

Runtime variables from `.env` can be overridden inline alongside `ENV`.

**External dependencies (installed via Homebrew):** `llama-server`, `llama-cli`, `hf`

## Architecture

Three-layer configuration system:

1. **`.env`** — Global defaults applied to all commands (`CTX=0`, `HOST=0.0.0.0`, `PORT=8080`, `GPU_LAYERS=99`, `CHAT_TPL=chatml`, `TEMP=0.6`, `TOP_P=0.95`)
2. **`.env-<model>.<quant>`** — Model-specific profile defining `HF_REPO`, `MODEL_DIR`, `MODEL_FILE`
3. **Inline overrides** — Command-line variable assignments override both layers

The Makefile validates that `HF_REPO`, `MODEL_DIR`, and `MODEL_FILE` are always set before running any target.

## Bundled Model Profiles

Profiles follow the naming convention `.env-<ModelName>.<Quantization>`. Currently bundled: Qwen3.5 variants at 9B, 27B, and 35B-A3B sizes, in Q4_K_M and Q8_0 quantizations. The 27B is a Claude 4.6 Opus reasoning distillation; 9B and 35B-A3B use uncensored HauhauCS variants alongside official Qwen variants.

## Key Behaviors

- **Reasoning models**: Output appears in `<think>...</think>` blocks before the final answer
- **Context window**: `CTX=0` uses the model's native window; set explicitly to constrain RAM/VRAM
- **GPU offload**: `GPU_LAYERS=99` offloads all layers; set to `0` to run on CPU only
- **Chat template**: All bundled models use ChatML (`--chat-template chatml`)

## Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Primary user guide, model table, runtime variables reference |
| `AGENT.md` | Technical reference for agents/automation |
| `GGUF.md` | Explainer: what GGUF is and why to run locally |
| `OPENCODE.md` | Integration with OpenCode IDE |
| `VSCODE.md` | Integration with VS Code (Copilot Chat BYOM, Continue, Roo Cline) |
| `GEMINI.md` | Agent context and instructions for Gemini CLI |
| `CHANGELOG.md` | Version history (Keep a Changelog format) |
