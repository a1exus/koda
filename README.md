# Local LLM Inference via llama.cpp

Run GGUF models locally using llama.cpp with an OpenAI-compatible API server.

**Current model:** [Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled) — a 27B reasoning model distilled from Claude 4.6 Opus trajectories, with structured `<think>` blocks, native tool calling, and up to 262K context.

## Requirements

### llama.cpp

[Installation docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md)

### hf CLI

[Installation docs](https://huggingface.co/docs/huggingface_hub/en/guides/cli)

## Downloading Models

### This model

```bash
hf download \
  Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF \
  --include "Qwen3.5-27B.Q4_K_M.gguf" \
  --local-dir ~/models/qwen3.5-27b-distilled
```

See the [quant table](#quantization-options) below to pick a different size.

## Usage

```bash
make serve        # start OpenAI-compatible API server
make chat         # interactive terminal chat
make download     # download the model
```

Override the env file to switch models:

```bash
make serve ENV=.env.q8
make download ENV=.env.q8
```

Inline overrides also work:

```bash
make serve PORT=9090
```

Endpoint: `http://localhost:8080/v1/chat/completions`

### Configuration

Parameters are loaded from an env file (`ENV=.env` by default). Copy and edit one of the bundled profiles:

| File | Quant |
| --- | --- |
| `.env.q4_k_m` | Q4_K_M — recommended |
| `.env.q8` | Q8_0 — best quality |

Available variables:

| Variable | Default | Description |
| --- | --- | --- |
| `QUANT` | `Q4_K_M` | Quantization variant |
| `MODEL_DIR` | `~/models/qwen3.5-27b-distilled` | Model directory |
| `MODEL_FILE` | `Qwen3.5-27B.$(QUANT).gguf` | Model filename |
| `CTX` | `8192` | Context window size |
| `HOST` | `0.0.0.0` | Server bind address |
| `PORT` | `8080` | Server port |
| `GPU_LAYERS` | `99` | Layers offloaded to GPU |
| `TEMP` | `0.6` | Sampling temperature (chat) |
| `TOP_P` | `0.95` | Top-p sampling (chat) |

## OpenCode

Start the server first, then open opencode and select **llama.cpp** as the provider and `qwen3.5-27b-distilled` as the model.

The provider is already configured in `~/.config/opencode/opencode.json` pointing to `http://127.0.0.1:8080/v1`. To connect from a different tool, use the same base URL with any non-empty API key.

## Quantization Options

| File | Size | Min RAM | Notes |
| --- | --- | --- | --- |
| `Q8_0.gguf` | 28.6 GB | 29 GB | Best quality |
| `Q4_K_M.gguf` | 16.5 GB | 17 GB | Recommended |
| `Q3_K_M.gguf` | 13.3 GB | 14 GB | |
| `Q3_K_S.gguf` | 12.1 GB | 13 GB | |
| `Q2_K.gguf` | 10.1 GB | 11 GB | Lowest quality |

## License

Model weights: Apache 2.0
