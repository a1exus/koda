# Agent Guide

## What This Project Does

Provides commands and configuration for running the Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled model locally using llama.cpp. No application code — just inference tooling and documentation.

## Key Binaries

Installed via Homebrew at `/opt/homebrew/bin/`:

| Binary | Purpose |
| --- | --- |
| `llama-cli` | Interactive terminal chat |
| `llama-server` | OpenAI-compatible HTTP server |
| `hf` | HuggingFace model downloader |

## Model Location

Models are stored under `~/models/qwen3.5-27b-distilled/`. The primary file is `Qwen3.5-27B.Q4_K_M.gguf`.

## Running the Model

Use `make` targets — do not invoke `llama-cli` or `llama-server` directly:

| Target | Description |
| --- | --- |
| `make serve` | Start OpenAI-compatible API server on port 8080 |
| `make chat` | Interactive terminal chat |
| `make download` | Download the model via hf CLI |

Switch env files to change models: `make serve ENV=.env.q8`

Configuration is in `.env.q4_k_m` (default) and `.env.q8`. See README.md for all available variables.

## No Build Steps

llama.cpp is pre-built via Homebrew. There is nothing to compile or install beyond what's in the Requirements section of README.md.

## Model Behavior Notes

- Uses ChatML chat template (`--chat-template chatml`)
- Reasoning output appears in `<think>...</think>` blocks before the final answer
- Recommended sampling: `--temp 0.6 --top-p 0.95`
- Context window: up to 262K tokens (use `-c` to set what your RAM supports)
