# Local LLM Inference via llama.cpp

Run GGUF models locally using llama.cpp with an OpenAI-compatible API server.

## Requirements

### llama.cpp

[Installation docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md)

### hf CLI

[Installation docs](https://huggingface.co/docs/huggingface_hub/en/guides/cli)

## Adding a Model

Create an env file named `.env-<model>.<quant>` with these required variables:

```bash
# link to the model page for reference
HF_REPO=<org>/<repo>-GGUF
MODEL_DIR=$(HOME)/models/<name>
MODEL_FILE=<filename>.gguf
```

Then run `make download ENV=.env-<model>.<quant>` to fetch it.

### Bundled profiles

| File | Model |
| --- | --- |
| `.env-Qwen3.5-27B.Q4_K_M` | [Qwen3.5-27B Claude 4.6 Opus Reasoning Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled) Q4_K_M |
| `.env-Qwen3.5-27B.Q8_0` | [Qwen3.5-27B Claude 4.6 Opus Reasoning Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled) Q8_0 |
| `.env-Qwen3.5-35B-A3B.Q4_K_M` | [Qwen3.5-35B-A3B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive) Q4_K_M |
| `.env-Qwen3.5-35B-A3B.Q8_0` | [Qwen3.5-35B-A3B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive) Q8_0 |
| `.env-Qwen3.5-35B-A3B-Qwen.Q4_K_M` | [Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B) Q4_K_M (via unsloth) |
| `.env-Qwen3.5-35B-A3B-Qwen.Q8_0` | [Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B) Q8_0 (via unsloth) |
| `.env-Qwen3.5-9B.Q4_K_M` | [Qwen3.5-9B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive) Q4_K_M |
| `.env-Qwen3.5-9B.Q8_0` | [Qwen3.5-9B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive) Q8_0 |

## Usage

```bash
make serve    ENV=.env-Qwen3.5-27B.Q4_K_M   # start API server
make chat     ENV=.env-Qwen3.5-27B.Q4_K_M   # interactive terminal chat
make download ENV=.env-Qwen3.5-27B.Q4_K_M   # download the model
```

Inline overrides also work:

```bash
make serve ENV=.env-Qwen3.5-27B.Q4_K_M PORT=9090
```

Endpoint: `http://localhost:8080/v1/chat/completions`

### Runtime variables

Set in the env file or inline. Model-specific variables (`HF_REPO`, `MODEL_DIR`, `MODEL_FILE`) are required and have no defaults.

| Variable | Default | Description |
| --- | --- | --- |
| `HF_REPO` | — | HuggingFace repo (`org/repo-GGUF`) |
| `MODEL_DIR` | — | Local model directory |
| `MODEL_FILE` | — | Model filename (e.g. `model.Q4_K_M.gguf`) |
| `CTX` | `8192` | Context window size |
| `HOST` | `0.0.0.0` | Server bind address |
| `PORT` | `8080` | Server port |
| `GPU_LAYERS` | `99` | Layers offloaded to GPU |
| `TEMP` | `0.6` | Sampling temperature (chat) |
| `TOP_P` | `0.95` | Top-p sampling (chat) |

## OpenCode

Start the server first, then open opencode and select **llama.cpp** as the provider and the model name.

The provider is configured in `~/.config/opencode/opencode.json` pointing to `http://127.0.0.1:8080/v1`. Any OpenAI-compatible client can use the same base URL with any non-empty API key.

## License

Model weights: see individual model pages.
