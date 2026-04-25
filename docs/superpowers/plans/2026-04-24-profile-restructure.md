# Profile Directory Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move 84 profile files from flat `profiles/.env-*` to org-based `models/<hf_org>/<hf_repo>.<quant>.env` hierarchy, rename `profiles/` → `models/`, update Makefile and all documentation.

**Architecture:** Shell script generates the file mapping from `HF_REPO` inside each profile, `git mv` moves files preserving history, Makefile gets 3-step ENV resolution (exact → prepend `models/` → fuzzy search), all 16 docs get `profiles/` → `models/` updates.

**Tech Stack:** Make, bash, git

---

### Task 1: Move profile files to org-based hierarchy

**Files:**
- Move: all 84 `profiles/.env-*` files → `models/<org>/<repo>.<quant>.env`
- Move: `profiles/README.md` → `models/README.md`

- [ ] **Step 1: Create org directories and move files via git**

Run this script from the repo root. It reads `HF_REPO` from each profile, extracts the org and repo name, computes the quant from the old filename (everything after the last dot preceding a non-digit character), then `git mv`s each file.

```bash
# Create the models/ directory structure
mkdir -p models

# Move README first
git mv profiles/README.md models/README.md

# Move each profile
git ls-files 'profiles/.env-*' | while read f; do
  hf_repo=$(grep '^HF_REPO=' "$f" | cut -d'=' -f2)
  org=$(echo "$hf_repo" | cut -d'/' -f1)
  repo=$(echo "$hf_repo" | cut -d'/' -f2)
  old_basename=$(basename "$f" | sed 's/^\.env-//')
  quant=$(echo "$old_basename" | sed -E 's/.*\.([^0-9])/\1/')
  dest="models/${org}/${repo}.${quant}.env"
  mkdir -p "models/${org}"
  git mv "$f" "$dest"
done

# Remove the now-empty profiles/ directory
rmdir profiles 2>/dev/null || true
```

- [ ] **Step 2: Verify the move**

```bash
# Should be 84 .env files
find models -name '*.env' | wc -l

# Should be 8 org directories
ls -d models/*/  | wc -l

# Should be 0 files left in profiles/
ls profiles/.env-* 2>/dev/null | wc -l

# No duplicate destinations
find models -name '*.env' | sort | uniq -d
```

Expected: 84 files, 8 dirs, 0 leftover, 0 duplicates.

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "Restructure profiles/ into models/<org>/<repo>.<quant>.env

Move 84 profile files from flat profiles/.env-* layout to org-based
hierarchy mirroring HuggingFace repo URLs. Rename profiles/ to models/.
8 org directories: AesSedai, bartowski, ggml-org, HauhauCS, Jackrong,
lmstudio-community, nvidia, unsloth."
```

---

### Task 2: Update Makefile

**Files:**
- Modify: `Makefile`

- [ ] **Step 1: Update ENV resolution block (lines 1-11)**

Replace the current ENV resolution with 3-step lookup:

```make
-include .env

# Handle model profiles in models/ directory
ifdef ENV
  ifeq ($(wildcard $(ENV)),)
    ifneq ($(wildcard models/$(ENV)),)
      override ENV := models/$(ENV)
    else
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

- [ ] **Step 2: Update error messages (lines 14-16)**

Change all three error examples from:
```
$(error HF_REPO is not set. Example: make $(MAKECMDGOALS) ENV=.env-Qwen3.5-27B.Q4_K_M)
```
to:
```
$(error HF_REPO is not set. Example: make $(MAKECMDGOALS) ENV=bartowski/Qwen_Qwen3.5-27B-GGUF.Q4_K_M.env)
```

Same for `MODEL_DIR` and `MODEL_FILE` error lines.

- [ ] **Step 3: Update `help` target (lines 102-123)**

Change:
```
@echo "  list             List all available model profiles in profiles/"
```
to:
```
@echo "  list             List all available models in models/"
```

Change:
```
@echo "  ENV=<profile>  Profile to load, e.g. ENV=.env-gemma-4-31B-it.Q4_K_M"
@echo "                 Koda automatically prepends profiles/ if omitted."
```
to:
```
@echo "  ENV=<profile>  Model to load, e.g. ENV=bartowski/Qwen_Qwen3.5-27B-GGUF.Q4_K_M.env"
@echo "                 Koda automatically prepends models/ if omitted."
```

- [ ] **Step 4: Update `list` target (lines 138-146)**

Replace:
```make
list:
	@echo "Available model profiles in profiles/:"
	@echo ""
	@printf "%-40s %-20s\n" "PROFILE" "ALIAS"
	@printf "%-40s %-20s\n" "-------" "-----"
	@for f in profiles/.env-*; do \
	  alias=$$(grep "^ALIAS=" $$f | cut -d'=' -f2); \
	  printf "%-40s %-20s\n" $${f#profiles/} "$$alias"; \
	done
```
with:
```make
list:
	@echo "Available models:"
	@echo ""
	@prev_org=""; \
	for f in $$(find models -name '*.env' | sort); do \
	  rel=$${f#models/}; \
	  org=$${rel%%/*}; \
	  if [ "$$org" != "$$prev_org" ]; then \
	    [ -n "$$prev_org" ] && echo ""; \
	    echo "$$org/"; \
	    prev_org="$$org"; \
	  fi; \
	  alias=$$(grep "^ALIAS=" $$f | cut -d'=' -f2); \
	  name=$${rel#*/}; \
	  printf "  %-60s %s\n" "$$name" "$$alias"; \
	done
```

- [ ] **Step 5: Update `select` target (lines 148-164)**

Replace:
```make
select:
	@if command -v fzf >/dev/null 2>&1; then \
	  profile=$$(ls profiles/.env-* | xargs -n1 basename | fzf --header "Select a model profile" --preview "cat profiles/{}"); \
	  if [ -n "$$profile" ]; then \
	    $(MAKE) check-model ENV=$$profile || exit 1; \
	    $(MAKE) serve ENV=$$profile; \
	  fi; \
	elif command -v gum >/dev/null 2>&1; then \
	  profile=$$(ls profiles/.env-* | xargs -n1 basename | gum choose --header "Select a model profile"); \
	  if [ -n "$$profile" ]; then \
	    $(MAKE) check-model ENV=$$profile || exit 1; \
	    $(MAKE) serve ENV=$$profile; \
	  fi; \
	else \
	  echo "Error: fzf or gum is required for 'make select'."; \
	  exit 1; \
	fi
```
with:
```make
select:
	@if command -v fzf >/dev/null 2>&1; then \
	  profile=$$(find models -name '*.env' | sort | sed 's|^models/||' | fzf --header "Select a model" --preview "cat models/{}"); \
	  if [ -n "$$profile" ]; then \
	    $(MAKE) check-model ENV="$$profile" || exit 1; \
	    $(MAKE) serve ENV="$$profile"; \
	  fi; \
	elif command -v gum >/dev/null 2>&1; then \
	  profile=$$(find models -name '*.env' | sort | sed 's|^models/||' | gum choose --header "Select a model"); \
	  if [ -n "$$profile" ]; then \
	    $(MAKE) check-model ENV="$$profile" || exit 1; \
	    $(MAKE) serve ENV="$$profile"; \
	  fi; \
	else \
	  echo "Error: fzf or gum is required for 'make select'."; \
	  exit 1; \
	fi
```

- [ ] **Step 6: Verify Makefile syntax**

```bash
make help
make list
```

Expected: `make help` prints updated help text with new example path. `make list` shows models grouped by org.

- [ ] **Step 7: Commit**

```bash
git add Makefile
git commit -m "Update Makefile for models/ directory structure

3-step ENV resolution (exact path, models/ prefix, fuzzy search).
make list now groups by HF org. make select uses recursive find."
```

---

### Task 3: Update README.md

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Apply all replacements**

All occurrences — use these exact search-and-replace pairs:

| Find | Replace |
|------|---------|
| `profiles/.env-<model>.<quant>` | `models/<org>/<repo>.<quant>.env` |
| `profiles/.env-Qwen3.5-27B.Q4_K_M` | `models/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q4_K_M.env` |
| `profiles/.env-gemma-4-31B-it.Q4_K_M` | `models/ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env` |
| `ENV=.env-gemma-4-31B-it.Q4_K_M` | `ENV=ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env` |
| `profiles/README.md` | `models/README.md` |
| `profiles/` (in prose like "in `profiles/`") | `models/` |
| `Koda prepends \`profiles/\`` | `Koda prepends \`models/\`` |

Specific lines to update:

- Line 12: `.env` defaults → `profiles/.env-<model>.<quant>` → change to `models/<org>/<repo>.<quant>.env`
- Line 55: `docker compose --env-file profiles/.env-Qwen3.5-27B.Q4_K_M` → `docker compose --env-file models/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q4_K_M.env`
- Line 72: `profiles/README.md` → `models/README.md`
- Lines 75-76: `make download ENV=profiles/.env-Qwen3.5-27B.Q4_K_M` → `make download ENV=models/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q4_K_M.env` (same for serve)
- Line 91: update the `ENV=` example and `prepends profiles/` text
- Line 98: `profiles/` → `models/`
- Lines 110, 113, 116: update all `ENV=profiles/.env-Qwen3.5-27B.Q4_K_M` examples
- Line 128: Docker example
- Line 162: `profiles/README.md` → `models/README.md`
- Line 179: doc table `profiles/README.md` → `models/README.md`

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "Update README.md for models/ directory structure"
```

---

### Task 4: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Apply all replacements**

| Find | Replace |
|------|---------|
| `ENV=.env-<model>.<quant>` | `ENV=<org>/<repo>.<quant>.env` |
| `profiles/.env-<model>.<quant>` | `models/<org>/<repo>.<quant>.env` |
| `profiles/` (in prose) | `models/` |
| `profiles/README.md` | `models/README.md` |

Key lines:
- Command examples section: all `ENV=` paths
- Architecture section: `profiles/.env-<model>.<quant>` → `models/<org>/<repo>.<quant>.env`
- Key Behaviors: `profiles/README.md` → `models/README.md`
- Documentation Files table: `profiles/README.md` → `models/README.md`

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "Update CLAUDE.md for models/ directory structure"
```

---

### Task 5: Update AGENTS.md

**Files:**
- Modify: `AGENTS.md`

- [ ] **Step 1: Apply all replacements**

| Find | Replace |
|------|---------|
| `profiles/.env-` | `models/<org>/` |
| `profiles/README.md` | `models/README.md` |
| `profiles/` (in prose) | `models/` |

Key sections:
- Profile checklist items (steps 1-8): update file paths and naming conventions
- All `ENV=` examples
- Bundled profiles table references

- [ ] **Step 2: Commit**

```bash
git add AGENTS.md
git commit -m "Update AGENTS.md for models/ directory structure"
```

---

### Task 6: Update integration guides (OPENCODE, VSCODE, CURSOR, HERMES-AGENT, PI-CODING-AGENT)

**Files:**
- Modify: `OPENCODE.md`, `VSCODE.md`, `CURSOR.md`, `HERMES-AGENT.md`, `PI-CODING-AGENT.md`

- [ ] **Step 1: Update OPENCODE.md**

Change:
```
make serve ENV=profiles/.env-Qwen3.5-27B.Q4_K_M
```
to:
```
make serve ENV=models/bartowski/Qwen_Qwen3.5-27B-GGUF.Q4_K_M.env
```

Update `profiles/README.md` link if present.

- [ ] **Step 2: Update VSCODE.md**

Change:
```
make serve ENV=profiles/.env-gemma-4-31B-it.Q4_K_M
```
to:
```
make serve ENV=models/ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env
```

Change line 62 `profiles/README.md` → `models/README.md`.

- [ ] **Step 3: Update CURSOR.md**

Change:
```
make serve ENV=profiles/.env-gemma-4-31B-it.Q4_K_M
```
to:
```
make serve ENV=models/ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env
```

Change `profiles/README.md` → `models/README.md`.

- [ ] **Step 4: Update HERMES-AGENT.md**

Change all `make serve ENV=profiles/.env-Qwen3.5-27B.Q4_K_M` to `make serve ENV=models/bartowski/Qwen_Qwen3.5-27B-GGUF.Q4_K_M.env`.

- [ ] **Step 5: Update PI-CODING-AGENT.md**

Same pattern: update `make serve ENV=` and `make list` references.

- [ ] **Step 6: Commit**

```bash
git add OPENCODE.md VSCODE.md CURSOR.md HERMES-AGENT.md PI-CODING-AGENT.md
git commit -m "Update integration guides for models/ directory structure"
```

---

### Task 7: Update GEMINI.md, CADDY.md, TAILSCALE.md

**Files:**
- Modify: `GEMINI.md`, `CADDY.md`, `TAILSCALE.md`

- [ ] **Step 1: Update GEMINI.md**

All `profiles/.env-` → `models/<org>/...`. Key instances:
- Line 11: `ENV=profiles/.env-<name>` → `ENV=models/<org>/<repo>.<quant>.env`
- Line 13: `profiles/` directory reference
- Lines 28-37: Docker `--env-file profiles/.env-Qwen3.5-27B.Q4_K_M` → `--env-file models/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF.Q4_K_M.env`
- Line 64: `--env-file profiles/.env-<model>.<quant>` → `--env-file models/<org>/<repo>.<quant>.env`
- Line 77-84: `profiles/` references
- Line 117: adding models instructions
- Line 128: `profiles/README.md` link

- [ ] **Step 2: Update CADDY.md**

Change:
```
make serve ENV=profiles/.env-gemma-4-31B-it.Q4_K_M
```
to:
```
make serve ENV=models/ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env
```

- [ ] **Step 3: Update TAILSCALE.md**

Change all `profiles/.env-gpt-oss-*` paths:
- `profiles/.env-gpt-oss-20b.MXFP4` → `models/ggml-org/gpt-oss-20b-GGUF.MXFP4.env`
- `profiles/.env-gpt-oss-120b.MXFP4` → `models/ggml-org/gpt-oss-120b-GGUF.MXFP4.env`

- [ ] **Step 4: Commit**

```bash
git add GEMINI.md CADDY.md TAILSCALE.md
git commit -m "Update GEMINI, CADDY, TAILSCALE docs for models/ directory structure"
```

---

### Task 8: Update CONTRIBUTING.md and compose.traefik.yml

**Files:**
- Modify: `CONTRIBUTING.md`, `compose.traefik.yml`

- [ ] **Step 1: Update CONTRIBUTING.md**

Replace entire "Adding a Model Profile" section step 1:

```markdown
1. Create `models/<hf-org>/<hf-repo-name>.<Quant>.env` with these required fields:

   ```bash
   # https://huggingface.co/<original-model>
   HF_REPO=<hf-org>/<hf-repo-name>
   MODEL_DIR=~/models/<model-family>
   MODEL_FILE=<filename>.gguf
   DOWNLOAD_INCLUDE=<filename>.gguf          # space-separated if multiple files
   ALIAS=<clean-id>                          # e.g. gemma-4-31b-it
   ```
```

Update step 2 verify command:
```
make check-model ENV=models/<hf-org>/<hf-repo-name>.<Quant>.env
```

Update the file checklist table: `profiles/README.md` → `models/README.md`, `profiles/` → `models/`.

- [ ] **Step 2: Update compose.traefik.yml comment**

Change line 6:
```yaml
#     --env-file profiles/.env-<model>.<quant> up -d
```
to:
```yaml
#     --env-file models/<org>/<repo>.<quant>.env up -d
```

- [ ] **Step 3: Commit**

```bash
git add CONTRIBUTING.md compose.traefik.yml
git commit -m "Update CONTRIBUTING.md and compose.traefik.yml for models/ directory"
```

---

### Task 9: Update models/README.md internal references

**Files:**
- Modify: `models/README.md` (already moved from `profiles/README.md`)

- [ ] **Step 1: Update self-references**

Search for any `profiles/` references within the file and replace with `models/`. This file is the catalog — update any references to the old `.env-*` naming convention to use the new `<org>/<repo>.<quant>.env` format.

- [ ] **Step 2: Commit**

```bash
git add models/README.md
git commit -m "Update models/README.md internal references"
```

---

### Task 10: Update CHANGELOG.md

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Add entry under [Unreleased]**

Add at the top of the `[Unreleased]` section under `### Changed`:

```markdown
### Changed
- Restructured `profiles/` → `models/` with org-based hierarchy: `models/<hf_org>/<hf_repo>.<quant>.env` (mirrors HuggingFace repo URLs)
- Makefile: 3-step ENV resolution (exact path → `models/` prefix → fuzzy search), `make list` grouped by org, `make select` recursive
- Updated all documentation for new `models/` paths
```

- [ ] **Step 2: Commit**

```bash
git add CHANGELOG.md
git commit -m "Add profile restructure entry to CHANGELOG"
```

---

### Task 11: Validate scripts and final check

**Files:**
- Check: `scripts/validate-profiles.sh` (if it references `profiles/`)

- [ ] **Step 1: Check validate-profiles.sh**

```bash
grep -n 'profiles' scripts/validate-profiles.sh
```

If it references `profiles/`, update to `models/`. If it globs `profiles/.env-*`, change to `find models -name '*.env'`.

- [ ] **Step 2: Run validation**

```bash
sh scripts/validate-profiles.sh
make list
make help
```

Expected: validate script passes, `make list` shows 84 models grouped by 8 orgs, `make help` shows updated example paths.

- [ ] **Step 3: Verify no stale references remain**

```bash
grep -rn 'profiles/' --include='*.md' --include='Makefile' --include='*.yml' --include='*.sh' . | grep -v 'node_modules' | grep -v '.git/'
```

Expected: zero hits (or only in CHANGELOG.md historical entries which are fine).

- [ ] **Step 4: Commit any remaining fixes**

```bash
git add -A
git commit -m "Fix remaining profiles/ references"
```
