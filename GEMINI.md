# Local LLM Inference Tooling (Koda)

This project provides a standardized environment and set of commands for running GGUF models locally using `llama.cpp` with a built-in browser WebUI and an OpenAI-compatible API server.

## Project Overview

- **Core Technology:** `llama.cpp` (`llama-cli` and `llama-server`).
- **Model Distribution:** HuggingFace GGUF models via `hf` CLI.
- **Configuration:** 
  - `Makefile`: Central orchestration.
  - `.env`: Global defaults.
  - `.env-<model>.<quant>`: Model-specific settings.

## Key Commands

All commands require an `ENV` variable pointing to a model's `.env` file.

| Command | Description |
| --- | --- |
| `make download ENV=<file>` | Downloads the model file from HuggingFace. |
| `make serve ENV=<file>` | Starts the built-in WebUI and OpenAI-compatible HTTP server. |
| `make chat ENV=<file>` | Launches an interactive terminal chat session. |
| `make check` | Verifies required binaries are installed and on `PATH`. |

### Common Overrides

Overrides can be passed inline to any `make` target:
- `PORT=9090`: Change the server port.
- `CTX=0`: Use model's native context size (default).
- `CTX=16384`: Set a specific context window size to save RAM.
- `GPU_LAYERS=0`: Disable GPU offloading.
- `PROMPT_FORMAT=template`: Use an explicit chat template instead of the model's embedded Jinja template.
- `RPC=10.0.0.12:50052`: Pass a remote RPC backend through as `--rpc`.
- `SERVER_EXTRA_ARGS='...'`: Append advanced `llama-server` flags without editing the Makefile.

## Development & Integrations

- **Adding Models:** Create `.env-<name>.<quant>` with `HF_REPO`, `MODEL_DIR`, and `MODEL_FILE`. Add `DOWNLOAD_INCLUDE` for sharded GGUF models.
- **Integrations:**
  - [OpenCode](./OPENCODE.md)
  - [VS Code](./VSCODE.md) (Continue, Roo Code)
- **Learning:**
  - [Bundled Profiles](./PROFILES.md)
  - [GGUF & Local LLMs](./GGUF.md)

## Dependencies

- `llama-server`, `llama-cli`, `hf`, `make`.

## Runtime Defaults

- `PROMPT_FORMAT=jinja` uses the GGUF model's embedded chat template by default
- `RPC` is empty by default and only applied when explicitly set
- `BATCH=512` and `UBATCH=512` are conservative server batching defaults
- `CTX=0` keeps the model's native context window unless explicitly overridden
