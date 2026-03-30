# Koda: Local LLM Orchestrator 🎛️

Koda is a lightweight configuration and orchestration layer for running GGUF models locally. It provides a standardized environment for [llama.cpp](https://github.com/ggml-org/llama.cpp), making it easy to download, serve, and chat with models without memorizing complex CLI flags.

---

## 📖 Table of Contents
- [🚀 Quick Start (3 Minutes)](#-quick-start-3-minutes)
- [🛠️ Key Workflows](#️-key-workflows)
- [🐳 Docker Compose](#-docker-compose)
- [🛡️ Security & Privacy](#️-security--privacy)
- [📚 Documentation Index](#-documentation-index)
- [🏗️ Built On](#️-built-on)

---

## 🚀 Quick Start (3 Minutes)

Get up and running on macOS or Linux in just a few commands.

### 1. Install Dependencies
```bash
brew install llama.cpp huggingface-cli
```

### 2. Verify Environment
```bash
make check
```

### 3. Download & Serve
Pick a model profile (see [PROFILES.md](./PROFILES.md)) and start the server:
```bash
make download ENV=.env-Qwen3.5-27B.Q4_K_M
make serve    ENV=.env-Qwen3.5-27B.Q4_K_M
```
*Your server is now live at `http://localhost:8080` with an OpenAI-compatible API at `/v1`.*

---

## 🛠️ Key Workflows

Koda is built around a simple `make` workflow. Every command requires an `ENV` file pointing to a model profile.

| Command | What it does |
| :--- | :--- |
| `make serve` | Starts the **WebUI** and **OpenAI-compatible API** server. |
| `make chat` | Launches an **interactive terminal session** with the model. |
| `make download` | Fetches the model weights from Hugging Face using `hf-cli`. |
| `make check` | Verifies your local environment and required binaries. |

### Common Overrides
You can tune the performance directly from the command line:
```bash
# Change the port or restrict the context window
make serve ENV=.env-Qwen3.5-27B.Q4_K_M PORT=9090 CTX=8192

# Enable metrics for monitoring
make serve ENV=.env-Qwen3.5-27B.Q4_K_M METRICS=1

# Offload to a remote RPC worker (distributed inference)
make serve ENV=.env-gpt-oss-120b.MXFP4 RPC=10.0.0.12:50052
```

---

## 🐳 Docker Compose

For a "set it and forget it" deployment (e.g., on a home server), use the provided `compose.yaml`:

```bash
# Start the default model
docker compose up -d

# Run a specific profile
ENV_FILE=.env-Qwen3.5-27B.Q4_K_M docker compose up -d
```
*See [GEMINI.md](./GEMINI.md) for advanced Docker volume and image mapping notes.*

---

## 🛡️ Security & Privacy

Koda is **local-first**. Your data never leaves your machine. 

- **Privacy:** No telemetry, no tracking, no cloud dependencies.
- **Integrity:** We use [Trivy](https://github.com/aquasecurity/trivy) for automated vulnerability and misconfiguration scanning via GitHub Actions.

---

## 📚 Documentation Index

| File | Purpose |
| :--- | :--- |
| [**PROFILES.md**](./PROFILES.md) | Catalog of bundled models, download links, and hardware notes. |
| [**AGENTS.md**](./AGENTS.md) | Technical reference for developers and AI agents. |
| [**OPENCODE.md**](./OPENCODE.md) | Step-by-step guide for [OpenCode](https://opencode.ai) integration. |
| [**VSCODE.md**](./VSCODE.md) | How to use Koda with VS Code (Copilot BYOM, Continue, Roo). |
| [**TAILSCALE.md**](./TAILSCALE.md) | Private remote access and multi-machine RPC pooling. |
| [**GGUF.md**](./GGUF.md) | An easy-to-read explainer on GGUF and quantization. |

---

## 🏗️ Built On

Koda is a thin layer standing on the shoulders of giants:
- **[llama.cpp](https://github.com/ggml-org/llama.cpp)** — The engine.
- **[huggingface-cli](https://huggingface.co/docs/huggingface_hub/guides/cli)** — The supply line.

---

**Curated by [DimkaNYC](https://huggingface.co/DimkaNYC)** | **[Instagram](https://www.instagram.com/p/DWPRNjmj6R9/)**  
*License: Model weights belong to their respective creators; Koda tooling is open-source.*
