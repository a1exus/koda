# Bundled Models

Each model is a `<org>/<repo>.<quant>.env` file in `models/` that configures `make download`, `make serve`, and `make chat` for a specific model and quantization.

Run `make list` to see all models with their aliases, or `make select` for an interactive picker.

---

## What is GGUF?

**GGUF** (GPT-Generated Unified Format) is the standard file format for running LLMs locally with [llama.cpp](https://github.com/ggml-org/llama.cpp). It bundles the model weights, architecture metadata, and chat template into a single portable file.

**Why run locally?**
- **Privacy** — your prompts never leave your machine
- **No rate limits** — your hardware is always available
- **Cost** — no per-token fees after the initial hardware investment
- **Control** — run any model, any quantization, any settings

**Hardware acceleration** — llama.cpp offloads compute to the GPU automatically:
- **Apple Silicon (Metal)** — unified memory means large models fit where discrete GPUs can't; M-series Ultra chips support up to 192 GB
- **NVIDIA (CUDA)** — industry standard on Linux/Windows
- **AMD (ROCm/OpenCL)** — supported on Linux via the ROCm image

---

## Quantization Guide

GGUF models are quantized — their weights are compressed to reduce memory use with minimal quality loss. The format appears at the end of each model filename.

| Format | Bits/weight | Relative size | Notes |
| --- | --- | --- | --- |
| **F16** | 16 | 100% | Full float16, no compression. Best quality ceiling. |
| **BF16** | 16 | 100% | Brain float16. Same size as F16, wider exponent range. |
| **Q8_0** | ~8.5 | ~53% | Near-lossless. Perceptually indistinguishable from F16 for most tasks. |
| **Q4_K_M** | ~4.5 | ~28% | 4-bit K-quant, "medium" mix — critical layers kept at higher precision. Best size/quality tradeoff; recommended default. |
| **Q4_K** | ~4.5 | ~27% | 4-bit K-quant, base variant. Slightly smaller than Q4_K_M with marginally lower quality. |
| **Q4_X** | ~4.5 | ~28% | Extended 4-bit designed for large MoE weight structures. |
| **MXFP4** | 4 | ~25% | Microsoft Microscaling FP4. Hardware-native block-scaled 4-bit. Used by OpenAI GPT-OSS models. |
| **IQ2_XXS** | ~2.22 | ~14% | Integer quant, 2.22-bit. Aggressive compression; reasonable quality floor for very large models (671B+). |
| **IQ1_S** | ~1.58 | ~10% | Integer quant, 1.58-bit. Extreme compression; minimum viable floor for 671B-class models only. |
| **UD-\*** | varies | varies | Unsloth Dynamic: per-layer mixed precision — critical matrices kept at higher bits for better quality at the same average bit-width. Prefix on quant name (e.g. `UD-IQ2_XXS`). |

**VRAM/RAM rule of thumb:** file size + ~1–2 GB overhead for the KV cache at default context.
Sizes marked `~` are estimates from standard bit-rate formulas; all others are exact.

---

## Model Catalog

### Gemma 4 · Google

Google's Gemma 4 multimodal model family. All instruct variants include a vision encoder (`mmproj`) — Koda auto-detects it for multimodal use. The `make download` step fetches both the model and mmproj automatically. Official GGUFs from ggml-org.

#### E2B Instruct (5B)

| Model | Size | Format |
| --- | --- | --- |
| `ggml-org/gemma-4-E2B-it-GGUF.Q8_0.env` | 4.97 GB | Q8_0 |
| `ggml-org/gemma-4-E2B-it-GGUF.F16.env` | 9.31 GB | F16 |

**ALIAS:** `gemma-4-e2b-it`
**Sources:** [ggml-org/gemma-4-E2B-it-GGUF](https://huggingface.co/ggml-org/gemma-4-E2B-it-GGUF) · [google/gemma-4-E2B-it](https://huggingface.co/google/gemma-4-E2B-it)

#### E4B Instruct (8B)

| Model | Size | Format |
| --- | --- | --- |
| `ggml-org/gemma-4-E4B-it-GGUF.Q4_K_M.env` | 5.34 GB | Q4_K_M |
| `ggml-org/gemma-4-E4B-it-GGUF.Q8_0.env` | 8.03 GB | Q8_0 |
| `ggml-org/gemma-4-E4B-it-GGUF.F16.env` | 15.1 GB | F16 |

**ALIAS:** `gemma-4-e4b-it`
**Sources:** [ggml-org/gemma-4-E4B-it-GGUF](https://huggingface.co/ggml-org/gemma-4-E4B-it-GGUF) · [google/gemma-4-E4B-it](https://huggingface.co/google/gemma-4-E4B-it)

#### 26B-A4B Instruct (MoE, 26B total / 4B active)

| Model | Size | Format |
| --- | --- | --- |
| `ggml-org/gemma-4-26B-A4B-it-GGUF.Q4_K_M.env` | 16.8 GB | Q4_K_M |
| `ggml-org/gemma-4-26B-A4B-it-GGUF.Q8_0.env` | 26.9 GB | Q8_0 |
| `ggml-org/gemma-4-26B-A4B-it-GGUF.F16.env` | 50.5 GB | F16 |

**ALIAS:** `gemma-4-26b-a4b-it`
**Sources:** [ggml-org/gemma-4-26B-A4B-it-GGUF](https://huggingface.co/ggml-org/gemma-4-26B-A4B-it-GGUF) · [google/gemma-4-26B-A4B-it](https://huggingface.co/google/gemma-4-26B-A4B-it)

#### 31B Instruct

| Model | Size | Format |
| --- | --- | --- |
| `ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env` | 18.7 GB | Q4_K_M |
| `ggml-org/gemma-4-31B-it-GGUF.Q8_0.env` | 32.6 GB | Q8_0 |
| `ggml-org/gemma-4-31B-it-GGUF.F16.env` | 61.4 GB | F16 |

**ALIAS:** `gemma-4-31b-it`
**Sources:** [ggml-org/gemma-4-31B-it-GGUF](https://huggingface.co/ggml-org/gemma-4-31B-it-GGUF) · [google/gemma-4-31B-it](https://huggingface.co/google/gemma-4-31B-it)

---

### Qwen3.5 · Alibaba

#### Qwen3.5-0.8B · Official

Official Alibaba instruct weights in GGUF via bartowski. Multimodal — includes a vision encoder (`mmproj`) for image understanding.

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/Qwen_Qwen3.5-0.8B-GGUF.Q4_K_M.env` | 0.56 GB | Q4_K_M |
| `bartowski/Qwen_Qwen3.5-0.8B-GGUF.Q8_0.env` | 0.81 GB | Q8_0 |

**ALIAS:** `qwen3.5-0.8b`
**Sources:** [bartowski/Qwen_Qwen3.5-0.8B-GGUF](https://huggingface.co/bartowski/Qwen_Qwen3.5-0.8B-GGUF) · [Qwen/Qwen3.5-0.8B](https://huggingface.co/Qwen/Qwen3.5-0.8B)

#### Qwen3.5-2B · Official

Official Alibaba instruct weights in GGUF via bartowski. Multimodal — includes a vision encoder (`mmproj`) for image understanding.

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/Qwen_Qwen3.5-2B-GGUF.Q4_K_M.env` | 1.33 GB | Q4_K_M |
| `bartowski/Qwen_Qwen3.5-2B-GGUF.Q8_0.env` | 2.02 GB | Q8_0 |

**ALIAS:** `qwen3.5-2b`
**Sources:** [bartowski/Qwen_Qwen3.5-2B-GGUF](https://huggingface.co/bartowski/Qwen_Qwen3.5-2B-GGUF) · [Qwen/Qwen3.5-2B](https://huggingface.co/Qwen/Qwen3.5-2B)

#### Qwen3.5-4B · Official

Official Alibaba instruct weights in GGUF via bartowski. Multimodal — includes a vision encoder (`mmproj`) for image understanding.

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/Qwen_Qwen3.5-4B-GGUF.Q4_K_M.env` | 2.87 GB | Q4_K_M |
| `bartowski/Qwen_Qwen3.5-4B-GGUF.Q8_0.env` | 4.49 GB | Q8_0 |

**ALIAS:** `qwen3.5-4b`
**Sources:** [bartowski/Qwen_Qwen3.5-4B-GGUF](https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF) · [Qwen/Qwen3.5-4B](https://huggingface.co/Qwen/Qwen3.5-4B)

#### Qwen3.5-9B · HauhauCS Uncensored

Converted to GGUF by HauhauCS. Includes a vision encoder (`mmproj`) — Koda auto-detects it for multimodal use.

| Model | Size | Format |
| --- | --- | --- |
| `HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive.Q4_K_M.env` | ~5.1 GB | Q4_K_M |
| `HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive.Q8_0.env` | ~9.6 GB | Q8_0 |

**ALIAS:** `qwen3.5-9b`
**Source:** [HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive)

#### Qwen3.5-9B · Official

Official Alibaba instruct weights in GGUF via bartowski. Multimodal — includes a vision encoder (`mmproj`) for image understanding. Use this model for the standard (non-uncensored) version.

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/Qwen_Qwen3.5-9B-GGUF.Q4_K_M.env` | 5.89 GB | Q4_K_M |
| `bartowski/Qwen_Qwen3.5-9B-GGUF.Q8_0.env` | 9.55 GB | Q8_0 |

**ALIAS:** `qwen3.5-9b`
**Sources:** [bartowski/Qwen_Qwen3.5-9B-GGUF](https://huggingface.co/bartowski/Qwen_Qwen3.5-9B-GGUF) · [Qwen/Qwen3.5-9B](https://huggingface.co/Qwen/Qwen3.5-9B)

> Both the HauhauCS and Official variants share the alias `qwen3.5-9b`. Only serve one at a time — whichever you start with `make serve` is what clients will see.

#### Qwen3.5-35B-A3B · HauhauCS Uncensored (MoE, 3B activated)

Uncensored GGUF conversion by HauhauCS. Includes a vision encoder (`mmproj`) — Koda auto-detects it for multimodal use.

| Model | Size | Format |
| --- | --- | --- |
| `HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive.Q4_K_M.env` | ~20 GB | Q4_K_M |
| `HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive.Q8_0.env` | ~37 GB | Q8_0 |

**ALIAS:** `qwen3.5-35b-a3b`
**Source:** [HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive)

#### Qwen3.5-35B-A3B · Official (MoE, 3B activated)

Official Alibaba weights in GGUF via Unsloth. Unified vision-language model with 201-language support and up to 262k native context. Use this model for the standard (non-uncensored) version.

| Model | Size | Format |
| --- | --- | --- |
| `unsloth/Qwen3.5-35B-A3B-GGUF.Q4_K_M.env` | 22 GB | Q4_K_M |
| `unsloth/Qwen3.5-35B-A3B-GGUF.Q8_0.env` | 36.9 GB | Q8_0 |

**ALIAS:** `qwen3.5-35b-a3b`
**Sources:** [unsloth/Qwen3.5-35B-A3B-GGUF](https://huggingface.co/unsloth/Qwen3.5-35B-A3B-GGUF) · [Qwen/Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B)

> Both the HauhauCS and Official variants share the alias `qwen3.5-35b-a3b`. Only serve one at a time — whichever you start with `make serve` is what clients will see.

#### Qwen3.5-27B · Claude 4.6 Opus Reasoning Distilled

Reasoning-focused 27B distill. Includes a vision encoder (`mmproj-BF16.gguf`) — Koda auto-detects it for multimodal use. GGUF published by Jackrong alongside the original weights.

| Model | Size | Format |
| --- | --- | --- |
| `Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q2_K.env` | 10.12 GB | Q2_K |
| `Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q3_K_M.env` | 13.29 GB | Q3_K_M |
| `Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q4_K_M.env` | 16.54 GB | Q4_K_M |
| `Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q8_0.env` | 28.60 GB | Q8_0 |

**ALIAS:** `qwen3.5-27b`
**Sources:** [Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF) · [Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled)

#### Qwen3.5-27B · Official

Official Alibaba instruct weights in GGUF via bartowski. Multimodal — includes a vision encoder (`mmproj`) for image understanding. Use this model for the standard (non-distilled) version.

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/Qwen_Qwen3.5-27B-GGUF.Q4_K_M.env` | 17.13 GB | Q4_K_M |
| `bartowski/Qwen_Qwen3.5-27B-GGUF.Q8_0.env` | 28.67 GB | Q8_0 |

**ALIAS:** `qwen3.5-27b`
**Sources:** [bartowski/Qwen_Qwen3.5-27B-GGUF](https://huggingface.co/bartowski/Qwen_Qwen3.5-27B-GGUF) · [Qwen/Qwen3.5-27B](https://huggingface.co/Qwen/Qwen3.5-27B)

> Both the Jackrong Reasoning Distilled and Official variants share the alias `qwen3.5-27b`. Only serve one at a time — whichever you start with `make serve` is what clients will see.

#### Qwen3.5-122B-A10B (MoE, 122B total / 10B active)

Official Alibaba MoE instruct weights in GGUF via bartowski. Multimodal — includes a vision encoder (`mmproj`) for image understanding.

| Model | Size | Format | Notes |
| --- | --- | --- | --- |
| `bartowski/Qwen_Qwen3.5-122B-A10B-GGUF.IQ2_XXS.env` | 33.80 GB | IQ2_XXS | Single file |
| `bartowski/Qwen_Qwen3.5-122B-A10B-GGUF.Q4_K_M.env` | 74.99 GB | Q4_K_M | 2 shards |

**ALIAS:** `qwen3.5-122b-a10b`
**Sources:** [bartowski/Qwen_Qwen3.5-122B-A10B-GGUF](https://huggingface.co/bartowski/Qwen_Qwen3.5-122B-A10B-GGUF) · [Qwen/Qwen3.5-122B-A10B](https://huggingface.co/Qwen/Qwen3.5-122B-A10B)

#### Qwen3.5-397B-A17B (MoE, 397B total / 17B active)

Official Alibaba flagship MoE instruct weights in GGUF via bartowski. Multimodal — includes a vision encoder (`mmproj`) for image understanding. Requires extreme hardware for the Q4_K_M variant.

| Model | Size | Format | Shards |
| --- | --- | --- | --- |
| `bartowski/Qwen_Qwen3.5-397B-A17B-GGUF.IQ2_XXS.env` | 106.57 GB | IQ2_XXS | 3 |
| `bartowski/Qwen_Qwen3.5-397B-A17B-GGUF.Q4_K_M.env` | 241.87 GB | Q4_K_M | 7 |

**ALIAS:** `qwen3.5-397b-a17b`
**Hardware:** 128 GB+ (IQ2_XXS) or 256 GB+ unified memory / multi-GPU (Q4_K_M)
**Sources:** [bartowski/Qwen_Qwen3.5-397B-A17B-GGUF](https://huggingface.co/bartowski/Qwen_Qwen3.5-397B-A17B-GGUF) · [Qwen/Qwen3.5-397B-A17B](https://huggingface.co/Qwen/Qwen3.5-397B-A17B)

---

### Qwen3.6 · Alibaba

#### Qwen3.6-27B · Official (Dense, 27B)

Official Alibaba weights in GGUF via bartowski. Multimodal — includes a vision encoder (`mmproj`) for image understanding. Hybrid architecture (Gated DeltaNet + Gated Attention), 262k native context extensible to 1M tokens. Reasoning with thinking modes, tool calling support.

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/Qwen_Qwen3.6-27B-GGUF.Q4_K_M.env` | 17.53 GB | Q4_K_M |
| `bartowski/Qwen_Qwen3.6-27B-GGUF.Q8_0.env` | 28.67 GB | Q8_0 |

**ALIAS:** `qwen3.6-27b`
**Sources:** [bartowski/Qwen_Qwen3.6-27B-GGUF](https://huggingface.co/bartowski/Qwen_Qwen3.6-27B-GGUF) · [Qwen/Qwen3.6-27B](https://huggingface.co/Qwen/Qwen3.6-27B)

#### Qwen3.6-35B-A3B · Official (MoE, 35B total / 3B active)

Official Alibaba weights in GGUF via bartowski. Multimodal — includes a vision encoder (`mmproj`) for image understanding. 262k native context, extensible to 1M tokens. Agentic coding focus with tool use and thinking preservation.

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/Qwen_Qwen3.6-35B-A3B-GGUF.Q4_K_M.env` | 21.39 GB | Q4_K_M |
| `bartowski/Qwen_Qwen3.6-35B-A3B-GGUF.Q8_0.env` | 36.91 GB | Q8_0 |

**ALIAS:** `qwen3.6-35b-a3b`
**Sources:** [bartowski/Qwen_Qwen3.6-35B-A3B-GGUF](https://huggingface.co/bartowski/Qwen_Qwen3.6-35B-A3B-GGUF) · [Qwen/Qwen3.6-35B-A3B](https://huggingface.co/Qwen/Qwen3.6-35B-A3B)

> **FP8 variant:** `Qwen/Qwen3.6-35B-A3B-FP8` is a safetensors FP8 format for vLLM/SGLang — not compatible with llama.cpp. Use the GGUF models above.

---

### GPT-OSS · OpenAI

OpenAI's open-source model family, official GGUFs from ggml-org. Both use harmony-style prompting; Koda's default `PROMPT_FORMAT=jinja` handles it automatically.

#### GPT-OSS 20B

| Model | Size | Format |
| --- | --- | --- |
| `ggml-org/gpt-oss-20b-GGUF.MXFP4.env` | 12.1 GB | MXFP4 |

**ALIAS:** `gpt-oss-20b`
**Sources:** [ggml-org/gpt-oss-20b-GGUF](https://huggingface.co/ggml-org/gpt-oss-20b-GGUF) · [openai/gpt-oss-20b](https://huggingface.co/openai/gpt-oss-20b)

#### GPT-OSS 120B

Sharded across 3 GGUF files. Requires roughly 80 GB of VRAM/RAM for full GPU acceleration.

| Model | Size | Format |
| --- | --- | --- |
| `ggml-org/gpt-oss-120b-GGUF.MXFP4.env` | 63.4 GB (3 shards) | MXFP4 |

**ALIAS:** `gpt-oss-120b`
**Sources:** [ggml-org/gpt-oss-120b-GGUF](https://huggingface.co/ggml-org/gpt-oss-120b-GGUF) · [openai/gpt-oss-120b](https://huggingface.co/openai/gpt-oss-120b)

---

### DeepSeek-R1 · DeepSeek

#### DeepSeek-R1 671B (MoE, 671B total / 37B active)

The full DeepSeek-R1. Requires extreme hardware — 192 GB minimum for the smallest quantization. All variants are sharded across multiple GGUF files; llama-server loads them automatically from the first shard. Outputs reasoning in `<think>...</think>` blocks before the final answer. Avoid system prompts; let the model open with `<think>` naturally.

Unsloth Dynamic (`UD-*`) models use per-layer mixed precision — critical matrices are kept at higher bits while the MoE experts are compressed more aggressively. This gives meaningfully better quality than naive same-bit quants at an equivalent size, and is the recommended source for sub-256 GB variants.

| Model | Size | Format | Source | Shards |
| --- | --- | --- | --- | --- |
| `unsloth/DeepSeek-R1-GGUF-UD.UD-IQ1_S.env` | 185 GB | UD-IQ1_S | unsloth | 4 |
| `unsloth/DeepSeek-R1-GGUF-UD.UD-IQ2_XXS.env` | 216 GB | UD-IQ2_XXS | unsloth | 5 |
| `unsloth/DeepSeek-R1-GGUF-UD.UD-Q2_K_XL.env` | 250 GB | UD-Q2_K_XL | unsloth | 6 |
| `bartowski/DeepSeek-R1-GGUF.Q3_K_M.env` | 319 GB | Q3_K_M | bartowski | 9 |

**ALIAS:** `deepseek-r1`
**Hardware:** 192 GB+ unified memory (M2/M3 Ultra) or multi-GPU with NVLink / RPC pooling
**Sampling:** `TEMP=0.6`, `TOP_P=0.95` (Koda defaults match DeepSeek's recommendation)
**Sources:** [unsloth/DeepSeek-R1-GGUF-UD](https://huggingface.co/unsloth/DeepSeek-R1-GGUF-UD) · [bartowski/DeepSeek-R1-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-GGUF) · [deepseek-ai/DeepSeek-R1](https://huggingface.co/deepseek-ai/DeepSeek-R1)

#### DeepSeek-R1-0528 671B (MoE, updated May 2025)

Updated release of the full 671B model with improved reasoning. Same hardware requirements as the original R1 671B — 192 GB minimum. Sharded across 11 files.

| Model | Size | Format | Shards |
| --- | --- | --- | --- |
| `lmstudio-community/DeepSeek-R1-0528-GGUF.Q4_K_M.env` | ~409 GB | Q4_K_M | 11 |

**ALIAS:** `deepseek-r1-0528`
**Sources:** [lmstudio-community/DeepSeek-R1-0528-GGUF](https://huggingface.co/lmstudio-community/DeepSeek-R1-0528-GGUF) · [deepseek-ai/DeepSeek-R1-0528](https://huggingface.co/deepseek-ai/DeepSeek-R1-0528)

#### Distill Series

Smaller distilled checkpoints from R1 671B — practical for most hardware. All output reasoning in `<think>...</think>` blocks. Avoid system prompts; let the model open with `<think>` naturally. All models sourced from bartowski (Qwen/Llama base) or unsloth (0528 variant).

##### Qwen-1.5B

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF.Q4_K_M.env` | 1.12 GB | Q4_K_M |
| `bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF.Q8_0.env` | 1.89 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-qwen-1.5b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B)

##### Qwen-7B

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF.Q4_K_M.env` | 4.68 GB | Q4_K_M |
| `bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF.Q8_0.env` | 8.10 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-qwen-7b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Qwen-7B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B)

##### Llama-8B

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF.Q4_K_M.env` | 4.92 GB | Q4_K_M |
| `bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF.Q8_0.env` | 8.54 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-llama-8b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Llama-8B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Llama-8B)

##### Qwen-14B

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF.Q4_K_M.env` | 8.99 GB | Q4_K_M |
| `bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF.Q8_0.env` | 15.70 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-qwen-14b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Qwen-14B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B)

##### Qwen-32B

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF.Q4_K_M.env` | 19.85 GB | Q4_K_M |
| `ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF.Q8_0.env` | 34.82 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-qwen-32b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF) · [ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF](https://huggingface.co/ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Qwen-32B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B)

##### Llama-70B

| Model | Size | Format | Notes |
| --- | --- | --- | --- |
| `bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF.Q4_K_M.env` | 42.52 GB | Q4_K_M | Single file |
| `bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF.Q8_0.env` | 74.98 GB | Q8_0 | 2 shards |

**ALIAS:** `deepseek-r1-distill-llama-70b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Llama-70B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Llama-70B)

##### DeepSeek-R1-0528-Qwen3-8B

Distilled from the updated May 2025 R1. Uses Qwen3-8B as the student model — benefits from Qwen3's stronger base compared to earlier distills.

| Model | Size | Format |
| --- | --- | --- |
| `unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF.Q4_K_M.env` | 5.03 GB | Q4_K_M |
| `unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF.Q8_0.env` | 8.71 GB | Q8_0 |

**ALIAS:** `deepseek-r1-0528-qwen3-8b`
**Sources:** [unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF](https://huggingface.co/unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF) · [deepseek-ai/DeepSeek-R1-0528-Qwen3-8B](https://huggingface.co/deepseek-ai/DeepSeek-R1-0528-Qwen3-8B)

> **nvidia/DeepSeek-R1-NVFP4:** Uses NVIDIA's proprietary NVFP4 format requiring TensorRT-LLM or the Salamander fork — not compatible with standard llama.cpp. Not supported here.

---

### Nemotron · NVIDIA

NVIDIA's Nemotron family — Mamba-2 + MoE hybrid architecture (LatentMoE). GGUFs sourced from ggml-org (official) and community converters (unsloth, lmstudio-community). Well-suited for Apple Silicon with large unified memory (M-series Ultra scales to 192 GB).

#### Nemotron-3-Nano-4B

Small single-file model from NVIDIA. Official GGUF published directly by NVIDIA. Hybrid Mamba-2 + MoE + Attention architecture (`nemotron_h`), 1M native context window, reasoning output in `<think>...</think>` blocks.

| Model | Size | Format |
| --- | --- | --- |
| `nvidia/NVIDIA-Nemotron-3-Nano-4B-GGUF.Q4_K_M.env` | 2.84 GB | Q4_K_M |

**ALIAS:** `nemotron-3-nano-4b`
**Sources:** [nvidia/NVIDIA-Nemotron-3-Nano-4B-GGUF](https://huggingface.co/nvidia/NVIDIA-Nemotron-3-Nano-4B-GGUF) · [nvidia/NVIDIA-Nemotron-3-Nano-4B-BF16](https://huggingface.co/nvidia/NVIDIA-Nemotron-3-Nano-4B-BF16)

#### Nemotron-Cascade-2-30B (MoE, 30B total / 3B active)

Second-generation Cascade model (March 2026). Same hybrid Mamba-2 + MoE architecture as Nemotron-3, with improved reasoning. Outputs reasoning in `<think>...</think>` blocks. GGUFs from bartowski.

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF.Q4_K_M.env` | 24.73 GB | Q4_K_M |
| `bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF.Q8_0.env` | 33.59 GB | Q8_0 |

**ALIAS:** `nemotron-cascade-2-30b`
**Sources:** [bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF](https://huggingface.co/bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF) · [nvidia/Nemotron-Cascade-2-30B-A3B](https://huggingface.co/nvidia/Nemotron-Cascade-2-30B-A3B)

> **FP8 / NVFP4 / Base variants:** The `nvidia/` FP8, NVFP4, and Base repos are not compatible with standard llama.cpp — FP8/NVFP4 use NVIDIA's modelopt format requiring TensorRT-LLM; Base models lack instruction tuning. Use the GGUF models above.

#### Nemotron-Nano-3-30B (MoE, 30B total / 3.5B active)

Instruct variant. Q4_K_M and Q8_0 from ggml-org (official); F16 and BF16 from community converters.

| Model | Size | Format | Source |
| --- | --- | --- | --- |
| `ggml-org/Nemotron-Nano-3-30B-A3B-GGUF.Q4_K_M.env` | 24.5 GB | Q4_K_M | ggml-org |
| `ggml-org/Nemotron-Nano-3-30B-A3B-GGUF.Q8_0.env` | 33.6 GB | Q8_0 | ggml-org |
| `lmstudio-community/NVIDIA-Nemotron-3-Nano-30B-A3B-GGUF.F16.env` | 63.1 GB | F16 | lmstudio-community (2 shards) |
| `unsloth/Nemotron-3-Nano-30B-A3B-GGUF.BF16.env` | 63.2 GB | BF16 | unsloth (2 shards) |

**ALIAS:** `nemotron-nano-3-30b`
**Sources:** [ggml-org/Nemotron-Nano-3-30B-A3B-GGUF](https://huggingface.co/ggml-org/Nemotron-Nano-3-30B-A3B-GGUF) · [lmstudio-community/NVIDIA-Nemotron-3-Nano-30B-A3B-GGUF](https://huggingface.co/lmstudio-community/NVIDIA-Nemotron-3-Nano-30B-A3B-GGUF) · [unsloth/Nemotron-3-Nano-30B-A3B-GGUF](https://huggingface.co/unsloth/Nemotron-3-Nano-30B-A3B-GGUF) · [nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B-BF16](https://huggingface.co/nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B-BF16)

#### Nemotron-3-Super-120B (MoE, 120B total / 12B active)

Instruct variant. Q4_K from ggml-org (official); Q4_K_M and Q8_0 from unsloth.

| Model | Size | Format | Source |
| --- | --- | --- | --- |
| `ggml-org/Nemotron-3-Super-120B-GGUF.Q4_K.env` | 69.9 GB | Q4_K | ggml-org |
| `unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF.Q4_K_M.env` | 82.5 GB | Q4_K_M | unsloth (3 shards) |
| `unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF.Q8_0.env` | 128.5 GB | Q8_0 | unsloth (4 shards) |

**ALIAS:** `nemotron-3-super-120b`
**Hardware:** Requires 192 GB+ unified memory or NVIDIA 80 GB+ GPU (Q8_0 needs 192 GB+).
**Sources:** [ggml-org/Nemotron-3-Super-120B-GGUF](https://huggingface.co/ggml-org/Nemotron-3-Super-120B-GGUF) · [unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF](https://huggingface.co/unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF) · [nvidia/NVIDIA-Nemotron-3-Super-120B-A12B-BF16](https://huggingface.co/nvidia/NVIDIA-Nemotron-3-Super-120B-A12B-BF16)

> **FP8 / NVFP4 / Base variants:** The `nvidia/` FP8 and NVFP4 instruct repos are alternative precisions of the same weights — use the GGUF models above. The NVFP4 GGUF requires the Salamander fork of llama.cpp and is not supported here. No GGUFs exist for the Base variants (`-Base-BF16`).

---

### MiniMax-M2.1 · MiniMax AI

~456B MoE (256 experts, 8 active, ~46B active per token), 192k native context. The agentic successor to M2.7 — significantly stronger on coding, tool use, and multilingual SWE tasks (SWE-bench Verified 74.0%, Multi-SWE-bench 49.4%). Reasoning model — outputs in `<think>...</think>` blocks. English and Chinese. GGUFs from bartowski (imatrix-calibrated).

| Model | Size | Format | Shards |
| --- | --- | --- | --- |
| `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.IQ2_XXS.env` | 54.73 GB | IQ2_XXS | 2 |
| `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.Q4_K_M.env` | 138.59 GB | Q4_K_M | 4 |
| `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.Q6_K.env` | 187.81 GB | Q6_K | 5 |

**ALIAS:** `minimax-m2.1`
**Sampling:** `TEMP=1.0`, `TOP_P=0.95` (from official `generation_config.json`)
**Sources:** [bartowski/MiniMaxAI_MiniMax-M2.1-GGUF](https://huggingface.co/bartowski/MiniMaxAI_MiniMax-M2.1-GGUF) · [MiniMaxAI/MiniMax-M2.1](https://huggingface.co/MiniMaxAI/MiniMax-M2.1)

---

### MiniMax-M2.7 · MiniMax AI

~230B MoE (256 experts, 8 active, ~10B active per token), 192k native context. Reasoning model — outputs in `<think>...</think>` blocks. Agentic focus: coding, tool use, multi-agent collaboration, office tasks. English and Chinese. GGUFs from bartowski (imatrix-calibrated, llama.cpp b8746+).

Despite the 230B total parameter count, only ~10B are active per forward pass — memory and compute requirements are much lighter than dense 230B models.

| Model | Size | Format | Shards |
| --- | --- | --- | --- |
| `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.IQ2_XXS.env` | 60.85 GB | IQ2_XXS | 2 |
| `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.Q4_K_M.env` | 138.81 GB | Q4_K_M | 4 |
| `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.Q6_K.env` | 197.05 GB | Q6_K | 5 |

**ALIAS:** `minimax-m2.7`
**Sampling:** `TEMP=1.0`, `TOP_P=0.95` (from official `generation_config.json`)
**Sources:** [bartowski/MiniMaxAI_MiniMax-M2.7-GGUF](https://huggingface.co/bartowski/MiniMaxAI_MiniMax-M2.7-GGUF) · [MiniMaxAI/MiniMax-M2.7](https://huggingface.co/MiniMaxAI/MiniMax-M2.7)

---

### GLM-4.7 · ZAI (Zhipu AI)

358B MoE (160 routed + 1 shared expert, 9 active per token, ~32B active), 202k native context. Reasoning model — outputs in `<think>...</think>` blocks with three thinking modes (interleaved, preserved, turn-level). Strong agentic coding (SWE-bench Verified 73.8%). Text-only, no mmproj. GGUFs from bartowski (imatrix-calibrated, llama.cpp b7475+).

GLM-4.7-Flash is the lightweight 30B-A3B MoE variant — single-file GGUFs suitable for 24–40 GB hardware.

#### GLM-4.7 (358B full)

| Model | Size | Format | Shards |
| --- | --- | --- | --- |
| `bartowski/zai-org_GLM-4.7-GGUF.IQ2_XXS.env` | 88.79 GB | IQ2_XXS | 3 |
| `bartowski/zai-org_GLM-4.7-GGUF.Q4_K_M.env` | 218.52 GB | Q4_K_M | 6 |

**ALIAS:** `glm-4.7`
**Hardware:** 96 GB+ (IQ2_XXS) or 220 GB+ unified memory / multi-GPU (Q4_K_M)
**Sources:** [bartowski/zai-org_GLM-4.7-GGUF](https://huggingface.co/bartowski/zai-org_GLM-4.7-GGUF) · [zai-org/GLM-4.7](https://huggingface.co/zai-org/GLM-4.7)

#### GLM-4.7-Flash (30B-A3B)

| Model | Size | Format |
| --- | --- | --- |
| `bartowski/zai-org_GLM-4.7-Flash-GGUF.Q4_K_M.env` | 18.47 GB | Q4_K_M |
| `bartowski/zai-org_GLM-4.7-Flash-GGUF.Q8_0.env` | 31.84 GB | Q8_0 |

**ALIAS:** `glm-4.7-flash`
**Sampling:** `TEMP=1.0`, `TOP_P=0.95`
**Sources:** [bartowski/zai-org_GLM-4.7-Flash-GGUF](https://huggingface.co/bartowski/zai-org_GLM-4.7-Flash-GGUF) · [zai-org/GLM-4.7](https://huggingface.co/zai-org/GLM-4.7)

---

### GLM-5.1 · ZAI (Zhipu AI)

754B-parameter MoE model with Dynamic Sparse Attention (DSA) and 202k native context. Reasoning model — outputs in `<think>...</think>` blocks. Agentic focus: coding, tool use, long-horizon tasks, and mathematical reasoning (SWE-Bench Pro 58.4%, AIME 2026 95.3%). English and Chinese. GGUFs from unsloth (Unsloth Dynamic 2.0, standard llama.cpp compatible).

Requires extreme hardware — 192 GB minimum even for the smallest quant. All variants are sharded across multiple GGUF files.

| Model | Size | Format | Shards |
| --- | --- | --- | --- |
| `unsloth/GLM-5.1-GGUF.UD-IQ1_M.env` | ~206 GB | UD-IQ1_M | 6 |
| `unsloth/GLM-5.1-GGUF.UD-IQ2_XXS.env` | ~221 GB | UD-IQ2_XXS | 6 |
| `unsloth/GLM-5.1-GGUF.UD-Q2_K_XL.env` | ~252 GB | UD-Q2_K_XL | 7 |

**ALIAS:** `glm-5.1`
**Hardware:** 192 GB+ unified memory (M2/M3 Ultra) or multi-GPU with NVLink / RPC pooling
**Sampling:** `TEMP=0.6`, `TOP_P=0.95` (standard reasoning model defaults)
**Sources:** [unsloth/GLM-5.1-GGUF](https://huggingface.co/unsloth/GLM-5.1-GGUF) · [zai-org/GLM-5.1](https://huggingface.co/zai-org/GLM-5.1)

---

### Kimi-K2.5 · Moonshot AI

1T-parameter MoE (32B activated). Extremely large — ~584 GB across 14 shards. Advanced model; treat as multi-machine or server-class hardware only.

| Model | Size | Format |
| --- | --- | --- |
| `AesSedai/Kimi-K2.5-GGUF.Q4_X.env` | ~584 GB (14 shards) | Q4_X |

**ALIAS:** `kimi-k2.5`
**Sampling:** `TEMP=1.0` (matches Moonshot AI's published evaluation setting)
**Sources:** [AesSedai/Kimi-K2.5-GGUF](https://huggingface.co/AesSedai/Kimi-K2.5-GGUF) · [moonshotai/Kimi-K2.5](https://huggingface.co/moonshotai/Kimi-K2.5)

---

### Kimi-K2.6 · Moonshot AI

1T-parameter MoE (32B activated), 256k native context. Successor to K2.5 — adds native multimodal support (MoonViT vision encoder, 400M), thinking mode with reasoning, and stronger agentic coding. Supports agent swarm orchestration (up to 300 sub-agents). GGUFs from AesSedai.

| Model | Size | Format |
| --- | --- | --- |
| `AesSedai/Kimi-K2.6-GGUF.Q4_X.env` | ~584 GB (14 shards) | Q4_X |

**ALIAS:** `kimi-k2.6`
**Sampling:** `TEMP=1.0`
**Sources:** [AesSedai/Kimi-K2.6-GGUF](https://huggingface.co/AesSedai/Kimi-K2.6-GGUF) · [moonshotai/Kimi-K2.6](https://huggingface.co/moonshotai/Kimi-K2.6)

---

## Recommended Starting Points

| Hardware | Recommended models |
| --- | --- |
| Any machine (4 GB+) | `bartowski/Qwen_Qwen3.5-0.8B-GGUF.Q8_0.env` (0.8 GB) · `bartowski/Qwen_Qwen3.5-2B-GGUF.Q4_K_M.env` (1.3 GB) · `bartowski/Qwen_Qwen3.5-4B-GGUF.Q4_K_M.env` (2.9 GB) |
| Any machine (8 GB+) | `ggml-org/gemma-4-E2B-it-GGUF.Q8_0.env` (5 GB) · `ggml-org/gemma-4-E4B-it-GGUF.Q4_K_M.env` (5.3 GB) · `bartowski/Qwen_Qwen3.5-4B-GGUF.Q8_0.env` (4.5 GB) |
| 8–16 GB VRAM / RAM | `nvidia/NVIDIA-Nemotron-3-Nano-4B-GGUF.Q4_K_M.env` (2.8 GB) · `bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF.Q8_0.env` (1.9 GB) · `bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF.Q4_K_M.env` (4.7 GB) · `bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF.Q4_K_M.env` (4.9 GB) · `unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF.Q4_K_M.env` (5 GB) · `bartowski/Qwen_Qwen3.5-9B-GGUF.Q4_K_M.env` (5.9 GB) |
| 16–24 GB VRAM / RAM | `bartowski/zai-org_GLM-4.7-Flash-GGUF.Q4_K_M.env` (18 GB) · `bartowski/Qwen_Qwen3.6-27B-GGUF.Q4_K_M.env` (18 GB) · `bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF.Q4_K_M.env` (9 GB) · `ggml-org/gpt-oss-20b-GGUF.MXFP4.env` (12 GB) · `ggml-org/gemma-4-26B-A4B-it-GGUF.Q4_K_M.env` (17 GB) |
| 24–32 GB VRAM / RAM | `bartowski/zai-org_GLM-4.7-Flash-GGUF.Q8_0.env` (32 GB) · `bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF.Q4_K_M.env` (25 GB) · `ggml-org/Nemotron-Nano-3-30B-A3B-GGUF.Q4_K_M.env` (25 GB) · `bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF.Q4_K_M.env` (20 GB) · `bartowski/Qwen_Qwen3.6-35B-A3B-GGUF.Q4_K_M.env` (21 GB) |
| 32–48 GB VRAM / RAM | `Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q4_K_M.env` (17 GB) · `bartowski/Qwen_Qwen3.6-27B-GGUF.Q8_0.env` (29 GB) · `ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env` (19 GB) · `ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF.Q8_0.env` (35 GB) · `bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF.Q8_0.env` (34 GB) |
| 64–96 GB VRAM / RAM | `bartowski/zai-org_GLM-4.7-GGUF.IQ2_XXS.env` (89 GB) · `bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF.Q4_K_M.env` (43 GB) · `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.IQ2_XXS.env` (55 GB) · `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.IQ2_XXS.env` (61 GB) · `ggml-org/gemma-4-26B-A4B-it-GGUF.F16.env` (51 GB) · `bartowski/Qwen_Qwen3.5-122B-A10B-GGUF.IQ2_XXS.env` (34 GB) · `bartowski/Qwen_Qwen3.5-122B-A10B-GGUF.Q4_K_M.env` (75 GB) |
| 128–192 GB VRAM / RAM | `ggml-org/Nemotron-3-Super-120B-GGUF.Q4_K.env` (70 GB) · `ggml-org/gpt-oss-120b-GGUF.MXFP4.env` (63 GB) · `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.Q4_K_M.env` (139 GB) · `bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.Q4_K_M.env` (139 GB) · `bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.Q6_K.env` (188 GB) · `bartowski/Qwen_Qwen3.5-397B-A17B-GGUF.IQ2_XXS.env` (107 GB) |
| 192–256 GB unified memory | `bartowski/zai-org_GLM-4.7-GGUF.Q4_K_M.env` (219 GB) · `unsloth/DeepSeek-R1-GGUF-UD.UD-IQ1_S.env` (185 GB) · `unsloth/DeepSeek-R1-GGUF-UD.UD-IQ2_XXS.env` (216 GB) · `unsloth/GLM-5.1-GGUF.UD-IQ1_M.env` (~206 GB) · `unsloth/GLM-5.1-GGUF.UD-IQ2_XXS.env` (~221 GB) · `unsloth/DeepSeek-R1-GGUF-UD.UD-Q2_K_XL.env` (250 GB) · `unsloth/GLM-5.1-GGUF.UD-Q2_K_XL.env` (~252 GB) · `bartowski/Qwen_Qwen3.5-397B-A17B-GGUF.Q4_K_M.env` (242 GB) |
| 320 GB+ / multi-GPU | `bartowski/DeepSeek-R1-GGUF.Q3_K_M.env` (319 GB) |
| Multi-machine / extreme scale | `AesSedai/Kimi-K2.5-GGUF.Q4_X.env` (~584 GB) · `AesSedai/Kimi-K2.6-GGUF.Q4_X.env` (~584 GB) |

---

## API Identity (Aliases)

Models set `ALIAS` to give the model a clean, stable ID in the OpenAI-compatible API. This lets external tools (OpenCode, VS Code Copilot) keep a fixed config even when you swap quantizations — the alias stays the same across Q4 and Q8 variants of the same model.

Use `make export-opencode ENV=<model>` or `make export-vscode ENV=<model>` to generate the config snippet for any model. Full integration guides: [OPENCODE.md](../OPENCODE.md), [VSCODE.md](../VSCODE.md), [CURSOR.md](../CURSOR.md).
