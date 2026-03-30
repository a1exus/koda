# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
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

### Changed
- Reorganized documentation: moved `PROFILES.md` to `profiles/README.md` for better directory-level discoverability
- Moved all model profile `.env-*` files into the `profiles/` directory
- Rewrote `README.md` for significantly better human readability, including a new Table of Contents and "Built On" section
- Updated all integration guides (`OPENCODE.md`, `VSCODE.md`, `GEMINI.md`, `AGENTS.md`) with the latest configuration variables and `profiles/` paths

### Fixed
- Fixed the `OPENCODE.md` integration guide to use the correct `provider` record and `options` schema required by OpenCode
- Fixed a corrupted `Makefile` that was causing syntax errors during `make serve`
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

[Unreleased]: https://github.com/a1exus/koda/compare/2026-03-27...HEAD
[2026-03-27]: https://github.com/a1exus/koda/releases/tag/2026-03-27
