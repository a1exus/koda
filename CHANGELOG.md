# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Generic llama.cpp local inference setup with OpenAI-compatible API server
- `Makefile` with `serve`, `chat`, and `download` targets; `make` alone shows usage
- Env files named `.env-<model>.<quant>` — no default, always explicit
- Required variables (`HF_REPO`, `MODEL_DIR`, `MODEL_FILE`) must be set via env file — no hardcoded defaults
- opencode provider config at `~/.config/opencode/opencode.json` pointing to `http://127.0.0.1:8080/v1`
- Bundled profiles: Qwen3.5-27B (distilled), Qwen3.5-35B-A3B (Qwen + HauhauCS uncensored), Qwen3.5-9B (HauhauCS uncensored)
- Bundled profile for `gpt-oss-20b` via `ggml-org/gpt-oss-20b-GGUF`
- Bundled profile for `gpt-oss-120b` via `ggml-org/gpt-oss-120b-GGUF`
- Bundled profile for `DeepSeek-R1-Distill-Qwen-32B` via `ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF`
- Bundled profile for `Kimi-K2.5` via `AesSedai/Kimi-K2.5-GGUF`
- Added `compose.yaml` as a containerized deployment path using the official upstream `llama.cpp` image
- Added Traefik labels for the Compose deployment path
- Simplified the Compose deployment path to rely on `.env`, `expose`, and the external `traefik` network

- Added Hugging Face cache volume to `compose.yaml` to share models from the default cache location
- Added default `MODEL_DIR` and `MODEL_FILE` to `.env` to fix Docker Compose interpolation errors

### Changed

- `make serve` is now documented as the main entrypoint for both the built-in WebUI and the OpenAI-compatible API
- Default prompt handling now prefers the GGUF model's embedded Jinja template via `PROMPT_FORMAT=jinja`
- Added opinionated server batching defaults with `BATCH=512` and `UBATCH=512`
- Added `SERVER_EXTRA_ARGS` and `CHAT_EXTRA_ARGS` as structured escape hatches for advanced llama.cpp flags
- Renamed `AGENT.md` to `AGENTS.md`
- Added `make check` and friendlier missing-binary errors for `llama-server`, `llama-cli`, and `hf`
- Added `DOWNLOAD_INCLUDE` support so `make download` can fetch sharded GGUF models
- Added `RPC` passthrough support so `make serve` and `make chat` can use llama.cpp RPC backends
- Split bundled model/profile documentation into `PROFILES.md`
- Simplified `README.md` into a shorter quick-start and runtime guide
- Changed the default GPU offload from `99` to `-1` to match modern llama.cpp usage better
- Added `METRICS=1` support for exposing llama-server metrics
- Added deployment guidance to keep exposed servers behind a reverse proxy or gateway
- Added `TAILSCALE.md` for private tailnet access and multi-machine RPC pooling guidance
- Clarified that the primary target environments are macOS on Apple Silicon and Linux with NVIDIA GPUs

[Unreleased]: https://github.com/change/me/compare/HEAD
