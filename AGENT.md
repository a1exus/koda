# Agent Guide

## What This Project Does

Provides commands and configuration for running GGUF models locally via llama.cpp. No application code — just inference tooling and documentation.

## Key Binaries

Installed via Homebrew at `/opt/homebrew/bin/`:

| Binary | Purpose |
| --- | --- |
| `llama-cli` | Interactive terminal chat |
| `llama-server` | OpenAI-compatible HTTP server |
| `hf` | HuggingFace model downloader |

## Model Location

Models are stored under `~/models/` by default, in a subdirectory per model set via `MODEL_DIR` in the env file.

## Running the Model

Use `make` targets — do not invoke `llama-cli` or `llama-server` directly:

| Target | Description |
| --- | --- |
| `make serve` | Start OpenAI-compatible API server on port 8080 |
| `make chat` | Interactive terminal chat |
| `make download` | Download the model via hf CLI |

All targets require an env file: `make serve ENV=.env-Qwen3.5-27B.Q4_K_M`

Env files are named `.env-<model>.<quant>` — no default. See README.md for all bundled profiles, the full variable reference, and how to add a new model.

## No Build Steps

llama.cpp is pre-built via Homebrew. There is nothing to compile or install beyond what's in the Requirements section of README.md.

## Model Behavior Notes

- Uses ChatML chat template (`--chat-template chatml`)
- Reasoning output appears in `<think>...</think>` blocks before the final answer
- Recommended sampling: `--temp 0.6 --top-p 0.95`
- Context window: up to 262K tokens (use `CTX=` to set what your RAM supports)
