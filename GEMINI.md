# Local LLM Inference Tooling (Koda)

This project provides a standardized environment and set of commands for running GGUF models locally using `llama.cpp` with an OpenAI-compatible API server.

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
| `make serve ENV=<file>` | Starts an OpenAI-compatible HTTP server. |
| `make chat ENV=<file>` | Launches an interactive terminal chat session. |

### Common Overrides

Overrides can be passed inline to any `make` target:
- `PORT=9090`: Change the server port.
- `CTX=0`: Use model's native context size (default).
- `CTX=16384`: Set a specific context window size to save RAM.
- `GPU_LAYERS=0`: Disable GPU offloading.

## Development & Integrations

- **Adding Models:** Create `.env-<name>.<quant>` with `HF_REPO`, `MODEL_DIR`, and `MODEL_FILE`.
- **Integrations:**
  - [OpenCode](./OPENCODE.md)
  - [VS Code](./VSCODE.md) (Continue, Roo Code)
- **Learning:**
  - [GGUF & Local LLMs](./GGUF.md)

## Dependencies

- `llama-server`, `llama-cli`, `hf`, `make`.
