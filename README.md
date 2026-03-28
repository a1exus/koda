# Local LLM Inference via llama.cpp

Run [GGUF models](./GGUF.md) locally using llama.cpp with a built-in browser WebUI and an OpenAI-compatible API server.

The main path is the local/dev `Makefile` workflow. Koda also includes a Docker Compose deployment path with Traefik support for more production-style setups.

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

## Primary Environments

Koda is mainly built for the big-boy local inference setups:

- macOS on Apple Silicon
- Linux with NVIDIA GPU

Those are the environments the docs and examples are written around. Other setups may work, but they are not the primary target.

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
make serve ENV=.env-Qwen3.5-27B.Q4_K_M METRICS=1
make serve ENV=.env-gpt-oss-120b.MXFP4 RPC=10.0.0.12:50052
make chat  ENV=.env-gpt-oss-120b.MXFP4 RPC=10.0.0.12:50052
```

## Compose

Koda also ships a Docker Compose path using the official upstream `llama.cpp` container image and Traefik labels.

Files:

- [compose.yaml](./compose.yaml)

Typical flow:

```bash
docker compose --env-file .env up -d
```

Notes:

- the compose path is an alternative to the `Makefile`, not a replacement
- Traefik labels are included by default
- the compose service expects an external Traefik network named `traefik` unless you override `TRAEFIK_NETWORK`
- compose reads the root `.env` file by default
- set `MODEL_DIR` and `MODEL_FILE` in the root `.env` when using compose
- `MODEL_DIR` must be an absolute host path when used with compose
- compose can also load a model profile file via `ENV_FILE=.env-<model>.<quant>`, but that does not replace the need for root `.env` values during compose-time interpolation
- the compose service uses `expose: 8080` only; Traefik is expected to terminate on ports `80` / `443`

Examples:

```bash
docker compose --env-file .env up -d
ENV_FILE=.env-gpt-oss-20b.MXFP4 docker compose --env-file .env up -d
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
- `GPU_LAYERS=-1` tells `llama.cpp` to offload as many layers as possible by default
- `METRICS=0` keeps Prometheus metrics off unless explicitly enabled

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
| `GPU_LAYERS` | `-1` | Offload as many layers as possible to GPU |
| `PROMPT_FORMAT` | `jinja` | `jinja` uses the GGUF's embedded chat template; `template` uses `CHAT_TPL` |
| `CHAT_TPL` | `chatml` | Fallback explicit chat template when `PROMPT_FORMAT=template` |
| `RPC` | empty | Value passed to `llama-server` / `llama-cli` as `--rpc ...` for remote RPC backends |
| `BATCH` | `512` | Prompt processing batch size |
| `UBATCH` | `512` | Micro-batch size used during prompt processing |
| `METRICS` | `0` | Set to `1` to append `--metrics` to `llama-server` |
| `TEMP` | `0.6` | Sampling temperature (chat) |
| `TOP_P` | `0.95` | Top-p sampling (chat) |
| `SERVER_EXTRA_ARGS` | empty | Extra flags appended to `llama-server` |
| `CHAT_EXTRA_ARGS` | empty | Extra flags appended to `llama-cli` |

> **Note on CTX:** Setting `CTX=0` (default) uses the model's native context window. You can manually set this to a lower value to save RAM/VRAM, or a higher value if the model and your hardware support it. Use inline overrides to test different sizes: `make serve ENV=.env-file CTX=16384`.

> **Note on memory:** You do not need to fit the full model in VRAM to get useful performance. If you run into memory pressure, lower `CTX` first and then tune `GPU_LAYERS`, `BATCH`, or `UBATCH`.

## Deployment Notes

- If you expose `llama-server` beyond localhost, put it behind a reverse proxy or API gateway that enforces rate limits, timeouts, and request size limits.
- Enable metrics with `METRICS=1` if you want Prometheus-compatible monitoring from `llama-server`.
- The compose setup includes Traefik labels and joins the external `traefik` network so you can route `llama-server` through an existing reverse proxy stack.

## Bundled Profiles

The bundled profile catalog lives in [PROFILES.md](./PROFILES.md). That file includes:

- the full list of `.env-*` profiles
- model and GGUF source links
- sharding and quantization notes
- practical caveats for heavyweight profiles like `gpt-oss-120b` and `Kimi-K2.5`

## Learning Resources

- [What is GGUF and Why Run Locally?](./GGUF.md)

## Integrations

- [OpenCode Integration](./OPENCODE.md)
- [Tailscale + Koda (via llama.cpp)](./TAILSCALE.md)
- [VS Code Integration](./VSCODE.md)

## License

Model weights: see individual model pages.
