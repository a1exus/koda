# Local LLM Inference via llama.cpp

Run GGUF models locally with `llama.cpp`.

Koda gives you:

- a simple local/dev `Makefile` workflow
- a built-in browser WebUI and OpenAI-compatible API via `llama-server`
- a Docker Compose deployment path with Traefik support

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
make serve ENV=.env-Qwen3.5-27B.Q4_K_M ALIAS=my-model
make serve ENV=.env-gpt-oss-120b.MXFP4 RPC=10.0.0.12:50052,10.0.0.13:50052
make chat  ENV=.env-gpt-oss-120b.MXFP4 RPC=10.0.0.12:50052,10.0.0.13:50052
```

## Docker Compose

The `compose.yaml` provides a containerized path. To check status:
```bash
docker compose ps
```

To run a specific model profile:
```bash
ENV_FILE=.env-Qwen3.5-27B.Q4_K_M docker compose up
```
See [GEMINI.md](./GEMINI.md) for detailed Docker usage instructions and volume mapping notes.

## Primary Environments

Koda is mainly built for:

- macOS on Apple Silicon
- Linux with NVIDIA GPU (via CUDA)
- Linux with AMD GPU (via ROCm/OpenCL)

## Ecosystem & Alternatives

Koda is a thin wrapper designed for a `Makefile` and `docker compose` workflow. If you are looking for a more "app-like" experience or different integration patterns, the [llama.cpp](https://github.com/ggml-org/llama.cpp) ecosystem is vast:

- **[Ollama](https://ollama.com/)** — the most popular CLI and local daemon for running GGUF models with a simple `run` command.
- **[Jan.ai](https://jan.ai/)** — an open-source, local-first desktop chat application (cross-platform).
- **[LM Studio](https://lmstudio.ai/)** — a polished desktop GUI for discovering and running GGUF models (proprietary).
- **[KoboldCPP](https://github.com/LostRuins/koboldcpp)** — a feature-rich GGUF server often used for creative writing and roleplay.
- **[LocalAI](https://localai.io/)** — a multi-backend containerized API server that supports GGUF, Whisper, and more.
- **[GPT4All](https://gpt4all.io/)** — an easy-to-use desktop chat client with a focus on privacy and local documents.

## Docs

Use the docs below depending on what you need:

| File | Purpose |
| --- | --- |
| [PROFILES.md](./PROFILES.md) | Bundled model profiles, source links, and profile-specific notes |
| [GGUF.md](./GGUF.md) | What GGUF is and why local inference is useful |
| [TAILSCALE.md](./TAILSCALE.md) | Tailscale, private access, and multi-machine RPC pooling |
| [OPENCODE.md](./OPENCODE.md) | OpenCode integration |
| [VSCODE.md](./VSCODE.md) | VS Code integration |
| [CHANGELOG.md](./CHANGELOG.md) | Project history |

## Notes

- The local/dev path is the `Makefile`.
- The deployment path is [compose.yaml](./compose.yaml).
- Compose is Traefik-oriented and expects the external `traefik` network.
- Koda uses `.env` for defaults and `.env-<model>.<quant>` for model profiles.
- Heavy models and sharded GGUF notes live in [PROFILES.md](./PROFILES.md).

## License

Model weights: see individual model pages.

---

Curated by **[DimkaNYC](https://huggingface.co/DimkaNYC)**.
