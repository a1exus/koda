# Agent Guide

## What This Project Does

Provides commands and configuration for running GGUF models locally via llama.cpp. No application code — just inference tooling and documentation.

The main user guide is `README.md`. Bundled model catalog and profile-specific caveats live in `PROFILES.md`.

Treat macOS on Apple Silicon, Linux with NVIDIA GPUs (CUDA), and Linux with AMD GPUs (ROCm/OpenCL) as the primary target environments.

There is also a Compose deployment path in `compose.yaml`, intended for reverse-proxy setups such as Traefik.

## Key Binaries

Installed via Homebrew at `/opt/homebrew/bin/`:

| Binary | Purpose |
| --- | --- |
| `llama-cli` | Interactive terminal chat |
| `llama-server` | OpenAI-compatible HTTP server |
| `hf` | HuggingFace model downloader |

## Configuration & Defaults

Defaults are defined in the root `.env` file and loaded by the `Makefile`. Model-specific settings are in `.env-<model>.<quant>` files located in the `profiles/` directory.

| Variable | Default | Description |
| --- | --- | --- |
| `CTX` | `0` | Context window size (`0` = model native) |
| `HOST` | `0.0.0.0` | Server bind address |
| `PORT` | `8080` | Server port |
| `GPU_LAYERS` | `-1` | Offload as many layers as possible to GPU |
| `PROMPT_FORMAT` | `jinja` | Use the model's embedded chat template by default |
| `RPC` | empty | Pass through `--rpc` for remote RPC backends |
| `BATCH` | `512` | Prompt batch size |
| `UBATCH` | `512` | Prompt micro-batch size |
| `METRICS` | `0` | Set to `1` to append `--metrics` to `llama-server` |
| `ALIAS` | empty | Set the model ID reported by the OpenAI-compatible API |
| `API_KEY` | empty | Set an API key for the server |
| `TEMP` | `0.6` | Sampling temperature |
| `TOP_P` | `0.95` | Top-p sampling |
| `CHAT_TPL` | `chatml` | Explicit chat template (used when `PROMPT_FORMAT=template`) |
| `DRAFT_MODEL`| empty | Path to a draft model for speculative decoding |
| `EMBEDDINGS` | empty | Set to `1` to enable embeddings support |
| `CTX_SHIFT`  | empty | Set to `1` to enable context shifting |
| `DOWNLOAD_INCLUDE` | `$(MODEL_FILE)` | Download pattern for sharded GGUF models |
| `SERVER_EXTRA_ARGS` | empty | Advanced flags for `llama-server` |
| `CHAT_EXTRA_ARGS` | empty | Advanced flags for `llama-cli` |

## Model Identity & API Aliases

Integrating with external tools (OpenCode, VS Code, etc.) requires matching the model ID reported by the API with the ID expected by the client.

- **The Problem:** By default, `llama-server` uses the model's filename as its ID, which is often messy (e.g., `Qwen3.5-27B.Q4_K_M.gguf`).
- **The Solution:** Use the `ALIAS` variable in `.env-<model>.<quant>` files to set a clean, consistent ID (e.g., `qwen3.5-27b`).
- **Grouping:** Group different quantizations (Q4, Q8, etc.) under the same `ALIAS` so that client configurations don't need to change when you swap quants.

## Running the Model

Use `make` targets — do not invoke `llama-cli` or `llama-server` directly:

| Target | Description |
| --- | --- |
| `make serve` | Start the built-in WebUI and OpenAI-compatible API server on port 8080 |
| `make chat` | Interactive terminal chat |
| `make download` | Download the model via hf CLI |
| `make list` | List all profiles in `profiles/` |
| `make select` | Interactively select a profile (requires `fzf` or `gum`) |
| `make check` | Verify required binaries are installed and on `PATH` |

`make serve`, `make chat`, and `make download` require an env file: `make serve ENV=.env-Qwen3.5-27B.Q4_K_M` (Koda prepends `profiles/` for you).

## No Build Steps

llama.cpp is pre-built via Homebrew. There is nothing to compile or install beyond what's in the Requirements section of README.md.

## Model Behavior Notes

- Uses the GGUF model's embedded Jinja chat template by default (`--jinja`)
- Falls back to an explicit template only when `PROMPT_FORMAT=template`
- Optional RPC offload is exposed via `RPC=<host:port>` and passed through as `--rpc`
- Optional metrics exposure is exposed via `METRICS=1` and passed through as `--metrics`
- Reasoning output appears in `<think>...</think>` blocks before the final answer
- Recommended sampling: `--temp 0.6 --top-p 0.95`
- `make serve` is the newbie path: it exposes both the browser WebUI and the OAI-compatible API
- Context window: uses native size by default (`CTX=0`). Use `CTX=` as an inline override to adjust for RAM/VRAM constraints.
- Memory tuning: if a model is too heavy, lower `CTX` first, then tune `GPU_LAYERS`, `BATCH`, or `UBATCH`.
- **Multimodal:** Koda automatically detects `mmproj` files in the model directory and enables multimodal support.
- **Speculative Decoding:** Enabled via `DRAFT_MODEL`.
- **Context Shifting:** Enabled via `CTX_SHIFT=1`.
- Bundled `gpt-oss-20b` profile: `.env-gpt-oss-20b.MXFP4` using `ggml-org/gpt-oss-20b-GGUF` and `gpt-oss-20b-mxfp4.gguf`
- Bundled `gpt-oss-120b` profile: `.env-gpt-oss-120b.MXFP4` using `ggml-org/gpt-oss-120b-GGUF` and the `gpt-oss-120b-mxfp4-*.gguf` shard set
- Bundled DeepSeek profile: `.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` using `ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF`; this is a practical local stand-in for the full `DeepSeek-R1` release
- Bundled Kimi profile: `.env-Kimi-K2.5.Q4_X` using `AesSedai/Kimi-K2.5-GGUF`; it downloads the `Q4_X/Kimi-K2.5-Q4_X-*.gguf` shard set and serves from the first shard
