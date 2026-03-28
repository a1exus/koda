# Local LLM Inference via llama.cpp

Run [GGUF models](./GGUF.md) locally using llama.cpp with a built-in browser WebUI and an OpenAI-compatible API server.

## Quick Start

```bash
brew install llama.cpp
brew install huggingface-cli
make check
make download ENV=.env-Qwen3.5-27B.Q4_K_M
make serve    ENV=.env-Qwen3.5-27B.Q4_K_M   # start API server + WebUI
```

When `make serve` is running:

- WebUI: `http://localhost:8080`
- OpenAI-compatible API: `http://localhost:8080/v1/chat/completions`

## Requirements

- `llama.cpp`: [installation docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md)
- `hf` CLI: [installation docs](https://huggingface.co/docs/huggingface_hub/en/guides/cli)

## Commands

```bash
make download ENV=.env-<model>.<quant>
make serve    ENV=.env-<model>.<quant>
make chat     ENV=.env-<model>.<quant>
make check
```

Common overrides:

```bash
make serve ENV=.env-Qwen3.5-27B.Q4_K_M PORT=9090
make serve ENV=.env-gpt-oss-120b.MXFP4 RPC=10.0.0.12:50052
make chat  ENV=.env-gpt-oss-120b.MXFP4 RPC=10.0.0.12:50052
```

## Configuration

Koda uses a simple three-layer configuration model:

1. `.env`
2. `.env-<model>.<quant>`
3. inline overrides in `make`

Create a profile like this:

```bash
HF_REPO=<org>/<repo>-GGUF
MODEL_DIR=$(HOME)/models/<name>
MODEL_FILE=<filename>.gguf
```

If a model is split across multiple GGUF files, also set:

```bash
DOWNLOAD_INCLUDE=<glob-pattern>
```

Bundled profiles and model-specific notes live in [PROFILES.md](./PROFILES.md).

## Defaults

Koda keeps the public interface small and wraps the useful `llama.cpp` defaults for you:

- `PROMPT_FORMAT=jinja` uses the GGUF model's embedded chat template by default
- `CTX=0` uses the model's native context size
- `BATCH=512` and `UBATCH=512` provide a conservative starting point for server throughput
- `GPU_LAYERS=99` offloads as much as possible by default

If a model needs an explicit template, switch to `PROMPT_FORMAT=template` and set `CHAT_TPL=<name>`.

### Runtime variables

Set in the env file or inline. Model-specific variables (`HF_REPO`, `MODEL_DIR`, `MODEL_FILE`) are required for `make download`, `make serve`, and `make chat`, and have no defaults.

| Variable | Default | Description |
| --- | --- | --- |
| `HF_REPO` | — | HuggingFace repo (`org/repo-GGUF`) |
| `MODEL_DIR` | — | Local model directory |
| `MODEL_FILE` | — | Model filename (e.g. `model.Q4_K_M.gguf`) |
| `DOWNLOAD_INCLUDE` | `$(MODEL_FILE)` | File or glob passed to `hf download --include`; useful for sharded GGUF models |
| `CTX` | `0` | Context window size (`0` = model native) |
| `HOST` | `0.0.0.0` | Server bind address |
| `PORT` | `8080` | Server port |
| `GPU_LAYERS` | `99` | Layers offloaded to GPU |
| `PROMPT_FORMAT` | `jinja` | `jinja` uses the GGUF's embedded chat template; `template` uses `CHAT_TPL` |
| `CHAT_TPL` | `chatml` | Fallback explicit chat template when `PROMPT_FORMAT=template` |
| `RPC` | empty | Value passed to `llama-server` / `llama-cli` as `--rpc ...` for remote RPC backends |
| `BATCH` | `512` | Prompt processing batch size |
| `UBATCH` | `512` | Micro-batch size used during prompt processing |
| `TEMP` | `0.6` | Sampling temperature (chat) |
| `TOP_P` | `0.95` | Top-p sampling (chat) |
| `SERVER_EXTRA_ARGS` | empty | Extra flags appended to `llama-server` |
| `CHAT_EXTRA_ARGS` | empty | Extra flags appended to `llama-cli` |

> **Note on CTX:** Setting `CTX=0` (default) uses the model's native context window. You can manually set this to a lower value to save RAM/VRAM, or a higher value if the model and your hardware support it. Use inline overrides to test different sizes: `make serve ENV=.env-file CTX=16384`.

> **Note on memory:** You do not need to fit the full model in VRAM to get useful performance. If you run into memory pressure, lower `CTX` first and then tune `GPU_LAYERS`, `BATCH`, or `UBATCH`.

## Bundled Profiles

The bundled profile catalog lives in [PROFILES.md](./PROFILES.md). That file includes:

- the full list of `.env-*` profiles
- model and GGUF source links
- sharding and quantization notes
- practical caveats for heavyweight profiles like `gpt-oss-120b` and `Kimi-K2.5`

## Integrations

- [OpenCode Integration](./OPENCODE.md)
- [VS Code Integration](./VSCODE.md)
- [What is GGUF and Why Run Locally?](./GGUF.md)

## License

Model weights: see individual model pages.
