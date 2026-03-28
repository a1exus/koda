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

[Unreleased]: https://github.com/change/me/compare/HEAD
