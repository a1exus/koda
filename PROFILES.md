# Bundled Profiles

This file is the catalog of bundled Koda model profiles. Each profile maps to a `.env-*` file in the `profiles/` directory that works with `make download`, `make serve`, and `make chat`.

## At a Glance

| File | Model | ALIAS | Notes |
| --- | --- | --- | --- |
| `.env-Qwen3.5-27B.Q4_K_M` | [Qwen3.5-27B Claude 4.6 Opus Reasoning Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled) | `qwen3.5-27b` | Smaller local reasoning profile |
| `.env-Qwen3.5-27B.Q8_0` | [Qwen3.5-27B Claude 4.6 Opus Reasoning Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled) | `qwen3.5-27b` | Higher-memory variant |
| `.env-Qwen3.5-35B-A3B.Q4_K_M` | [Qwen3.5-35B-A3B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive) | `qwen3.5-35b-a3b` | HauhauCS variant |
| `.env-Qwen3.5-35B-A3B.Q8_0` | [Qwen3.5-35B-A3B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive) | `qwen3.5-35b-a3b` | Higher-memory variant |
| `.env-Qwen3.5-35B-A3B-Qwen.Q4_K_M` | [Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B) | `qwen3.5-35b-a3b` | Official Qwen variant |
| `.env-Qwen3.5-35B-A3B-Qwen.Q8_0` | [Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B) | `qwen3.5-35b-a3b` | Higher-memory variant |
| `.env-Qwen3.5-9B.Q4_K_M` | [Qwen3.5-9B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive) | `qwen3.5-9b` | Smallest bundled Qwen profile |
| `.env-Qwen3.5-9B.Q8_0` | [Qwen3.5-9B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive) | `qwen3.5-9b` | Higher-memory variant |
| `.env-gpt-oss-20b.MXFP4` | [gpt-oss-20b GGUF](https://huggingface.co/ggml-org/gpt-oss-20b-GGUF) | `gpt-oss-20b` | Official `llama.cpp` GGUF |
| `.env-gpt-oss-120b.MXFP4` | [gpt-oss-120b GGUF](https://huggingface.co/ggml-org/gpt-oss-120b-GGUF) | `gpt-oss-120b` | Official sharded `llama.cpp` GGUF |
| `.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` | [DeepSeek-R1-Distill-Qwen-32B GGUF](https://huggingface.co/ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF) | `deepseek-r1-distill-qwen-32b` | Practical local stand-in for DeepSeek-R1 |
| `.env-Kimi-K2.5.Q4_X` | [Kimi-K2.5 GGUF (Q4_X)](https://huggingface.co/AesSedai/Kimi-K2.5-GGUF) | `kimi-k2.5` | Very large sharded GGUF |

## API Identity (Aliases)

Koda profiles use the `ALIAS` variable to ensure a consistent model ID is reported via the OpenAI-compatible API, regardless of the underlying GGUF filename. This allows external tools like OpenCode or VS Code to maintain a stable configuration even if you switch between different quantizations (e.g., from Q4 to Q8) of the same model family.

## Recommended Starting Points

- Start with `.env-Qwen3.5-27B.Q4_K_M` if you want a reasonable first local reasoning model.
- Use `.env-gpt-oss-20b.MXFP4` if you want a current `gpt-oss` profile with official `llama.cpp` GGUF support.
- Use `.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` instead of trying to run the full `DeepSeek-R1` release locally.
- Treat `.env-Kimi-K2.5.Q4_X` as an advanced profile due to its size.

## Profile Notes

### gpt-oss-20b

The bundled `gpt-oss-20b` profile uses the official GGUF published for `llama.cpp`:

```bash
make download ENV=.env-gpt-oss-20b.MXFP4
make serve ENV=.env-gpt-oss-20b.MXFP4
```

This model expects harmony-style prompting. Koda's default `PROMPT_FORMAT=jinja` is the correct path for the GGUF build.

Sources:
- [openai/gpt-oss-20b](https://huggingface.co/openai/gpt-oss-20b)
- [ggml-org/gpt-oss-20b-GGUF](https://huggingface.co/ggml-org/gpt-oss-20b-GGUF)

### gpt-oss-120b

The bundled `gpt-oss-120b` profile uses the official sharded GGUF published for `llama.cpp`:

```bash
make download ENV=.env-gpt-oss-120b.MXFP4
make serve ENV=.env-gpt-oss-120b.MXFP4
```

This profile downloads all three GGUF shards via `DOWNLOAD_INCLUDE=gpt-oss-120b-mxfp4-*.gguf`, then serves from the first shard file.

This model also expects harmony-style prompting, so Koda's default `PROMPT_FORMAT=jinja` is the correct path here too.

Hardware note: upstream positions `gpt-oss-120b` for large-memory systems, roughly in the single-80GB-GPU class for full acceleration.

Sources:
- [openai/gpt-oss-120b](https://huggingface.co/openai/gpt-oss-120b)
- [ggml-org/gpt-oss-120b-GGUF](https://huggingface.co/ggml-org/gpt-oss-120b-GGUF)

### DeepSeek-R1

The original [deepseek-ai/DeepSeek-R1](https://huggingface.co/deepseek-ai/DeepSeek-R1) is a 671B MoE model with 37B activated parameters, so the bundled Koda profile targets the official `llama.cpp`-ready distilled checkpoint instead:

```bash
make download ENV=.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0
make serve ENV=.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0
```

This bundled profile uses [ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF](https://huggingface.co/ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF), converted from the official [deepseek-ai/DeepSeek-R1-Distill-Qwen-32B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B).

DeepSeek recommends `temperature` in the `0.5-0.7` range, avoiding system prompts, and allowing the model to start with `<think>` reasoning naturally. Koda's defaults already use `TEMP=0.6` and `TOP_P=0.95`.

Source:
- [DeepSeek-R1 model card](https://huggingface.co/deepseek-ai/DeepSeek-R1)

### Kimi-K2.5

The original [moonshotai/Kimi-K2.5](https://huggingface.co/moonshotai/Kimi-K2.5) is a 1T-parameter multimodal MoE model with 32B activated parameters. The bundled Koda profile targets the current practical `llama.cpp` GGUF route:

```bash
make download ENV=.env-Kimi-K2.5.Q4_X
make serve ENV=.env-Kimi-K2.5.Q4_X
```

This profile uses [AesSedai/Kimi-K2.5-GGUF](https://huggingface.co/AesSedai/Kimi-K2.5-GGUF), specifically the `Q4_X` shard set:

- download pattern: `Q4_X/Kimi-K2.5-Q4_X-*.gguf`
- serve path: `Q4_X/Kimi-K2.5-Q4_X-00001-of-00014.gguf`

The profile sets `TEMP=1.0` to match Moonshot AI's published evaluation setting and keeps `TOP_P=0.95`.

Practical caveats:

- This quant is extremely large: the Q4_X shard set is roughly 544 GiB according to the GGUF model card.
- The GGUF route here is text-and-image only; video is not available in upstream `llama.cpp` yet.
- Koda does not currently expose `mmproj` wiring, so this bundled profile should be treated as text-first unless you extend the wrapper.

Sources:
- [moonshotai/Kimi-K2.5](https://huggingface.co/moonshotai/Kimi-K2.5)
- [AesSedai/Kimi-K2.5-GGUF](https://huggingface.co/AesSedai/Kimi-K2.5-GGUF)

---

Curated by **[DimkaNYC](https://huggingface.co/DimkaNYC)**.
