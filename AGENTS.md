# Agent Guide

## What This Project Does

Provides commands and configuration for running GGUF models locally via llama.cpp. No application code — just inference tooling and documentation.

The main user guide is `README.md`. Bundled model catalog and profile-specific caveats live in `PROFILES.md`.

## Key Binaries

Installed via Homebrew at `/opt/homebrew/bin/`:

| Binary | Purpose |
| --- | --- |
| `llama-cli` | Interactive terminal chat |
| `llama-server` | OpenAI-compatible HTTP server |
| `hf` | HuggingFace model downloader |

## Configuration & Defaults

Defaults are defined in the root `.env` file and loaded by the `Makefile`. Model-specific settings are in `.env-<model>.<quant>` files.

| Variable | Default | Description |
| --- | --- | --- |
| `CTX` | `0` | Context window size (`0` = model native) |
| `HOST` | `0.0.0.0` | Server bind address |
| `PORT` | `8080` | Server port |
| `GPU_LAYERS` | `99` | Layers offloaded to GPU |
| `PROMPT_FORMAT` | `jinja` | Use the model's embedded chat template by default |
| `RPC` | empty | Pass through `--rpc` for remote RPC backends |
| `BATCH` | `512` | Prompt batch size |
| `UBATCH` | `512` | Prompt micro-batch size |
| `DOWNLOAD_INCLUDE` | `$(MODEL_FILE)` | Download pattern for sharded GGUF models |

## Running the Model

Use `make` targets — do not invoke `llama-cli` or `llama-server` directly:

| Target | Description |
| --- | --- |
| `make serve` | Start the built-in WebUI and OpenAI-compatible API server on port 8080 |
| `make chat` | Interactive terminal chat |
| `make download` | Download the model via hf CLI |
| `make check` | Verify required binaries are installed and on `PATH` |

`make serve`, `make chat`, and `make download` require an env file: `make serve ENV=.env-Qwen3.5-27B.Q4_K_M`

## No Build Steps

llama.cpp is pre-built via Homebrew. There is nothing to compile or install beyond what's in the Requirements section of README.md.

## Model Behavior Notes

- Uses the GGUF model's embedded Jinja chat template by default (`--jinja`)
- Falls back to an explicit template only when `PROMPT_FORMAT=template`
- Optional RPC offload is exposed via `RPC=<host:port>` and passed through as `--rpc`
- Reasoning output appears in `<think>...</think>` blocks before the final answer
- Recommended sampling: `--temp 0.6 --top-p 0.95`
- `make serve` is the newbie path: it exposes both the browser WebUI and the OAI-compatible API
- Context window: uses native size by default (`CTX=0`). Use `CTX=` as an inline override to adjust for RAM/VRAM constraints.
- Memory tuning: if a model is too heavy, lower `CTX` first, then tune `GPU_LAYERS`, `BATCH`, or `UBATCH`.
- Bundled `gpt-oss-20b` profile: `.env-gpt-oss-20b.MXFP4` using `ggml-org/gpt-oss-20b-GGUF` and `gpt-oss-20b-mxfp4.gguf`
- Bundled `gpt-oss-120b` profile: `.env-gpt-oss-120b.MXFP4` using `ggml-org/gpt-oss-120b-GGUF` and the `gpt-oss-120b-mxfp4-*.gguf` shard set
- Bundled DeepSeek profile: `.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` using `ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF`; this is a practical local stand-in for the full `DeepSeek-R1` release
- Bundled Kimi profile: `.env-Kimi-K2.5.Q4_X` using `AesSedai/Kimi-K2.5-GGUF`; it downloads the `Q4_X/Kimi-K2.5-Q4_X-*.gguf` shard set and serves from the first shard
