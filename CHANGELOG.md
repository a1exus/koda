# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Initial project setup for local inference with Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled
- `Makefile` with `serve`, `chat`, and `download` targets
- `.env.q4_k_m` and `.env.q8` configuration profiles; switch with `make serve ENV=.env.q8`
- `hf download` command for fetching GGUF quantized weights
- Quantization reference table (Q2_K through Q8_0)
- opencode provider config pointing to llama-server at `http://127.0.0.1:8080/v1`

[Unreleased]: https://github.com/change/me/compare/HEAD
