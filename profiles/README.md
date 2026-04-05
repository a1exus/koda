# Bundled Profiles

Each profile is a `.env-*` file in `profiles/` that configures `make download`, `make serve`, and `make chat` for a specific model and quantization.

Run `make list` to see all profiles with their aliases, or `make select` for an interactive picker.

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

GGUF models are quantized — their weights are compressed to reduce memory use with minimal quality loss. The format appears at the end of each profile filename.

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

| Profile | Size | Format |
| --- | --- | --- |
| `.env-gemma-4-E2B-it.Q8_0` | 4.97 GB | Q8_0 |
| `.env-gemma-4-E2B-it.F16` | 9.31 GB | F16 |

**ALIAS:** `gemma-4-e2b-it`
**Sources:** [ggml-org/gemma-4-E2B-it-GGUF](https://huggingface.co/ggml-org/gemma-4-E2B-it-GGUF) · [google/gemma-4-E2B-it](https://huggingface.co/google/gemma-4-E2B-it)

#### E4B Instruct (8B)

| Profile | Size | Format |
| --- | --- | --- |
| `.env-gemma-4-E4B-it.Q4_K_M` | 5.34 GB | Q4_K_M |
| `.env-gemma-4-E4B-it.Q8_0` | 8.03 GB | Q8_0 |
| `.env-gemma-4-E4B-it.F16` | 15.1 GB | F16 |

**ALIAS:** `gemma-4-e4b-it`
**Sources:** [ggml-org/gemma-4-E4B-it-GGUF](https://huggingface.co/ggml-org/gemma-4-E4B-it-GGUF) · [google/gemma-4-E4B-it](https://huggingface.co/google/gemma-4-E4B-it)

#### 26B-A4B Instruct (MoE, 26B total / 4B active)

| Profile | Size | Format |
| --- | --- | --- |
| `.env-gemma-4-26B-A4B-it.Q4_K_M` | 16.8 GB | Q4_K_M |
| `.env-gemma-4-26B-A4B-it.Q8_0` | 26.9 GB | Q8_0 |
| `.env-gemma-4-26B-A4B-it.F16` | 50.5 GB | F16 |

**ALIAS:** `gemma-4-26b-a4b-it`
**Sources:** [ggml-org/gemma-4-26B-A4B-it-GGUF](https://huggingface.co/ggml-org/gemma-4-26B-A4B-it-GGUF) · [google/gemma-4-26B-A4B-it](https://huggingface.co/google/gemma-4-26B-A4B-it)

#### 31B Instruct

| Profile | Size | Format |
| --- | --- | --- |
| `.env-gemma-4-31B-it.Q4_K_M` | 18.7 GB | Q4_K_M |
| `.env-gemma-4-31B-it.Q8_0` | 32.6 GB | Q8_0 |
| `.env-gemma-4-31B-it.F16` | 61.4 GB | F16 |

**ALIAS:** `gemma-4-31b-it`
**Sources:** [ggml-org/gemma-4-31B-it-GGUF](https://huggingface.co/ggml-org/gemma-4-31B-it-GGUF) · [google/gemma-4-31B-it](https://huggingface.co/google/gemma-4-31B-it)

---

### Qwen3.5 · Alibaba

#### Qwen3.5-9B · HauhauCS Uncensored

Converted to GGUF by HauhauCS. Includes a vision encoder (`mmproj`) — Koda auto-detects it for multimodal use.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Qwen3.5-9B.Q4_K_M` | ~5.1 GB | Q4_K_M |
| `.env-Qwen3.5-9B.Q8_0` | ~9.6 GB | Q8_0 |

**ALIAS:** `qwen3.5-9b`
**Source:** [HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive)

#### Qwen3.5-35B-A3B · HauhauCS Uncensored (MoE, 3B activated)

Uncensored GGUF conversion by HauhauCS. Includes a vision encoder (`mmproj`) — Koda auto-detects it for multimodal use.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Qwen3.5-35B-A3B.Q4_K_M` | ~20 GB | Q4_K_M |
| `.env-Qwen3.5-35B-A3B.Q8_0` | ~37 GB | Q8_0 |

**ALIAS:** `qwen3.5-35b-a3b`
**Source:** [HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive)

#### Qwen3.5-35B-A3B · Official (MoE, 3B activated)

Official Alibaba weights in GGUF via Unsloth. Unified vision-language model with 201-language support and up to 262k native context. Use this profile for the standard (non-uncensored) version.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Qwen3.5-35B-A3B-Qwen.Q4_K_M` | 22 GB | Q4_K_M |
| `.env-Qwen3.5-35B-A3B-Qwen.Q8_0` | 36.9 GB | Q8_0 |

**ALIAS:** `qwen3.5-35b-a3b`
**Sources:** [unsloth/Qwen3.5-35B-A3B-GGUF](https://huggingface.co/unsloth/Qwen3.5-35B-A3B-GGUF) · [Qwen/Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B)

> Both the HauhauCS and Official variants share the alias `qwen3.5-35b-a3b`. Only serve one at a time — whichever you start with `make serve` is what clients will see.

#### Qwen3.5-27B · Claude 4.6 Opus Reasoning Distilled

Reasoning-focused 27B distill. Includes a vision encoder (`mmproj-BF16.gguf`) — Koda auto-detects it for multimodal use. GGUF published by Jackrong alongside the original weights.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Qwen3.5-27B.Q4_K_M` | 16.5 GB | Q4_K_M |
| `.env-Qwen3.5-27B.Q8_0` | 28.6 GB | Q8_0 |

**ALIAS:** `qwen3.5-27b`
**Sources:** [Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF) · [Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled)

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

### DeepSeek-R1 · DeepSeek

#### DeepSeek-R1 671B (MoE, 671B total / 37B active)

The full DeepSeek-R1. Requires extreme hardware — 192 GB minimum for the smallest quantization. All variants are sharded across multiple GGUF files; llama-server loads them automatically from the first shard. Outputs reasoning in `<think>...</think>` blocks before the final answer. Avoid system prompts; let the model open with `<think>` naturally.

Unsloth Dynamic (`UD-*`) profiles use per-layer mixed precision — critical matrices are kept at higher bits while the MoE experts are compressed more aggressively. This gives meaningfully better quality than naive same-bit quants at an equivalent size, and is the recommended source for sub-256 GB variants.

| Profile | Size | Format | Source | Shards |
| --- | --- | --- | --- | --- |
| `.env-DeepSeek-R1.UD-IQ1_S` | 185 GB | UD-IQ1_S | unsloth | 4 |
| `.env-DeepSeek-R1.UD-IQ2_XXS` | 216 GB | UD-IQ2_XXS | unsloth | 5 |
| `.env-DeepSeek-R1.UD-Q2_K_XL` | 250 GB | UD-Q2_K_XL | unsloth | 6 |
| `.env-DeepSeek-R1.Q3_K_M` | 319 GB | Q3_K_M | bartowski | 9 |

**ALIAS:** `deepseek-r1`
**Hardware:** 192 GB+ unified memory (M2/M3 Ultra) or multi-GPU with NVLink / RPC pooling
**Sampling:** `TEMP=0.6`, `TOP_P=0.95` (Koda defaults match DeepSeek's recommendation)
**Sources:** [unsloth/DeepSeek-R1-GGUF-UD](https://huggingface.co/unsloth/DeepSeek-R1-GGUF-UD) · [bartowski/DeepSeek-R1-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-GGUF) · [deepseek-ai/DeepSeek-R1](https://huggingface.co/deepseek-ai/DeepSeek-R1)

#### DeepSeek-R1-0528 671B (MoE, updated May 2028)

Updated release of the full 671B model with improved reasoning. Same hardware requirements as the original R1 671B — 192 GB minimum. Sharded across 11 files.

| Profile | Size | Format | Shards |
| --- | --- | --- | --- |
| `.env-DeepSeek-R1-0528.Q4_K_M` | ~409 GB | Q4_K_M | 11 |

**ALIAS:** `deepseek-r1-0528`
**Sources:** [lmstudio-community/DeepSeek-R1-0528-GGUF](https://huggingface.co/lmstudio-community/DeepSeek-R1-0528-GGUF) · [deepseek-ai/DeepSeek-R1-0528](https://huggingface.co/deepseek-ai/DeepSeek-R1-0528)

#### Distill Series

Smaller distilled checkpoints from R1 671B — practical for most hardware. All output reasoning in `<think>...</think>` blocks. Avoid system prompts; let the model open with `<think>` naturally. All profiles sourced from bartowski (Qwen/Llama base) or unsloth (0528 variant).

##### Qwen-1.5B

| Profile | Size | Format |
| --- | --- | --- |
| `.env-DeepSeek-R1-Distill-Qwen-1.5B.Q4_K_M` | 1.12 GB | Q4_K_M |
| `.env-DeepSeek-R1-Distill-Qwen-1.5B.Q8_0` | 1.89 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-qwen-1.5b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B)

##### Qwen-7B

| Profile | Size | Format |
| --- | --- | --- |
| `.env-DeepSeek-R1-Distill-Qwen-7B.Q4_K_M` | 4.68 GB | Q4_K_M |
| `.env-DeepSeek-R1-Distill-Qwen-7B.Q8_0` | 8.10 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-qwen-7b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Qwen-7B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B)

##### Llama-8B

| Profile | Size | Format |
| --- | --- | --- |
| `.env-DeepSeek-R1-Distill-Llama-8B.Q4_K_M` | 4.92 GB | Q4_K_M |
| `.env-DeepSeek-R1-Distill-Llama-8B.Q8_0` | 8.54 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-llama-8b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Llama-8B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Llama-8B)

##### Qwen-14B

| Profile | Size | Format |
| --- | --- | --- |
| `.env-DeepSeek-R1-Distill-Qwen-14B.Q4_K_M` | 8.99 GB | Q4_K_M |
| `.env-DeepSeek-R1-Distill-Qwen-14B.Q8_0` | 15.70 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-qwen-14b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Qwen-14B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B)

##### Qwen-32B

| Profile | Size | Format |
| --- | --- | --- |
| `.env-DeepSeek-R1-Distill-Qwen-32B.Q4_K_M` | 19.85 GB | Q4_K_M |
| `.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` | 34.82 GB | Q8_0 |

**ALIAS:** `deepseek-r1-distill-qwen-32b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF) · [ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF](https://huggingface.co/ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Qwen-32B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B)

##### Llama-70B

| Profile | Size | Format | Notes |
| --- | --- | --- | --- |
| `.env-DeepSeek-R1-Distill-Llama-70B.Q4_K_M` | 42.52 GB | Q4_K_M | Single file |
| `.env-DeepSeek-R1-Distill-Llama-70B.Q8_0` | 74.98 GB | Q8_0 | 2 shards |

**ALIAS:** `deepseek-r1-distill-llama-70b`
**Sources:** [bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF](https://huggingface.co/bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF) · [deepseek-ai/DeepSeek-R1-Distill-Llama-70B](https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Llama-70B)

##### DeepSeek-R1-0528-Qwen3-8B

Distilled from the updated May 2028 R1. Uses Qwen3-8B as the student model — benefits from Qwen3's stronger base compared to earlier distills.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-DeepSeek-R1-0528-Qwen3-8B.Q4_K_M` | 5.03 GB | Q4_K_M |
| `.env-DeepSeek-R1-0528-Qwen3-8B.Q8_0` | 8.71 GB | Q8_0 |

**ALIAS:** `deepseek-r1-0528-qwen3-8b`
**Sources:** [unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF](https://huggingface.co/unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF) · [deepseek-ai/DeepSeek-R1-0528-Qwen3-8B](https://huggingface.co/deepseek-ai/DeepSeek-R1-0528-Qwen3-8B)

> **nvidia/DeepSeek-R1-NVFP4:** Uses NVIDIA's proprietary NVFP4 format requiring TensorRT-LLM or the Salamander fork — not compatible with standard llama.cpp. Not supported here.

---

### Nemotron · NVIDIA

NVIDIA's Nemotron family — Mamba-2 + MoE hybrid architecture (LatentMoE). GGUFs sourced from ggml-org (official) and community converters (unsloth, lmstudio-community). Well-suited for Apple Silicon with large unified memory (M-series Ultra scales to 192 GB).

#### Nemotron-Nano-3-30B (MoE, 30B total / 3.5B active)

Instruct variant. Q4_K_M and Q8_0 from ggml-org (official); F16 and BF16 from community converters.

| Profile | Size | Format | Source |
| --- | --- | --- | --- |
| `.env-Nemotron-Nano-3-30B.Q4_K_M` | 24.5 GB | Q4_K_M | ggml-org |
| `.env-Nemotron-Nano-3-30B.Q8_0` | 33.6 GB | Q8_0 | ggml-org |
| `.env-Nemotron-Nano-3-30B.F16` | 63.1 GB | F16 | lmstudio-community (2 shards) |
| `.env-Nemotron-Nano-3-30B.BF16` | 63.2 GB | BF16 | unsloth (2 shards) |

**ALIAS:** `nemotron-nano-3-30b`
**Sources:** [ggml-org/Nemotron-Nano-3-30B-A3B-GGUF](https://huggingface.co/ggml-org/Nemotron-Nano-3-30B-A3B-GGUF) · [lmstudio-community/NVIDIA-Nemotron-3-Nano-30B-A3B-GGUF](https://huggingface.co/lmstudio-community/NVIDIA-Nemotron-3-Nano-30B-A3B-GGUF) · [unsloth/Nemotron-3-Nano-30B-A3B-GGUF](https://huggingface.co/unsloth/Nemotron-3-Nano-30B-A3B-GGUF) · [nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B-BF16](https://huggingface.co/nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B-BF16)

#### Nemotron-3-Super-120B (MoE, 120B total / 12B active)

Instruct variant. Q4_K from ggml-org (official); Q4_K_M and Q8_0 from unsloth.

| Profile | Size | Format | Source |
| --- | --- | --- | --- |
| `.env-Nemotron-3-Super-120B.Q4_K` | 69.9 GB | Q4_K | ggml-org |
| `.env-Nemotron-3-Super-120B.Q4_K_M` | 82.5 GB | Q4_K_M | unsloth (3 shards) |
| `.env-Nemotron-3-Super-120B.Q8_0` | 128.5 GB | Q8_0 | unsloth (4 shards) |

**ALIAS:** `nemotron-3-super-120b`
**Hardware:** Requires 192 GB+ unified memory or NVIDIA 80 GB+ GPU (Q8_0 needs 192 GB+).
**Sources:** [ggml-org/Nemotron-3-Super-120B-GGUF](https://huggingface.co/ggml-org/Nemotron-3-Super-120B-GGUF) · [unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF](https://huggingface.co/unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF) · [nvidia/NVIDIA-Nemotron-3-Super-120B-A12B-BF16](https://huggingface.co/nvidia/NVIDIA-Nemotron-3-Super-120B-A12B-BF16)

> **FP8 / NVFP4 / Base variants:** The `nvidia/` FP8 and NVFP4 instruct repos are alternative precisions of the same weights — use the GGUF profiles above. The NVFP4 GGUF requires the Salamander fork of llama.cpp and is not supported here. No GGUFs exist for the Base variants (`-Base-BF16`).

---

### Kimi-K2.5 · Moonshot AI

1T-parameter MoE (32B activated). Extremely large — ~584 GB across 14 shards. Advanced profile; treat as multi-machine or server-class hardware only.

| Profile | Size | Format |
| --- | --- | --- |
| `.env-Kimi-K2.5.Q4_X` | ~584 GB (14 shards) | Q4_X |

**ALIAS:** `kimi-k2.5`
**Sampling:** `TEMP=1.0` (matches Moonshot AI's published evaluation setting)
**Sources:** [AesSedai/Kimi-K2.5-GGUF](https://huggingface.co/AesSedai/Kimi-K2.5-GGUF) · [moonshotai/Kimi-K2.5](https://huggingface.co/moonshotai/Kimi-K2.5)

---

## Recommended Starting Points

| Hardware | Recommended profiles |
| --- | --- |
| Any machine (8 GB+) | `.env-gemma-4-E2B-it.Q8_0` (5 GB) · `.env-gemma-4-E4B-it.Q4_K_M` (5.3 GB) |
| 16–24 GB VRAM / RAM | `.env-gpt-oss-20b.MXFP4` (12 GB) · `.env-gemma-4-26B-A4B-it.Q4_K_M` (17 GB) |
| 8–16 GB VRAM / RAM | `.env-DeepSeek-R1-Distill-Qwen-1.5B.Q8_0` (1.9 GB) · `.env-DeepSeek-R1-Distill-Qwen-7B.Q4_K_M` (4.7 GB) · `.env-DeepSeek-R1-Distill-Llama-8B.Q4_K_M` (4.9 GB) · `.env-DeepSeek-R1-0528-Qwen3-8B.Q4_K_M` (5 GB) |
| 16–24 GB VRAM / RAM | `.env-DeepSeek-R1-Distill-Qwen-14B.Q4_K_M` (9 GB) · `.env-gpt-oss-20b.MXFP4` (12 GB) · `.env-gemma-4-26B-A4B-it.Q4_K_M` (17 GB) |
| 32–48 GB VRAM / RAM | `.env-Qwen3.5-27B.Q4_K_M` (17 GB) · `.env-DeepSeek-R1-Distill-Qwen-32B.Q4_K_M` (20 GB) · `.env-gemma-4-31B-it.Q4_K_M` (19 GB) · `.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` (35 GB) |
| 64–96 GB VRAM / RAM | `.env-DeepSeek-R1-Distill-Llama-70B.Q4_K_M` (43 GB) · `.env-Nemotron-Nano-3-30B.Q8_0` (34 GB) · `.env-gemma-4-26B-A4B-it.F16` (51 GB) |
| 128–192 GB VRAM / RAM | `.env-Nemotron-3-Super-120B.Q4_K` (70 GB) · `.env-gpt-oss-120b.MXFP4` (63 GB) · `.env-gemma-4-31B-it.F16` (61 GB) |
| 192–256 GB unified memory | `.env-DeepSeek-R1.UD-IQ1_S` (185 GB) · `.env-DeepSeek-R1.UD-IQ2_XXS` (216 GB) · `.env-DeepSeek-R1.UD-Q2_K_XL` (250 GB) |
| 320 GB+ / multi-GPU | `.env-DeepSeek-R1.Q3_K_M` (319 GB) |
| Multi-machine / extreme scale | `.env-Kimi-K2.5.Q4_X` (~584 GB) |

---

## API Identity (Aliases)

Profiles set `ALIAS` to give the model a clean, stable ID in the OpenAI-compatible API. This lets external tools (OpenCode, VS Code Copilot) keep a fixed config even when you swap quantizations — the alias stays the same across Q4 and Q8 variants of the same model.

Use `make export-opencode ENV=<profile>` or `make export-vscode ENV=<profile>` to generate the config snippet for any profile. Full integration guides: [OPENCODE.md](../OPENCODE.md), [VSCODE.md](../VSCODE.md), [CURSOR.md](../CURSOR.md).
