# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Added Caddy to the Built On table in README.md as the HTTPS reverse proxy option for the native `make serve` path

### Changed
- Clarified CURSOR.md HTTPS options table with a "Works with" column — Traefik is Docker-only; Tailscale and Caddy work with both `make serve` and Docker

## [2026-04-03]

### Added
- Added `git clone` as step 1 in the Quick Start section
- Added HTML anchors to OS-specific install sections (`#macos-linux`, `#windows`, `#docker`) for direct linking

### Changed
- Simplified Windows `make` prerequisite to WSL only — removed Git Bash and MSYS2 options; added `sudo apt update && sudo apt install git make` command
- Reduced redundancy across integration guides: replaced CURSOR.md alias table with a link to `profiles/README.md#api-identity-aliases`; collapsed OPENCODE.md and VSCODE.md compatibility notes to a single line linking to README Quick Start

### Added
- Added Gemma 4 E4B-it, 26B-A4B-it, and 31B-it profiles (Q4_K_M/Q8_0/F16) with mmproj multimodal support via `ggml-org`
- Added Nemotron-Nano-3-30B profiles (Q4_K_M/Q8_0) via `ggml-org/Nemotron-Nano-3-30B-A3B-GGUF`
- Updated Recommended Starting Points with Mac Studio hardware tiers (8 GB → 192 GB)
- Added Qwen3.5-27B profiles: `.env-Qwen3.5-27B.Q4_K_M` and `.env-Qwen3.5-27B.Q8_0` using `Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF`
- Added Nemotron 3 Super 120B profile: `.env-Nemotron-3-Super-120B.Q4_K` using `ggml-org/Nemotron-3-Super-120B-GGUF` (69.9 GB, NVIDIA Nemotron H MoE)
- Added Gemma 4 E2B Instruct profiles: `.env-gemma-4-E2B-it.Q8_0` and `.env-gemma-4-E2B-it.F16` using `ggml-org/gemma-4-E2B-it-GGUF`
- Added all remaining bundled profiles: Qwen3.5-9B, Qwen3.5-35B-A3B (HauhauCS), gpt-oss-20b, gpt-oss-120b, DeepSeek-R1-Distill-Qwen-32B, Kimi-K2.5
- Added Nemotron-Nano-3-30B F16 and BF16 profiles (lmstudio-community / unsloth, 63 GB, 2 shards)
- Added Nemotron-3-Super-120B Q4_K_M and Q8_0 profiles (unsloth, 83–129 GB, 3–4 shards)
- Added Qwen3.5-35B-A3B official profiles (`.env-Qwen3.5-35B-A3B-Qwen.Q4_K_M` / `Q8_0`) using `unsloth/Qwen3.5-35B-A3B-GGUF` (22–37 GB); official Alibaba weights alternative to the HauhauCS uncensored variant
- Rewrote `profiles/README.md`: model-grouped layout, quantization guide, per-model variant tables
- Added `ALIAS` support to the `Makefile` and `compose-entrypoint.sh` to allow setting a consistent model ID for the OpenAI-compatible API
- Updated all `.env-*` model profiles with a specific `ALIAS` (e.g., `qwen3.5-27b`) to match external tool configurations
- Added sampling variables `TEMP` (default 0.6) and `TOP_P` (default 0.95) as structured overrides in the `Makefile`
- Added `CHAT_TPL` (default `chatml`) for explicit template control when `PROMPT_FORMAT=template`
- Added `CHAT_EXTRA_ARGS` as an escape hatch for `llama-cli` flags
- Added **Smart Model Resolution** to the `Makefile`: Koda now automatically finds models in the Hugging Face cache if not found in `MODEL_DIR`
- Added `make list` and `make select` (requires `fzf` or `gum`) for interactive model selection
- Added `make export-opencode` and `make export-vscode` to generate configuration snippets
- Added healthcheck and `API_KEY` support to `compose.yaml` and `compose-entrypoint.sh`
- Added curation credit to DimkaNYC across the documentation
- Added `make cache` target (`hf cache ls`) for inspecting the local Hugging Face model cache
- Added `make check-model` guard to `make serve` and `make chat` — fails immediately with a clear error if the model file is not found, preventing cryptic `invalid argument` errors
- Added `CURSOR.md` integration guide — covers HTTPS requirement, setup steps (Traefik lowest-friction), and all 13 model aliases
- Added "Adding a New Model Profile" checklist to `AGENTS.md` listing all 8 files that must be updated in sync
- Added HuggingFace source URL as a comment (`# https://huggingface.co/...`) to the first line of every profile in `profiles/`
- Updated `~/.config/opencode/opencode.json` and `chatLanguageModels.json` to include all 13 model aliases (Gemma 4, Qwen3.5, GPT-OSS, DeepSeek, Nemotron, Kimi-K2.5)

### Changed
- Reorganized documentation: moved `PROFILES.md` to `profiles/README.md` for better directory-level discoverability
- Moved all model profile `.env-*` files into the `profiles/` directory
- Rewrote `README.md` for significantly better human readability, including a new Table of Contents and "Built On" section
- Updated all integration guides (`OPENCODE.md`, `VSCODE.md`, `GEMINI.md`, `AGENTS.md`) with the latest configuration variables and `profiles/` paths
- Updated `VSCODE.md` to document the `chatLanguageModels.json` format (`customoai` vendor) with all 13 individual model entries
- Replaced Mac Studio-specific hardware tier references with generic RAM/VRAM tier descriptions in `profiles/README.md`
- Fixed `make download` to pass each filename in `DOWNLOAD_INCLUDE` as a separate `--include` flag (via `$(foreach)`) — previously all filenames were passed as one quoted string and no files were fetched

### Fixed
- Fixed the `OPENCODE.md` integration guide to use the correct `provider` record and `options` schema required by OpenCode
- Fixed a corrupted `Makefile` that was causing syntax errors during `make serve`
- Fixed `make serve` hanging silently when a model was not yet downloaded — Makefile now searches `~/.cache/huggingface/hub` via `find -L` instead of `hf download`, preventing implicit background downloads for large models
- Fixed Qwen3.5-27B profile filenames (were `Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled.Q*.gguf`, actual filenames are `Qwen3.5-27B.Q*.gguf`); added `mmproj-BF16.gguf` to `DOWNLOAD_INCLUDE` as the repo includes a vision encoder
- Fixed tilde expansion in `Makefile` to ensure robust path handling for all model-related files

## [2026-03-27]

### Added
- Generic llama.cpp local inference setup with OpenAI-compatible API server
- `Makefile` with `serve`, `chat`, and `download` targets; `make` alone shows usage
- Env files named `.env-<model>.<quant>` — no default, always explicit
- Required variables (`HF_REPO`, `MODEL_DIR`, `MODEL_FILE`) must be set via env file — no hardcoded defaults
- opencode provider config at `~/.config/opencode/opencode.json` pointing to `http://127.0.0.1:8080/v1`
- Bundled profiles: Qwen3.5-27B (distilled), Qwen3.5-35B-A3B (Qwen + HauhauCS uncensored), Qwen3.5-9B (HauhauCS uncensored)
- Bundled profiles for `gpt-oss-20b`, `gpt-oss-120b`, `DeepSeek-R1-Distill-Qwen-32B`, and `Kimi-K2.5`
- Added `compose.yaml` as a containerized deployment path using the official upstream `llama.cpp` image
- Added Traefik labels for the Compose deployment path
- Simplified the Compose deployment path to rely on `.env`, `expose`, and the external `traefik` network
- Added Hugging Face cache volume to `compose.yaml` to share models from the default cache location
- Added default `MODEL_DIR` and `MODEL_FILE` to `.env` to fix Docker Compose interpolation errors
- Added GitHub Action workflow for Trivy security scanning of the repository
- Added documentation for `TAILSCALE.md`, `VSCODE.md`, `GGUF.md`, and `AGENTS.md`

### Changed
- `make serve` is now documented as the main entrypoint for both the built-in WebUI and the OpenAI-compatible API
- Default prompt handling now prefers the GGUF model's embedded Jinja template via `PROMPT_FORMAT=jinja`
- Added opinionated server batching defaults with `BATCH=512` and `UBATCH=512`
- Added `SERVER_EXTRA_ARGS` as a structured escape hatch for advanced llama-server flags
- Added `make check` and friendlier missing-binary errors for `llama-server`, `llama-cli`, and `hf`
- Added `DOWNLOAD_INCLUDE` support so `make download` can fetch sharded GGUF models
- Added `RPC` passthrough support so `make serve` and `make chat` can use llama.cpp RPC backends
- Changed default GPU offload from `99` to `-1` to match modern llama.cpp usage better
- Added `METRICS=1` support for exposing llama-server metrics

[Unreleased]: https://github.com/a1exus/koda/compare/2026-04-03...HEAD
[2026-04-03]: https://github.com/a1exus/koda/compare/2026-03-27...2026-04-03
[2026-03-27]: https://github.com/a1exus/koda/releases/tag/2026-03-27
