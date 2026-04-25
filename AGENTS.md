# Agent Guide

## What This Project Does

Provides commands and configuration for running GGUF models locally via llama.cpp. No application code — just inference tooling and documentation.

The main user guide is `README.md`. Bundled model catalog and profile-specific caveats live in `models/README.md`.

Treat macOS on Apple Silicon, Linux with NVIDIA GPUs (CUDA), and Linux with AMD GPUs (ROCm/OpenCL) as the primary target environments.

There is also a Compose deployment path in `compose.yaml`. The base file uses `expose` only — no external network dependency. Traefik integration is provided via `compose.traefik.yml` as a separate override, joined with `-f compose.yaml -f compose.traefik.yml`. Never add the Traefik network or labels directly to `compose.yaml`.

## Key Binaries

**macOS / Linux** — installed via Homebrew:

| Binary | Purpose |
| --- | --- |
| `llama-cli` | Interactive terminal chat |
| `llama-server` | OpenAI-compatible HTTP server |
| `hf` | HuggingFace model downloader |

**Windows** — Docker is the recommended path (see `compose.yaml` and `GEMINI.md`). For the native `make` path, use WSL:
```bash
sudo apt update && sudo apt install git make
```
Then install `llama-server`, `llama-cli`, and `hf` inside WSL (e.g. [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux) or build llama.cpp from source).

**Docker** — no binaries required. See `compose.yaml` and `GEMINI.md`. GPU passthrough works on NVIDIA/AMD Linux only; Apple Silicon and Windows are CPU-only in Docker.

## Configuration & Defaults

Defaults are defined in the root `.env` file and loaded by the `Makefile`. Model-specific settings are in `<repo>.<quant>.env` files located in the `models/<org>/` directory.

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
| `MEM_RESERVE` | `4g` | Docker Compose only — memory reservation for the container |

## Model Identity & API Aliases

Integrating with external tools (OpenCode, VS Code, etc.) requires matching the model ID reported by the API with the ID expected by the client.

- **The Problem:** By default, `llama-server` uses the model's filename as its ID, which is often messy (e.g., `Qwen3.5-27B.Q4_K_M.gguf`).
- **The Solution:** Use the `ALIAS` variable in `models/<org>/<repo>.<quant>.env` files to set a clean, consistent ID (e.g., `qwen3.5-27b`).
- **Grouping:** Group different quantizations (Q4, Q8, etc.) under the same `ALIAS` so that client configurations don't need to change when you swap quants.

## Smart Model Resolution

The `Makefile` dynamically resolves the `MODEL` path:
- **Local:** Checks `$(MODEL_DIR)/$(MODEL_FILE)` first (handles `~` expansion).
- **Cache:** Falls back to the Hugging Face cache (`~/.cache/huggingface/hub`) via `find` if the local file is missing — no network access, no implicit download.
- **Verification:** Always use `make check-model ENV=...` to verify path resolution before execution.

## Running the Model

Use `make` targets — do not invoke `llama-cli` or `llama-server` directly:

| Target | Description |
| --- | --- |
| `make serve` | Start the built-in WebUI and OpenAI-compatible API server on port 8080 |
| `make chat` | Interactive terminal chat |
| `make download` | Download the model via hf CLI |
| `make list` | List all profiles in `models/` |
| `make select` | Interactively select a profile (requires `fzf` or `gum`) |
| `make cache` | Show what models are in the local Hugging Face cache |
| `make check` | Verify required binaries are installed and on `PATH` |
| `make check-model` | Verify the model file for the given `ENV` is present |
| `make smoke-test` | Hit `/health` on `HOST:PORT` and verify the server is responding |
| `make export-opencode` | Print OpenCode provider config snippet for the current profile |
| `make export-vscode` | Print VS Code `customOAIModels` snippet for the current profile |

`make serve`, `make chat`, and `make download` require an env file: `make serve ENV=models/ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env` (Koda prepends `models/` for you).

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
- **Multimodal:** Koda automatically detects `mmproj` files in the model directory and enables multimodal support. For profiles that include an mmproj, `DOWNLOAD_INCLUDE` is set to fetch both the model and mmproj in one `make download` call.
- **Speculative Decoding:** Enabled via `DRAFT_MODEL`.
- **Context Shifting:** Enabled via `CTX_SHIFT=1`.

## Validation & CI

To maintain repository integrity, use these tools before committing changes:

| Tool | Purpose | Command |
| --- | --- | --- |
| `validate-profiles.sh` | Checks profiles for required fields and duplicate aliases | `sh scripts/validate-profiles.sh` |
| `lychee` | Fast, local link checker for Markdown files | `lychee --exclude 'mailto:' --exclude 'localhost' '**/*.md'` |
| `shellcheck` | Lints shell scripts in `scripts/` | `shellcheck scripts/*.sh` |

**GitHub Actions:**
- `validate-profiles.yml`: Runs on every PR to ensure profile consistency.
- `link-check.yml`: Nightly and PR-based link validation using lychee.
- `shellcheck.yml`: Automated linting for scripts.
- `trivy-scan.yml`: Security scanning for vulnerabilities and misconfigurations.

## Adding a New Model Profile

When adding a new `models/<org>/<repo>.<quant>.env` profile, update these files to keep everything in sync:

1. **`models/README.md`** — add a subsection under the appropriate model family with a variant table, ALIAS, and Sources links
2. **`AGENTS.md`** — add a row to the Bundled Profiles table below
3. **`OPENCODE.md`** — add an entry to the `models` block in the JSON snippet
4. **`VSCODE.md`** — add an entry to the `chatLanguageModels.json` snippet
5. **`CURSOR.md`** — no edit needed; alias list links to `models/README.md` automatically
5b. **`HERMES-AGENT.md`** — no edit needed; tool-calling table covers model families, not individual aliases
5c. **`PI-CODING-AGENT.md`** — add or remove entries from the `models` array in the `models.json` snippet
6. **`CHANGELOG.md`** — add an entry under `[Unreleased] > Added`
7. **`~/.config/opencode/opencode.json`** — add the alias to the live config *(local only — not part of the PR)*
8. **`~/Library/Application Support/Code - Insiders/User/chatLanguageModels.json`** — add the model entry *(local only — not part of the PR)*

## Bundled Profiles

Full catalog with sizes and hardware notes lives in `models/README.md`. Summary:

| Profile | HF Repo | Size | Notes |
| --- | --- | --- | --- |
| `bartowski/Qwen_Qwen3.5-0.8B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/Qwen_Qwen3.5-0.8B-GGUF` | 0.56–0.81 GB | Multimodal (mmproj) |
| `bartowski/Qwen_Qwen3.5-2B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/Qwen_Qwen3.5-2B-GGUF` | 1.33–2.02 GB | Multimodal (mmproj) |
| `bartowski/Qwen_Qwen3.5-4B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/Qwen_Qwen3.5-4B-GGUF` | 2.87–4.49 GB | Multimodal (mmproj) |
| `HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-GGUF.Q4_K_M.env` / `Q8_0.env` | `HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive` | ~5–10 GB | Multimodal (mmproj) |
| `bartowski/Qwen_Qwen3.5-9B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/Qwen_Qwen3.5-9B-GGUF` | 5.89–9.55 GB | Official, multimodal (mmproj) |
| `Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q2_K.env` / `Q3_K_M.env` / `Q4_K_M.env` / `Q8_0.env` | `Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF` | 10–29 GB | Reasoning distill, multimodal (mmproj) |
| `bartowski/Qwen_Qwen3.5-27B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/Qwen_Qwen3.5-27B-GGUF` | 17.13–28.67 GB | Official, multimodal (mmproj) |
| `HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive-GGUF.Q4_K_M.env` / `Q8_0.env` | `HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive` | ~20–37 GB | MoE, multimodal (mmproj) |
| `unsloth/Qwen3.5-35B-A3B-GGUF.Q4_K_M.env` / `Q8_0.env` | `unsloth/Qwen3.5-35B-A3B-GGUF` | 22–37 GB | MoE, official Qwen weights |
| `bartowski/Qwen_Qwen3.6-27B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/Qwen_Qwen3.6-27B-GGUF` | 17.53–28.67 GB | Multimodal (mmproj), hybrid arch, 262k ctx |
| `bartowski/Qwen_Qwen3.6-35B-A3B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/Qwen_Qwen3.6-35B-A3B-GGUF` | 21.39–36.91 GB | MoE, multimodal (mmproj), 262k ctx |
| `bartowski/Qwen_Qwen3.5-122B-A10B-GGUF.IQ2_XXS.env` | `bartowski/Qwen_Qwen3.5-122B-A10B-GGUF` | 33.80 GB | MoE, multimodal (mmproj) |
| `bartowski/Qwen_Qwen3.5-122B-A10B-GGUF.Q4_K_M.env` | `bartowski/Qwen_Qwen3.5-122B-A10B-GGUF` | 74.99 GB (2 shards) | MoE, multimodal (mmproj) |
| `bartowski/Qwen_Qwen3.5-397B-A17B-GGUF.IQ2_XXS.env` | `bartowski/Qwen_Qwen3.5-397B-A17B-GGUF` | 106.57 GB (3 shards) | MoE, multimodal (mmproj) |
| `bartowski/Qwen_Qwen3.5-397B-A17B-GGUF.Q4_K_M.env` | `bartowski/Qwen_Qwen3.5-397B-A17B-GGUF` | 241.87 GB (7 shards) | MoE, multimodal (mmproj) |
| `ggml-org/gemma-4-E2B-it-GGUF.Q8_0.env` / `F16.env` | `ggml-org/gemma-4-E2B-it-GGUF` | 5–9 GB | Multimodal (mmproj) |
| `ggml-org/gemma-4-E4B-it-GGUF.Q4_K_M.env` / `Q8_0.env` / `F16.env` | `ggml-org/gemma-4-E4B-it-GGUF` | 5–15 GB | Multimodal (mmproj) |
| `ggml-org/gemma-4-26B-A4B-it-GGUF.Q4_K_M.env` / `Q8_0.env` / `F16.env` | `ggml-org/gemma-4-26B-A4B-it-GGUF` | 17–51 GB | MoE, multimodal (mmproj) |
| `ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env` / `Q8_0.env` / `F16.env` | `ggml-org/gemma-4-31B-it-GGUF` | 19–61 GB | Multimodal (mmproj) |
| `ggml-org/gpt-oss-20b-GGUF.MXFP4.env` | `ggml-org/gpt-oss-20b-GGUF` | 12.1 GB | Harmony-style prompting |
| `ggml-org/gpt-oss-120b-GGUF.MXFP4.env` | `ggml-org/gpt-oss-120b-GGUF` | 63.4 GB | 3 shards, harmony-style |
| `ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF.Q8_0.env` | `ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF` | 34.8 GB | Reasoning, `<think>` blocks |
| `nvidia/NVIDIA-Nemotron-3-Nano-4B-GGUF.Q4_K_M.env` | `nvidia/NVIDIA-Nemotron-3-Nano-4B-GGUF` | 2.84 GB | Official NVIDIA GGUF, reasoning, 1M ctx |
| `bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF` | 25–34 GB | Cascade-2, reasoning, Mamba-2 MoE |
| `ggml-org/Nemotron-Nano-3-30B-A3B-GGUF.Q4_K_M.env` / `Q8_0.env` | `ggml-org/Nemotron-Nano-3-30B-A3B-GGUF` | 25–34 GB | Mamba-2 MoE hybrid |
| `lmstudio-community/Nemotron-Nano-3-30B-GGUF.F16.env` / `BF16.env` | `lmstudio-community` / `unsloth` | 63 GB | Mamba-2 MoE hybrid, 2 shards |
| `ggml-org/Nemotron-3-Super-120B-GGUF.Q4_K.env` | `ggml-org/Nemotron-3-Super-120B-GGUF` | 69.9 GB | Mamba-2 MoE hybrid |
| `unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF.Q4_K_M.env` / `Q8_0.env` | `unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF` | 83–129 GB | Mamba-2 MoE hybrid, 3–4 shards |
| `bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF` | 1.1–1.9 GB | Reasoning distill, `<think>` blocks |
| `bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF` | 4.7–8.1 GB | Reasoning distill |
| `bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF` | 4.9–8.5 GB | Reasoning distill, Llama base |
| `bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF` | 9–15.7 GB | Reasoning distill |
| `bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF.Q4_K_M.env` | `bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF` | 19.85 GB | Reasoning distill |
| `ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF.Q8_0.env` | `ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF` | 34.8 GB | Reasoning distill |
| `bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF.Q4_K_M.env` / `Q8_0.env` | `bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF` | 43–75 GB | Reasoning distill, Q8_0 is 2 shards |
| `unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF.Q4_K_M.env` / `Q8_0.env` | `unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF` | 5–8.7 GB | Updated R1 distill on Qwen3-8B base |
| `unsloth/DeepSeek-R1-GGUF-UD.UD-IQ1_S.env` | `unsloth/DeepSeek-R1-GGUF-UD` | 185 GB | 4 shards, 192 GB+ unified memory |
| `unsloth/DeepSeek-R1-GGUF-UD.UD-IQ2_XXS.env` | `unsloth/DeepSeek-R1-GGUF-UD` | 216 GB | 5 shards, recommended minimum quality |
| `unsloth/DeepSeek-R1-GGUF-UD.UD-Q2_K_XL.env` | `unsloth/DeepSeek-R1-GGUF-UD` | 250 GB | 6 shards, best quality under 256 GB |
| `bartowski/DeepSeek-R1-GGUF.Q3_K_M.env` | `bartowski/DeepSeek-R1-GGUF` | 319 GB | 9 shards, 3-bit sweet spot |
| `lmstudio-community/DeepSeek-R1-0528-GGUF.Q4_K_M.env` | `lmstudio-community/DeepSeek-R1-0528-GGUF` | ~409 GB | 11 shards, updated 671B |
| `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.IQ2_XXS.env` | `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF` | 54.73 GB | 2 shards, 456B MoE agentic successor, reasoning |
| `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.Q4_K_M.env` | `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF` | 138.59 GB | 4 shards, default recommended |
| `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.Q6_K.env` | `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF` | 187.81 GB | 5 shards, near-lossless |
| `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.IQ2_XXS.env` | `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF` | 60.85 GB | 2 shards, 230B MoE, reasoning |
| `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.Q4_K_M.env` | `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF` | 138.81 GB | 4 shards, default recommended |
| `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.Q6_K.env` | `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF` | 197.05 GB | 5 shards, near-lossless |
| `bartowski/zai-org_GLM-4.7-Flash-GGUF.Q4_K_M.env` | `bartowski/zai-org_GLM-4.7-Flash-GGUF` | 18.47 GB | Single file, 30B-A3B MoE, reasoning |
| `bartowski/zai-org_GLM-4.7-Flash-GGUF.Q8_0.env` | `bartowski/zai-org_GLM-4.7-Flash-GGUF` | 31.84 GB | Single file, near-lossless |
| `bartowski/zai-org_GLM-4.7-GGUF.IQ2_XXS.env` | `bartowski/zai-org_GLM-4.7-GGUF` | 88.79 GB | 3 shards, 358B MoE, reasoning |
| `bartowski/zai-org_GLM-4.7-GGUF.Q4_K_M.env` | `bartowski/zai-org_GLM-4.7-GGUF` | 218.52 GB | 6 shards, default recommended |
| `unsloth/GLM-5.1-GGUF.UD-IQ1_M.env` | `unsloth/GLM-5.1-GGUF` | ~206 GB | 6 shards, 192 GB+ unified memory, reasoning |
| `unsloth/GLM-5.1-GGUF.UD-IQ2_XXS.env` | `unsloth/GLM-5.1-GGUF` | ~221 GB | 6 shards, recommended minimum quality |
| `unsloth/GLM-5.1-GGUF.UD-Q2_K_XL.env` | `unsloth/GLM-5.1-GGUF` | ~252 GB | 7 shards, best quality under 256 GB |
| `AesSedai/Kimi-K2.5-GGUF.Q4_X.env` | `AesSedai/Kimi-K2.5-GGUF` | ~584 GB | 14 shards, extreme scale |
