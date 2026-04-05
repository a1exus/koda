# Local LLM Inference Tooling (Koda)

This project provides a standardized environment and set of commands for running GGUF models locally using `llama.cpp` with a built-in browser WebUI and an OpenAI-compatible API server.

## Docker Compose Usage

Koda provides a containerized deployment path via `compose.yaml`.

### 1. Default Startup
With the defaults in `.env`, you can check the status or start the default model:
```bash
docker compose ps
docker compose up
```

### 2. Using Model Profiles
To run a specific model profile via Docker Compose, use the `--env-file` flag. Since profiles are stored in the `profiles/` directory, include the path:

```bash
docker compose --env-file profiles/.env-Qwen3.5-27B.Q4_K_M up
```

Note that when using `--env-file`, Docker Compose replaces the default `.env` for variable interpolation. If you need variables from the base `.env` (like `LLAMA_CPP_IMAGE` or default `MODEL_DIR`), you should specify both:

```bash
docker compose --env-file .env --env-file profiles/.env-Qwen3.5-27B.Q4_K_M up
```

### 3. GPU Support in Docker

| Platform | GPU in Docker | Notes |
| :--- | :--- | :--- |
| **NVIDIA (Linux)** | ✅ Full | Requires [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html). `compose.yaml` passes `--gpus all` automatically. |
| **AMD (Linux)** | ✅ Full | Set `LLAMA_CPP_IMAGE=ghcr.io/ggml-org/llama.cpp:server-rocm` in `.env`. |
| **Apple Silicon (macOS)** | ❌ CPU only | Docker on macOS runs in a Linux VM — Metal/GPU is not accessible. Use the native `make` path for full GPU acceleration. |
| **Windows** | ❌ CPU only | Same VM limitation. NVIDIA passthrough is possible via WSL2 but not officially supported here. |

> **Apple Silicon and Windows users:** the `Makefile` path is required to get GPU acceleration. Docker is fine for CPU-only use or quick testing.

### 4. Volume Sharing & Image Overrides
The `compose.yaml` mounts two key directories:
- `/models`: Mapped to `${MODEL_DIR}` from your host.
- `/root/.cache/huggingface`: Mapped to your host's default Hugging Face cache (`~/.cache/huggingface`).

You can override the container name or the image (e.g., for ROCm) via environment variables or by setting them in your `.env` file:
- `CONTAINER_NAME=koda-custom`: Rename the container.
- `LLAMA_CPP_IMAGE=ghcr.io/ggml-org/llama.cpp:server-rocm`: Use the AMD/ROCm image.

**Traefik integration** uses a separate override file so the base `compose.yaml` has no dependency on an external network:

```bash
docker compose -f compose.yaml -f compose.traefik.yml \
  --env-file profiles/.env-<model>.<quant> up -d
```

Assumes Traefik is already running and its Docker network exists. All labels and the network join live in `compose.traefik.yml` — the base `compose.yaml` uses `expose` only and has no Traefik dependency.

## Smart Model Resolution

The `Makefile` resolves model paths without triggering implicit downloads:
1.  **Local Check:** It first looks in `${MODEL_DIR}/${MODEL_FILE}` (with tilde expansion).
2.  **Cache Fallback:** If not found locally, it searches `~/.cache/huggingface/hub` directly via `find` — no network access.

If the model isn't found in either location, `make serve`/`make chat` will fail immediately with a clear error. Run `make download ENV=...` first to fetch the model.

## Key Commands

`make download`, `make serve`, and `make chat` require an `ENV` variable pointing to a model's profile. Koda automatically looks in the `profiles/` directory, so you can omit the path for convenience.

| Command | Description |
| :--- | :--- |
| `make download ENV=<file>` | Downloads the model file from HuggingFace. |
| `make serve ENV=<file>` | Starts the built-in WebUI and OpenAI-compatible HTTP server. |
| `make chat ENV=<file>` | Launches an interactive terminal chat session. |
| `make list` | Lists all available model profiles in `profiles/`. |
| `make select` | Interactively select a model profile (requires `fzf` or `gum`). |
| `make check` | Verifies required binaries are installed and on `PATH`. |
| `make check-model ENV=<file>` | Verifies the model file for the given `ENV` is present. |
| `make smoke-test` | Checks that the server is responding on `HOST:PORT`. |
| `make export-opencode` | Prints OpenCode configuration snippet for current profile. |
| `make export-vscode` | Prints VS Code configuration snippet for current profile. |
| `make cache` | Lists the local Hugging Face model cache (`hf cache ls`). |

### Common Overrides

Overrides can be passed inline to any `make` target:
- `HOST=0.0.0.0`: Bind to all interfaces (default) or `127.0.0.1`.
- `PORT=8080`: Change the server port.
- `CTX=0`: Use model's native context size (default).
- `CTX=16384`: Set a specific context window size to save RAM.
- `GPU_LAYERS=-1`: Offload as many layers as possible to GPU (default).
- `METRICS=1`: Enable `llama-server` metrics.
- `ALIAS=my-model`: Set the model ID reported by the OpenAI-compatible API.
- `API_KEY=my-secret`: Set an API key for the server.
- `TEMP=0.8`: Set sampling temperature (default 0.6).
- `TOP_P=0.95`: Set top-p sampling (default 0.95).
- `BATCH=512`: Set prompt batch size (default 512).
- `UBATCH=512`: Set prompt micro-batch size (default 512).
- `DRAFT_MODEL=/path/to/model`: Use a draft model for speculative decoding.
- `EMBEDDINGS=1`: Enable embeddings support.
- `CTX_SHIFT=1`: Enable context shifting.
- `PROMPT_FORMAT=template`: Use an explicit chat template.
- `CHAT_TPL=chatml`: Specify the template (default chatml) when using `PROMPT_FORMAT=template`.
- `RPC=10.0.0.12:50052`: Pass a remote RPC backend through as `--rpc`.
- `SERVER_EXTRA_ARGS='...'`: Append advanced `llama-server` flags.
- `CHAT_EXTRA_ARGS='...'`: Append advanced `llama-cli` flags.

## Development & Integrations

- **Adding Models:** Create `.env-<name>.<quant>` in the `profiles/` directory with `HF_REPO`, `MODEL_DIR`, `MODEL_FILE`, and an `ALIAS`.
- **Multimodal Support:** If an `mmproj` file exists in the `MODEL_DIR`, Koda automatically detects and uses it.
- **Model Identity:** Use the `ALIAS` variable to set a clean model ID (e.g., `qwen3.5-27b`) for API compatibility across different quants.
- **Docker Memory:** Set `MEM_RESERVE=4g` (default) in `.env` to reserve memory for the container.
- **Integrations:**
  - [OpenCode](./OPENCODE.md)
  - [Tailscale + Koda (via llama.cpp)](./TAILSCALE.md)
  - [VS Code](./VSCODE.md) (Continue, Roo Code)
  - [Cursor](./CURSOR.md) (requires HTTPS — see [CADDY.md](./CADDY.md) for native, [TAILSCALE.md](./TAILSCALE.md) for remote)
- **Learning:**
  - [Bundled Profiles](./profiles/README.md)

## Dependencies

- `llama-server`, `llama-cli`, `hf` (huggingface-cli), `make`.
- `fzf` or `gum` (optional, for `make select`).

## Runtime Defaults

- `PROMPT_FORMAT=jinja` uses the GGUF model's embedded chat template by default.
- `TEMP=0.6` and `TOP_P=0.95` are the default sampling parameters.
- **Reasoning Models:** Output typically appears in `<think>...</think>` blocks.
- `RPC` is empty by default and only applied when explicitly set.
- `METRICS=0` keeps metrics off unless explicitly enabled.
- `BATCH=512` and `UBATCH=512` are conservative server batching defaults.
- `CTX=0` keeps the model's native context window unless explicitly overridden.
- `GPU_LAYERS=-1` offloads all layers to GPU by default.

---