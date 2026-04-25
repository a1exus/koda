# Profile Directory Restructure

Reorganize the flat `profiles/.env-*` layout into an org-based `models/<hf_org>/<hf_repo>.<quant>.env` hierarchy that mirrors HuggingFace repository URLs.

## Motivation

84 profile files in a single flat directory with inconsistent naming. The new layout groups by GGUF maintainer (HF org), making it easy to browse, discover, and add new models.

## Naming Convention

```
models/<HF_REPO_org>/<HF_REPO_name>.<quant>.env
```

Derived from the `HF_REPO` variable inside each profile. The quant suffix is extracted from the old filename (everything after the last dot preceding a non-digit character).

**Example:**
- Old: `profiles/.env-Qwen3.6-27B.Q4_K_M`
- `HF_REPO=bartowski/Qwen_Qwen3.6-27B-GGUF`
- New: `models/bartowski/Qwen_Qwen3.6-27B-GGUF.Q4_K_M.env`

## Directory Structure

8 org directories:

```
models/
  README.md
  AesSedai/          (1 file)
  bartowski/          (40 files)
  ggml-org/           (17 files)
  HauhauCS/           (4 files)
  Jackrong/           (4 files)
  lmstudio-community/ (2 files)
  nvidia/             (1 file)
  unsloth/            (15 files)
```

## Complete File Mapping

| Old Path | New Path |
|----------|----------|
| `profiles/.env-DeepSeek-R1-0528-Qwen3-8B.Q4_K_M` | `models/unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF.Q4_K_M.env` |
| `profiles/.env-DeepSeek-R1-0528-Qwen3-8B.Q8_0` | `models/unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF.Q8_0.env` |
| `profiles/.env-DeepSeek-R1-0528.Q4_K_M` | `models/lmstudio-community/DeepSeek-R1-0528-GGUF.Q4_K_M.env` |
| `profiles/.env-DeepSeek-R1-Distill-Llama-70B.Q4_K_M` | `models/bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF.Q4_K_M.env` |
| `profiles/.env-DeepSeek-R1-Distill-Llama-70B.Q8_0` | `models/bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF.Q8_0.env` |
| `profiles/.env-DeepSeek-R1-Distill-Llama-8B.Q4_K_M` | `models/bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF.Q4_K_M.env` |
| `profiles/.env-DeepSeek-R1-Distill-Llama-8B.Q8_0` | `models/bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF.Q8_0.env` |
| `profiles/.env-DeepSeek-R1-Distill-Qwen-1.5B.Q4_K_M` | `models/bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF.Q4_K_M.env` |
| `profiles/.env-DeepSeek-R1-Distill-Qwen-1.5B.Q8_0` | `models/bartowski/DeepSeek-R1-Distill-Qwen-1.5B-GGUF.Q8_0.env` |
| `profiles/.env-DeepSeek-R1-Distill-Qwen-14B.Q4_K_M` | `models/bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF.Q4_K_M.env` |
| `profiles/.env-DeepSeek-R1-Distill-Qwen-14B.Q8_0` | `models/bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF.Q8_0.env` |
| `profiles/.env-DeepSeek-R1-Distill-Qwen-32B.Q4_K_M` | `models/bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF.Q4_K_M.env` |
| `profiles/.env-DeepSeek-R1-Distill-Qwen-32B.Q8_0` | `models/ggml-org/DeepSeek-R1-Distill-Qwen-32B-Q8_0-GGUF.Q8_0.env` |
| `profiles/.env-DeepSeek-R1-Distill-Qwen-7B.Q4_K_M` | `models/bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF.Q4_K_M.env` |
| `profiles/.env-DeepSeek-R1-Distill-Qwen-7B.Q8_0` | `models/bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF.Q8_0.env` |
| `profiles/.env-DeepSeek-R1.Q3_K_M` | `models/bartowski/DeepSeek-R1-GGUF.Q3_K_M.env` |
| `profiles/.env-DeepSeek-R1.UD-IQ1_S` | `models/unsloth/DeepSeek-R1-GGUF-UD.UD-IQ1_S.env` |
| `profiles/.env-DeepSeek-R1.UD-IQ2_XXS` | `models/unsloth/DeepSeek-R1-GGUF-UD.UD-IQ2_XXS.env` |
| `profiles/.env-DeepSeek-R1.UD-Q2_K_XL` | `models/unsloth/DeepSeek-R1-GGUF-UD.UD-Q2_K_XL.env` |
| `profiles/.env-GLM-4.7-Flash.Q4_K_M` | `models/bartowski/zai-org_GLM-4.7-Flash-GGUF.Q4_K_M.env` |
| `profiles/.env-GLM-4.7-Flash.Q8_0` | `models/bartowski/zai-org_GLM-4.7-Flash-GGUF.Q8_0.env` |
| `profiles/.env-GLM-4.7.IQ2_XXS` | `models/bartowski/zai-org_GLM-4.7-GGUF.IQ2_XXS.env` |
| `profiles/.env-GLM-4.7.Q4_K_M` | `models/bartowski/zai-org_GLM-4.7-GGUF.Q4_K_M.env` |
| `profiles/.env-GLM-5.1.UD-IQ1_M` | `models/unsloth/GLM-5.1-GGUF.UD-IQ1_M.env` |
| `profiles/.env-GLM-5.1.UD-IQ2_XXS` | `models/unsloth/GLM-5.1-GGUF.UD-IQ2_XXS.env` |
| `profiles/.env-GLM-5.1.UD-Q2_K_XL` | `models/unsloth/GLM-5.1-GGUF.UD-Q2_K_XL.env` |
| `profiles/.env-Kimi-K2.5.Q4_X` | `models/AesSedai/Kimi-K2.5-GGUF.Q4_X.env` |
| `profiles/.env-MiniMax-M2.1.IQ2_XXS` | `models/bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.IQ2_XXS.env` |
| `profiles/.env-MiniMax-M2.1.Q4_K_M` | `models/bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.Q4_K_M.env` |
| `profiles/.env-MiniMax-M2.1.Q6_K` | `models/bartowski/MiniMaxAI_MiniMax-M2.1-GGUF.Q6_K.env` |
| `profiles/.env-MiniMax-M2.7.IQ2_XXS` | `models/bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.IQ2_XXS.env` |
| `profiles/.env-MiniMax-M2.7.Q4_K_M` | `models/bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.Q4_K_M.env` |
| `profiles/.env-MiniMax-M2.7.Q6_K` | `models/bartowski/MiniMaxAI_MiniMax-M2.7-GGUF.Q6_K.env` |
| `profiles/.env-Nemotron-3-Nano-4B.Q4_K_M` | `models/nvidia/NVIDIA-Nemotron-3-Nano-4B-GGUF.Q4_K_M.env` |
| `profiles/.env-Nemotron-3-Super-120B.Q4_K` | `models/ggml-org/Nemotron-3-Super-120B-GGUF.Q4_K.env` |
| `profiles/.env-Nemotron-3-Super-120B.Q4_K_M` | `models/unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF.Q4_K_M.env` |
| `profiles/.env-Nemotron-3-Super-120B.Q8_0` | `models/unsloth/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF.Q8_0.env` |
| `profiles/.env-Nemotron-Cascade-2-30B.Q4_K_M` | `models/bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF.Q4_K_M.env` |
| `profiles/.env-Nemotron-Cascade-2-30B.Q8_0` | `models/bartowski/nvidia_Nemotron-Cascade-2-30B-A3B-GGUF.Q8_0.env` |
| `profiles/.env-Nemotron-Nano-3-30B.BF16` | `models/unsloth/Nemotron-3-Nano-30B-A3B-GGUF.BF16.env` |
| `profiles/.env-Nemotron-Nano-3-30B.F16` | `models/lmstudio-community/NVIDIA-Nemotron-3-Nano-30B-A3B-GGUF.F16.env` |
| `profiles/.env-Nemotron-Nano-3-30B.Q4_K_M` | `models/ggml-org/Nemotron-Nano-3-30B-A3B-GGUF.Q4_K_M.env` |
| `profiles/.env-Nemotron-Nano-3-30B.Q8_0` | `models/ggml-org/Nemotron-Nano-3-30B-A3B-GGUF.Q8_0.env` |
| `profiles/.env-Qwen3.5-0.8B.Q4_K_M` | `models/bartowski/Qwen_Qwen3.5-0.8B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-0.8B.Q8_0` | `models/bartowski/Qwen_Qwen3.5-0.8B-GGUF.Q8_0.env` |
| `profiles/.env-Qwen3.5-122B-A10B.IQ2_XXS` | `models/bartowski/Qwen_Qwen3.5-122B-A10B-GGUF.IQ2_XXS.env` |
| `profiles/.env-Qwen3.5-122B-A10B.Q4_K_M` | `models/bartowski/Qwen_Qwen3.5-122B-A10B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-27B-Qwen.Q4_K_M` | `models/bartowski/Qwen_Qwen3.5-27B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-27B-Qwen.Q8_0` | `models/bartowski/Qwen_Qwen3.5-27B-GGUF.Q8_0.env` |
| `profiles/.env-Qwen3.5-27B.Q2_K` | `models/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q2_K.env` |
| `profiles/.env-Qwen3.5-27B.Q3_K_M` | `models/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q3_K_M.env` |
| `profiles/.env-Qwen3.5-27B.Q4_K_M` | `models/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-27B.Q8_0` | `models/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q8_0.env` |
| `profiles/.env-Qwen3.5-2B.Q4_K_M` | `models/bartowski/Qwen_Qwen3.5-2B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-2B.Q8_0` | `models/bartowski/Qwen_Qwen3.5-2B-GGUF.Q8_0.env` |
| `profiles/.env-Qwen3.5-35B-A3B-Qwen.Q4_K_M` | `models/unsloth/Qwen3.5-35B-A3B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-35B-A3B-Qwen.Q8_0` | `models/unsloth/Qwen3.5-35B-A3B-GGUF.Q8_0.env` |
| `profiles/.env-Qwen3.5-35B-A3B.Q4_K_M` | `models/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-35B-A3B.Q8_0` | `models/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive.Q8_0.env` |
| `profiles/.env-Qwen3.5-397B-A17B.IQ2_XXS` | `models/bartowski/Qwen_Qwen3.5-397B-A17B-GGUF.IQ2_XXS.env` |
| `profiles/.env-Qwen3.5-397B-A17B.Q4_K_M` | `models/bartowski/Qwen_Qwen3.5-397B-A17B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-4B.Q4_K_M` | `models/bartowski/Qwen_Qwen3.5-4B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-4B.Q8_0` | `models/bartowski/Qwen_Qwen3.5-4B-GGUF.Q8_0.env` |
| `profiles/.env-Qwen3.5-9B-Qwen.Q4_K_M` | `models/bartowski/Qwen_Qwen3.5-9B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-9B-Qwen.Q8_0` | `models/bartowski/Qwen_Qwen3.5-9B-GGUF.Q8_0.env` |
| `profiles/.env-Qwen3.5-9B.Q4_K_M` | `models/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive.Q4_K_M.env` |
| `profiles/.env-Qwen3.5-9B.Q8_0` | `models/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive.Q8_0.env` |
| `profiles/.env-Qwen3.6-27B.Q4_K_M` | `models/bartowski/Qwen_Qwen3.6-27B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.6-27B.Q8_0` | `models/bartowski/Qwen_Qwen3.6-27B-GGUF.Q8_0.env` |
| `profiles/.env-Qwen3.6-35B-A3B.Q4_K_M` | `models/bartowski/Qwen_Qwen3.6-35B-A3B-GGUF.Q4_K_M.env` |
| `profiles/.env-Qwen3.6-35B-A3B.Q8_0` | `models/bartowski/Qwen_Qwen3.6-35B-A3B-GGUF.Q8_0.env` |
| `profiles/.env-gemma-4-26B-A4B-it.F16` | `models/ggml-org/gemma-4-26B-A4B-it-GGUF.F16.env` |
| `profiles/.env-gemma-4-26B-A4B-it.Q4_K_M` | `models/ggml-org/gemma-4-26B-A4B-it-GGUF.Q4_K_M.env` |
| `profiles/.env-gemma-4-26B-A4B-it.Q8_0` | `models/ggml-org/gemma-4-26B-A4B-it-GGUF.Q8_0.env` |
| `profiles/.env-gemma-4-31B-it.F16` | `models/ggml-org/gemma-4-31B-it-GGUF.F16.env` |
| `profiles/.env-gemma-4-31B-it.Q4_K_M` | `models/ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env` |
| `profiles/.env-gemma-4-31B-it.Q8_0` | `models/ggml-org/gemma-4-31B-it-GGUF.Q8_0.env` |
| `profiles/.env-gemma-4-E2B-it.F16` | `models/ggml-org/gemma-4-E2B-it-GGUF.F16.env` |
| `profiles/.env-gemma-4-E2B-it.Q8_0` | `models/ggml-org/gemma-4-E2B-it-GGUF.Q8_0.env` |
| `profiles/.env-gemma-4-E4B-it.F16` | `models/ggml-org/gemma-4-E4B-it-GGUF.F16.env` |
| `profiles/.env-gemma-4-E4B-it.Q4_K_M` | `models/ggml-org/gemma-4-E4B-it-GGUF.Q4_K_M.env` |
| `profiles/.env-gemma-4-E4B-it.Q8_0` | `models/ggml-org/gemma-4-E4B-it-GGUF.Q8_0.env` |
| `profiles/.env-gpt-oss-120b.MXFP4` | `models/ggml-org/gpt-oss-120b-GGUF.MXFP4.env` |
| `profiles/.env-gpt-oss-20b.MXFP4` | `models/ggml-org/gpt-oss-20b-GGUF.MXFP4.env` |

## Makefile Changes

### ENV Resolution (3-step lookup)

```make
ifdef ENV
  ifeq ($(wildcard $(ENV)),)
    ifneq ($(wildcard models/$(ENV)),)
      override ENV := models/$(ENV)
    else
      # Fuzzy: search models/**/*.env for a basename match
      _MATCHES := $(shell find models -name '*.env' 2>/dev/null | grep -F '$(ENV)')
      _MATCH_COUNT := $(words $(_MATCHES))
      ifeq ($(_MATCH_COUNT),1)
        override ENV := $(_MATCHES)
      else ifneq ($(_MATCH_COUNT),0)
        $(error Ambiguous ENV='$(ENV)' — matches: $(_MATCHES))
      endif
    endif
  endif
  -include $(ENV)
endif
```

### `make list` — grouped by org

Recursive glob `models/**/*.env`, grouped by org subdirectory, showing relative path and ALIAS.

### `make select` — recursive glob

Replace `ls profiles/.env-*` with `find models -name '*.env' -not -name README.md | sort`.

### Error messages

Update all example `ENV=` values from `.env-Qwen3.5-27B.Q4_K_M` to `bartowski/Qwen_Qwen3.5-27B-GGUF.Q4_K_M.env`.

## Documentation Updates

16 files need `profiles/` → `models/` and `.env-*` → new path format updates:

| File | Changes |
|------|---------|
| `README.md` | All `make serve ENV=` examples, Docker `--env-file` examples, quick start |
| `CLAUDE.md` | Command examples, architecture section, key behaviors, doc table (`profiles/README.md` → `models/README.md`) |
| `AGENTS.md` | Profile checklist, bundled profiles table, all ENV examples |
| `GEMINI.md` | Docker examples |
| `OPENCODE.md` | `make serve` example |
| `VSCODE.md` | `make serve` example |
| `CURSOR.md` | `make serve` example |
| `HERMES-AGENT.md` | `make serve` example |
| `PI-CODING-AGENT.md` | `make serve` example |
| `CADDY.md` | `make serve` example |
| `TAILSCALE.md` | `make serve` example |
| `CONTRIBUTING.md` | File naming conventions, how to add a profile, checklist |
| `CHANGELOG.md` | Add entry for the restructure |
| `models/README.md` | Moved from `profiles/README.md`, update all internal references |
| `compose.traefik.yml` | If it references profile paths in comments or examples |

## File Content

The `.env` file contents do not change. `HF_REPO`, `MODEL_DIR`, `ALIAS`, `MODEL_FILE`, etc. remain identical.

## Out of Scope

- No symlinks for backward compatibility
- No changes to `compose.yaml` (it doesn't reference `profiles/` directly)
- No changes to `.env` root defaults file
