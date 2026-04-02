# Bundled Profiles

Each profile is a `.env-*` file in `profiles/` that configures `make download`, `make serve`, and `make chat` for a specific model and quantization.

---

## Quantization Guide

GGUF models are quantized — their weights are compressed to reduce memory use with minimal quality loss. The format appears at the end of each profile filename.

| Format | Bits/weight | Relative size | Notes |
| --- | --- | --- | --- |
| **F16** | 16 | 100% | Full float16, no compression. Best quality ceiling. |
| **BF16** | 16 | 100% | Brain float16. Same size as F16, wider exponent range. |
| **Q8_0** | ~8.5 | ~53% | Near-lossless. Perceptually indistinguishable from F16 for most tasks. |
| **Q4_K_M** | ~4.5 | ~28% | 4-bit K-quant, "medium" mix — critical layers kept at higher precision. Best size/quality tradeoff; recommended default. |
| **Q4_K** | ~4.5 | ~27% | 4-bit K-quant, base variant. Slightly smaller than Q4_K_M with marginally lower quality. |
| **MXFP4** | 4 | ~25% | Microsoft Microscaling FP4. Hardware-native block-scaled 4-bit. Used by OpenAI GPT-OSS models. |
| **Q4_X** | ~4.5 | ~28% | Extended 4-bit designed for large MoE weight structures. |

**VRAM/RAM rule of thumb:** file size + ~1–2 GB overhead for the KV cache at default context.
Sizes marked `~` are estimates from standard bit-rate formulas; all others are exact.

---

## Model Catalog

---

### Gemma 4 · Google

Google's Gemma 4 5B instruction model. Smallest footprint in the catalog — a good first model to try. Official GGUF from ggml-org.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-gemma-4-E2B-it.Q8_0` | 4.97 GB | Q8_0 |
| `.env-gemma-4-E2B-it.F16` | 9.31 GB | F16 |

**ALIAS:** `gemma-4-e2b-it`
**Sources:** [ggml-org/gemma-4-E2B-it-GGUF](https://huggingface.co/ggml-org/gemma-4-E2B-it-GGUF) · [google/gemma-4-E2B-it](https://huggingface.co/google/gemma-4-E2B-it)

---

### Qwen3.5 · Alibaba / HauhauCS

Alibaba's Qwen3.5 family in two sizes. Both are converted to GGUF by HauhauCS and include a vision encoder (`mmproj`) — Koda auto-detects it for multimodal use when the mmproj file is in the same directory. The official Qwen weights are safetensors only; these profiles use the HauhauCS GGUF conversions.

#### Qwen3.5-9B

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Qwen3.5-9B.Q4_K_M` | ~5.1 GB | Q4_K_M |
| `.env-Qwen3.5-9B.Q8_0` | ~9.6 GB | Q8_0 |

**ALIAS:** `qwen3.5-9b`
**Source:** [HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive)

#### Qwen3.5-35B-A3B (MoE, 3B activated)

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Qwen3.5-35B-A3B.Q4_K_M` | ~20 GB | Q4_K_M |
| `.env-Qwen3.5-35B-A3B.Q8_0` | ~37 GB | Q8_0 |

**ALIAS:** `qwen3.5-35b-a3b`
**Source:** [HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive)

#### Qwen3.5-27B · Claude 4.6 Opus Reasoning Distilled

Reasoning-focused 27B distill. GGUF published by Jackrong alongside the original weights.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Qwen3.5-27B.Q4_K_M` | 16.6 GB | Q4_K_M |
| `.env-Qwen3.5-27B.Q8_0` | 28.7 GB | Q8_0 |

**ALIAS:** `qwen3.5-27b`
**Source:** [Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF) · [Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled)

---

### GPT-OSS · OpenAI

OpenAI's open-source model family, official GGUFs from ggml-org. Both use harmony-style prompting; Koda's default `PROMPT_FORMAT=jinja` handles it automatically.

#### GPT-OSS 20B

| Profile | Size | Format |
| --- | --- | --- |
| `.env-gpt-oss-20b.MXFP4` | 12.1 GB | MXFP4 |

**ALIAS:** `gpt-oss-20b`
**Sources:** [ggml-org/gpt-oss-20b-GGUF](https://huggingface.co/ggml-org/gpt-oss-20b-GGUF) · [openai/gpt-oss-20b](https://huggingface.co/openai/gpt-oss-20b)

#### GPT-OSS 120B

Sharded across 3 GGUF files. Requires roughly 80 GB of VRAM/RAM for full GPU acceleration.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-gpt-oss-120b.MXFP4` | 63.4 GB (3 shards) | MXFP4 |

**ALIAS:** `gpt-oss-120b`
**Sources:** [ggml-org/gpt-oss-120b-GGUF](https://huggingface.co/ggml-org/gpt-oss-120b-GGUF) · [openai/gpt-oss-120b](https://huggingface.co/openai/gpt-oss-120b)

---

### DeepSeek-R1-Distill-Qwen-32B · DeepSeek

The original DeepSeek-R1 is a 671B MoE — impractical locally. This 32B distilled checkpoint is the recommended local stand-in. Outputs reasoning in `<think>...</think>` blocks before the final answer. Avoid system prompts; let the model open with `<think>` naturally.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` | 34.8 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-qwen-32b`
**Sampling:** `TEMP=0.6`, `TOP_P=0.95` (Koda defaults match DeepSeek's recommendation)
**Sources:** [ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF](https://huggingface.co/ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Qwen-32B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B)

---

### Nemotron-3-Super-120B · NVIDIA

NVIDIA's 121B Nemotron H MoE model. Single-file GGUF from ggml-org. Requires substantial VRAM; pairs well with llama.cpp RPC for multi-machine offload.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Nemotron-3-Super-120B.Q4_K` | 69.9 GB | Q4_K |

**ALIAS:** `nemotron-3-super-120b`
**Sources:** [ggml-org/Nemotron-3-Super-120B-GGUF](https://huggingface.co/ggml-org/Nemotron-3-Super-120B-GGUF) · [nvidia/Nemotron-3-Super-120B](https://huggingface.co/nvidia/Nemotron-3-Super-120B)

---

### Kimi-K2.5 · Moonshot AI

1T-parameter MoE (32B activated). Extremely large — 544 GiB across 14 shards. Advanced profile; treat as multi-machine or server-class hardware only.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Kimi-K2.5.Q4_X` | 544 GiB (14 shards) | Q4_X |

**ALIAS:** `kimi-k2.5`
**Sampling:** `TEMP=1.0` (matches Moonshot AI's published evaluation setting)
**Sources:** [AesSedai/Kimi-K2.5-GGUF](https://huggingface.co/AesSedai/Kimi-K2.5-GGUF) · [moonshotai/Kimi-K2.5](https://huggingface.co/moonshotai/Kimi-K2.5)

---

## Recommended Starting Points

| Goal | Profile |
| --- | --- |
| First local model, minimal VRAM | `.env-gemma-4-E2B-it.Q8_0` (5 GB) |
| Best size/quality balance | `.env-Qwen3.5-9B.Q4_K_M` (~5 GB) or `.env-gpt-oss-20b.MXFP4` (12 GB) |
| Reasoning tasks | `.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` (35 GB) |
| Large GPU (64–80 GB) | `.env-gpt-oss-120b.MXFP4` or `.env-Nemotron-3-Super-120B.Q4_K` |
| Multi-machine / extreme scale | `.env-Kimi-K2.5.Q4_X` (544 GiB) |

---

## API Identity (Aliases)

Profiles set `ALIAS` to give the model a clean, stable ID in the OpenAI-compatible API. This lets external tools (OpenCode, VS Code Copilot) keep a fixed config even when you swap quantizations — the alias stays the same across Q4 and Q8 variants of the same model.
