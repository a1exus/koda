# Local LLM Inference via llama.cpp

Run [GGUF models](./GGUF.md) locally using llama.cpp with a built-in browser WebUI and an OpenAI-compatible API server.

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

If a model is split across multiple GGUF files, also set:

```bash
DOWNLOAD_INCLUDE=<glob-pattern>
```

### Bundled profiles

| File | Model |
| --- | --- |
| `.env-Qwen3.5-27B.Q4_K_M` | [Qwen3.5-27B Claude 4.6 Opus Reasoning Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled) |
| `.env-Qwen3.5-27B.Q8_0` | [Qwen3.5-27B Claude 4.6 Opus Reasoning Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled) |
| `.env-Qwen3.5-35B-A3B.Q4_K_M` | [Qwen3.5-35B-A3B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive) |
| `.env-Qwen3.5-35B-A3B.Q8_0` | [Qwen3.5-35B-A3B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive) |
| `.env-Qwen3.5-35B-A3B-Qwen.Q4_K_M` | [Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B) |
| `.env-Qwen3.5-35B-A3B-Qwen.Q8_0` | [Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B) |
| `.env-Qwen3.5-9B.Q4_K_M` | [Qwen3.5-9B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive) |
| `.env-Qwen3.5-9B.Q8_0` | [Qwen3.5-9B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive) |
| `.env-gpt-oss-20b.MXFP4` | [gpt-oss-20b GGUF](https://huggingface.co/ggml-org/gpt-oss-20b-GGUF) |
| `.env-gpt-oss-120b.MXFP4` | [gpt-oss-120b GGUF](https://huggingface.co/ggml-org/gpt-oss-120b-GGUF) |
| `.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` | [DeepSeek-R1-Distill-Qwen-32B GGUF](https://huggingface.co/ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF) |
| `.env-Kimi-K2.5.Q4_X` | [Kimi-K2.5 GGUF (Q4_X)](https://huggingface.co/AesSedai/Kimi-K2.5-GGUF) |

## Usage

```bash
make serve    ENV=.env-Qwen3.5-27B.Q4_K_M   # start API server + WebUI
make chat     ENV=.env-Qwen3.5-27B.Q4_K_M   # interactive terminal chat
make download ENV=.env-Qwen3.5-27B.Q4_K_M   # download the model
make check                                # verify required binaries are installed
```

Inline overrides also work:

```bash
make serve ENV=.env-Qwen3.5-27B.Q4_K_M PORT=9090
```

When `make serve` is running:

- WebUI: `http://localhost:8080`
- OpenAI-compatible API: `http://localhost:8080/v1/chat/completions`

### Opinionated defaults

Koda keeps the public interface small and wraps the useful llama.cpp defaults for you:

- `PROMPT_FORMAT=jinja` uses the GGUF model's embedded chat template by default
- `CTX=0` uses the model's native context size
- `BATCH=512` and `UBATCH=512` provide a conservative starting point for server throughput
- `GPU_LAYERS=99` offloads as much as possible by default

If a model needs an explicit template, switch to `PROMPT_FORMAT=template` and set `CHAT_TPL=<name>`.

### RPC offload

Koda can pass `llama.cpp` RPC servers through to both `llama-server` and `llama-cli`:

```bash
make serve ENV=.env-gpt-oss-120b.MXFP4 RPC=10.0.0.12:50052
make chat  ENV=.env-gpt-oss-120b.MXFP4 RPC=10.0.0.12:50052
```

If you have multiple RPC backends, pass the exact value that your installed `llama.cpp` build expects to `--rpc`.

### gpt-oss-20b

The bundled `gpt-oss-20b` profile uses the official GGUF published for `llama.cpp`:

```bash
make download ENV=.env-gpt-oss-20b.MXFP4
make serve ENV=.env-gpt-oss-20b.MXFP4
```

This model expects harmony-style prompting. Koda's default `PROMPT_FORMAT=jinja` is the correct path for the GGUF build.

### gpt-oss-120b

The bundled `gpt-oss-120b` profile uses the official sharded GGUF published for `llama.cpp`:

```bash
make download ENV=.env-gpt-oss-120b.MXFP4
make serve ENV=.env-gpt-oss-120b.MXFP4
```

This profile downloads all three GGUF shards via `DOWNLOAD_INCLUDE=gpt-oss-120b-mxfp4-*.gguf`, then serves from the first shard file.

This model also expects harmony-style prompting, so Koda's default `PROMPT_FORMAT=jinja` is the correct path here too.

Hardware note: upstream positions `gpt-oss-120b` for large-memory systems, roughly in the single-80GB-GPU class for full acceleration. Source: [openai/gpt-oss-120b](https://huggingface.co/openai/gpt-oss-120b), [ggml-org/gpt-oss-120b-GGUF](https://huggingface.co/ggml-org/gpt-oss-120b-GGUF).

### DeepSeek-R1

The original [deepseek-ai/DeepSeek-R1](https://huggingface.co/deepseek-ai/DeepSeek-R1) is a 671B MoE model with 37B activated parameters, so the bundled Koda profile targets the official `llama.cpp`-ready distilled checkpoint instead:

```bash
make download ENV=.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0
make serve ENV=.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0
```

This bundled profile uses [ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF](https://huggingface.co/ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF), converted from the official [deepseek-ai/DeepSeek-R1-Distill-Qwen-32B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B).

DeepSeek recommends `temperature` in the `0.5-0.7` range, avoiding system prompts, and allowing the model to start with `<think>` reasoning naturally. Koda's defaults already use `TEMP=0.6` and `TOP_P=0.95`. Source: [DeepSeek-R1 model card](https://huggingface.co/deepseek-ai/DeepSeek-R1).

### Kimi-K2.5

The original [moonshotai/Kimi-K2.5](https://huggingface.co/moonshotai/Kimi-K2.5) is a 1T-parameter multimodal MoE model with 32B activated parameters. The bundled Koda profile targets the current practical `llama.cpp` GGUF route:

```bash
make download ENV=.env-Kimi-K2.5.Q4_X
make serve ENV=.env-Kimi-K2.5.Q4_X
```

This profile uses [AesSedai/Kimi-K2.5-GGUF](https://huggingface.co/AesSedai/Kimi-K2.5-GGUF), specifically the `Q4_X` shard set:

- download pattern: `Q4_X/Kimi-K2.5-Q4_X-*.gguf`
- serve path: `Q4_X/Kimi-K2.5-Q4_X-00001-of-00014.gguf`

The profile sets `TEMP=1.0` to match Moonshot AI's published evaluation setting and keeps `TOP_P=0.95`. Source: [moonshotai/Kimi-K2.5](https://huggingface.co/moonshotai/Kimi-K2.5).

Practical caveats:

- This quant is extremely large: the Q4_X shard set is roughly 544 GiB according to the GGUF model card.
- The GGUF route here is text-and-image only; video is not available in upstream `llama.cpp` yet.
- Koda does not currently expose `mmproj` wiring, so this bundled profile should be treated as text-first unless you extend the wrapper.

### Runtime variables

Set in the env file or inline. Model-specific variables (`HF_REPO`, `MODEL_DIR`, `MODEL_FILE`) are required for `make download`, `make serve`, and `make chat`, and have no defaults.

| Variable | Default | Description |
| --- | --- | --- |
| `HF_REPO` | — | HuggingFace repo (`org/repo-GGUF`) |
| `MODEL_DIR` | — | Local model directory |
| `MODEL_FILE` | — | Model filename (e.g. `model.Q4_K_M.gguf`) |
| `DOWNLOAD_INCLUDE` | `$(MODEL_FILE)` | File or glob passed to `hf download --include`; useful for sharded GGUF models |
| `CTX` | `0` | Context window size (`0` = model native) |
| `HOST` | `0.0.0.0` | Server bind address |
| `PORT` | `8080` | Server port |
| `GPU_LAYERS` | `99` | Layers offloaded to GPU |
| `PROMPT_FORMAT` | `jinja` | `jinja` uses the GGUF's embedded chat template; `template` uses `CHAT_TPL` |
| `CHAT_TPL` | `chatml` | Fallback explicit chat template when `PROMPT_FORMAT=template` |
| `RPC` | empty | Value passed to `llama-server` / `llama-cli` as `--rpc ...` for remote RPC backends |
| `BATCH` | `512` | Prompt processing batch size |
| `UBATCH` | `512` | Micro-batch size used during prompt processing |
| `TEMP` | `0.6` | Sampling temperature (chat) |
| `TOP_P` | `0.95` | Top-p sampling (chat) |
| `SERVER_EXTRA_ARGS` | empty | Extra flags appended to `llama-server` |
| `CHAT_EXTRA_ARGS` | empty | Extra flags appended to `llama-cli` |

> **Note on CTX:** Setting `CTX=0` (default) uses the model's native context window. You can manually set this to a lower value to save RAM/VRAM, or a higher value if the model and your hardware support it. Use inline overrides to test different sizes: `make serve ENV=.env-file CTX=16384`.

> **Note on memory:** You do not need to fit the full model in VRAM to get useful performance. If you run into memory pressure, lower `CTX` first and then tune `GPU_LAYERS`, `BATCH`, or `UBATCH`.

## Learning Resources

- [What is GGUF and Why Run Locally?](./GGUF.md)

## Integrations

- [OpenCode Integration](./OPENCODE.md)
- [VS Code Integration](./VSCODE.md)

## License

Model weights: see individual model pages.
