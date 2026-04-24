# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Calendar Versioning](https://calver.org/) (`YYYY-MM-DD`).

## [Unreleased]

### Added
- Added Playwright MCP (browser tools) section to `OPENCODE.md` — configuration guide for `@playwright/mcp` with headed/headless modes and vision capabilities
- Added Qwen3.6-27B profiles: `Q4_K_M` (17.53 GB), `Q8_0` (28.67 GB) via `bartowski/Qwen_Qwen3.6-27B-GGUF`; dense 27B, multimodal (mmproj), hybrid Gated DeltaNet + Gated Attention architecture, 262k native context (1M with YaRN), reasoning with thinking modes, tool calling
- Added Qwen3.6-35B-A3B profiles: `Q4_K_M` (21.39 GB), `Q8_0` (36.91 GB) via `bartowski/Qwen_Qwen3.6-35B-A3B-GGUF`; MoE (3B active), multimodal (mmproj), 262k native context, agentic coding focus
- Added Recommended Hardware section to README with hardware-tier table (DGX Spark, Apple Silicon, multi-GPU)
- Added GLM-4.7-Flash profiles: `Q4_K_M` (18.47 GB), `Q8_0` (31.84 GB) via `bartowski/zai-org_GLM-4.7-Flash-GGUF`; 30B-A3B MoE, 202k context, reasoning model
- Added GLM-4.7 profiles: `IQ2_XXS` (88.79 GB, 3 shards), `Q4_K_M` (218.52 GB, 6 shards) via `bartowski/zai-org_GLM-4.7-GGUF`; 358B MoE (~32B active), 202k context, reasoning model
- Added GLM-5.1 profiles: `UD-IQ1_M` (~206 GB, 6 shards), `UD-IQ2_XXS` (~221 GB, 6 shards), `UD-Q2_K_XL` (~252 GB, 7 shards) via `unsloth/GLM-5.1-GGUF`; 754B MoE with DSA, 202k context, reasoning model
- Added MiniMax-M2.1 profiles: `IQ2_XXS` (54.73 GB, 2 shards), `Q4_K_M` (138.59 GB, 4 shards), `Q6_K` (187.81 GB, 5 shards) via `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF`; 456B MoE (46B active), 192k context, agentic successor to M2.7
- Added MiniMax-M2.7 profiles: `IQ2_XXS` (60.85 GB, 2 shards), `Q4_K_M` (138.81 GB, 4 shards), `Q6_K` (197.05 GB, 5 shards) via `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF`; 230B MoE (10B active), 192k context, reasoning model
- Added Qwen3.5 official instruct profiles via `bartowski`: 0.8B (`Q4_K_M`/`Q8_0`), 2B (`Q4_K_M`/`Q8_0`), 4B (`Q4_K_M`/`Q8_0`), 9B-Qwen (`Q4_K_M`/`Q8_0`), 27B-Qwen (`Q4_K_M`/`Q8_0`); all multimodal (mmproj)
- Added Qwen3.5-122B-A10B profiles: `IQ2_XXS` (33.80 GB, single file), `Q4_K_M` (74.99 GB, 2 shards); MoE (10B active), multimodal (mmproj) via `bartowski/Qwen_Qwen3.5-122B-A10B-GGUF`
- Added Qwen3.5-397B-A17B profiles: `IQ2_XXS` (106.57 GB, 3 shards), `Q4_K_M` (241.87 GB, 7 shards); MoE (17B active), multimodal (mmproj) via `bartowski/Qwen_Qwen3.5-397B-A17B-GGUF`
- Updated README.md hardware table: added "Any machine 1–8 GB" tier for Qwen3.5 small models; added Qwen3.5-9B to 8–16 GB tier
- Updated CURSOR.md: expanded reasoning models note to include GLM-4.7, GLM-5.1, MiniMax-M2.x
- Added Qwen3.5-27B (Jackrong) profiles: `Q2_K` (10.12 GB) and `Q3_K_M` (13.29 GB) to cover 16–24 GB hardware tiers

## [2026-04-05]

### Added
- Added SVG logo (`assets/logo.svg`) — animated neural network mark with gradient wordmark; replaces plain text h1 in README
- Added Nemotron-3-Nano-4B profile: `Q4_K_M` (2.84 GB) via official `nvidia/NVIDIA-Nemotron-3-Nano-4B-GGUF`
- Added Nemotron-Cascade-2-30B profiles: `Q4_K_M` (24.73 GB) and `Q8_0` (33.59 GB) via `bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF`
- Added DeepSeek-R1 671B profiles: `UD-IQ1_S` (185 GB, 4 shards), `UD-IQ2_XXS` (216 GB, 5 shards), `UD-Q2_K_XL` (250 GB, 6 shards) via `unsloth/DeepSeek-R1-GGUF-UD`; `Q3_K_M` (319 GB, 9 shards) via `bartowski/DeepSeek-R1-GGUF`
- Added DeepSeek-R1-0528 671B profile: `Q4_K_M` (~409 GB, 11 shards) via `lmstudio-community/DeepSeek-R1-0528-GGUF`
- Added DeepSeek-R1 distill profiles: Qwen-1.5B, Qwen-7B, Llama-8B, Qwen-14B, Qwen-32B Q4_K_M, Llama-70B (Q4_K_M/Q8_0) via `bartowski`; R1-0528-Qwen3-8B (Q4_K_M/Q8_0) via `unsloth`
- Added IQ1_S, IQ2_XXS, and UD-\* format entries to quantization guide in `profiles/README.md`

### Changed
- Windows quick start simplified: Docker recommended; native path via WSL only (removed winget block)
- Local config files (`opencode.json`, `chatLanguageModels.json`) labeled "local only" in contributor checklist
- GEMINI.md: fixed duplicate `### 3.` section heading
- profiles/README.md: corrected DeepSeek-R1-0528 date (May 2025, not 2028); restructured Recommended Starting Points with a 24–32 GB tier
- OPENCODE.md, VSCODE.md: added `make export-opencode` / `make export-vscode` hints

## [2026-04-03]

### Added
- Added `.gitignore` — ignores model weights (`*.gguf`, `*.safetensors`, etc.), local env overrides, macOS metadata, editor files, and Trivy cache
- Added `CONTRIBUTING.md` — profile creation guide, 8-file update checklist, and pre-PR validation steps (`validate-profiles.sh`, `lychee`)
- Added `scripts/validate-profiles.sh` — checks all profiles for required fields and warns on duplicate aliases
- Added `compose.traefik.yml` override — Traefik network join and labels separated from base `compose.yaml`; base now uses `expose` only with no external network dependency
- Added `CADDY.md` — HTTPS guide for native `make serve` (local/LAN without Tailscale); clarifies when to use Caddy vs Tailscale vs Traefik
- Added `make smoke-test` target — hits `/health` on `HOST:PORT` and verifies `{"status":"ok"}`
- Added `dependabot.yml` — weekly automated PRs to keep GitHub Actions versions current
- Added memory reservation to `compose.yaml` (`MEM_RESERVE`, default `4g`) via `deploy.resources.reservations`
- Added CI: profile validation workflow (`.github/workflows/validate-profiles.yml`)
- Added CI: shellcheck workflow for `scripts/` (`.github/workflows/shellcheck.yml`)
- Added CI: link checker workflow using lychee (`.github/workflows/link-check.yml`)
- Added `git clone` as step 1 in the Quick Start section
- Added HTML anchors to OS-specific install sections (`#macos-linux`, `#windows`, `#docker`) for direct linking
- Added Caddy to the Built On table in README.md as the HTTPS reverse proxy option for the native `make serve` path
- Added Gemma 4 E4B-it, 26B-A4B-it, and 31B-it profiles (Q4_K_M/Q8_0/F16) with mmproj multimodal support via `ggml-org`
- Added Nemotron-Nano-3-30B profiles (Q4_K_M/Q8_0) via `ggml-org/Nemotron-Nano-3-30B-A3B-GGUF`
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
- Added `make cache` target (`hf cache ls`) for inspecting the local Hugging Face model cache
- Added `make check-model` guard to `make serve` and `make chat` — fails immediately with a clear error if the model file is not found, preventing cryptic `invalid argument` errors
- Added healthcheck and `API_KEY` support to `compose.yaml` and `compose-entrypoint.sh`
- Added `CURSOR.md` integration guide — covers HTTPS requirement, setup steps, and deployment-path-aware options table (Traefik/Tailscale/Caddy)
- Added "Adding a New Model Profile" checklist to `AGENTS.md` listing all 8 files that must be updated in sync
- Added HuggingFace source URL as a comment (`# https://huggingface.co/...`) to the first line of every profile in `profiles/`
- Updated `~/.config/opencode/opencode.json` and `chatLanguageModels.json` to include all 13 model aliases (Gemma 4, Qwen3.5, GPT-OSS, DeepSeek, Nemotron, Kimi-K2.5)
- Added curation credit to DimkaNYC across the documentation

### Changed
- Simplified Windows `make` prerequisite to WSL only — removed Git Bash and MSYS2 options; added `sudo apt update && sudo apt install git make` command
- Reduced redundancy across integration guides: replaced CURSOR.md alias table with a link to `profiles/README.md#api-identity-aliases`; collapsed OPENCODE.md and VSCODE.md compatibility notes to a single line linking to README Quick Start
- Clarified CURSOR.md HTTPS options: Tailscale noted as having built-in HTTPS; Caddy scoped to local/LAN only
- Reorganized documentation: moved `PROFILES.md` to `profiles/README.md` for better directory-level discoverability
- Moved all model profile `.env-*` files into the `profiles/` directory
- Rewrote `README.md` for significantly better human readability, including a new Table of Contents and "Built On" section
- Updated all integration guides (`OPENCODE.md`, `VSCODE.md`, `GEMINI.md`, `AGENTS.md`) with the latest configuration variables and `profiles/` paths
- Updated `VSCODE.md` to document the `chatLanguageModels.json` format (`customoai` vendor) with all 13 individual model entries
- Replaced Mac Studio-specific hardware tier references with generic RAM/VRAM tier descriptions in `profiles/README.md`
- Fixed `make download` to pass each filename in `DOWNLOAD_INCLUDE` as a separate `--include` flag (via `$(foreach)`)
- Standardized Kimi-K2.5 size from GiB to GB across catalog and Recommended Starting Points
- Updated Trivy action from `@master` to `v0.35.0`; adopted `v`-prefixed tag per aquasecurity's supply chain security migration
- Bumped `actions/checkout` from v4 to v6 and `github/codeql-action` from v3 to v4 via Dependabot
- `make serve` now warns when `HOST` is not `127.0.0.1` and `API_KEY` is empty
- Traefik integration is now opt-in via `compose.traefik.yml` override — `docker compose up` no longer requires an external Traefik network
- CHANGELOG versioning corrected from SemVer to CalVer
- Linked Apache 2.0 LICENSE by name in README footer
- Aligned `AGENTS.md` and `CLAUDE.md` with current project state: WSL-only Windows, full targets table, Traefik override pattern, API key warning, `CADDY.md`/`CONTRIBUTING.md` in docs

### Fixed
- Fixed the `OPENCODE.md` integration guide to use the correct `provider` record and `options` schema required by OpenCode
- Fixed a corrupted `Makefile` that was causing syntax errors during `make serve`
- Fixed `make serve` hanging silently when a model was not yet downloaded — Makefile now searches `~/.cache/huggingface/hub` via `find -L` instead of `hf download`
- Fixed Qwen3.5-27B profile filenames; added `mmproj-BF16.gguf` to `DOWNLOAD_INCLUDE` as the repo includes a vision encoder
- Fixed tilde expansion in `Makefile` to ensure robust path handling for all model-related files
- Pushed `2026-03-27` tag to remote so CHANGELOG comparison URLs resolve
- Excluded `instagram.com` from lychee link checker (returns 429 for bots)
- Fixed lychee `--exclude-mail` flag (removed in v0.23.0); replaced with `--exclude 'mailto:'`

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

[Unreleased]: https://github.com/a1exus/koda/compare/2026-04-05...HEAD
[2026-04-05]: https://github.com/a1exus/koda/compare/2026-04-03...2026-04-05
[2026-04-03]: https://github.com/a1exus/koda/compare/2026-03-27...2026-04-03
[2026-03-27]: https://github.com/a1exus/koda/releases/tag/2026-03-27
