-include .env

# Handle model profiles in profiles/ directory
ifdef ENV
  ifeq ($(wildcard $(ENV)),)
    ifneq ($(wildcard profiles/$(ENV)),)
      override ENV := profiles/$(ENV)
    endif
  endif
  -include $(ENV)
endif

ifneq ($(filter-out help check cache list select export-opencode export-vscode,$(or $(MAKECMDGOALS),help)),)
ifndef HF_REPO
$(error HF_REPO is not set. Example: make $(MAKECMDGOALS) ENV=.env-Qwen3.5-27B.Q4_K_M)
endif
ifndef MODEL_DIR
$(error MODEL_DIR is not set. Example: make $(MAKECMDGOALS) ENV=.env-Qwen3.5-27B.Q4_K_M)
endif
ifndef MODEL_FILE
$(error MODEL_FILE is not set. Example: make $(MAKECMDGOALS) ENV=.env-Qwen3.5-27B.Q4_K_M)
endif
endif

# Tilde expansion for paths
EXP_MODEL_DIR := $(shell echo "$(MODEL_DIR)" | sed "s|^~|$$HOME|")
# Check if model exists locally, otherwise search the HF cache (never triggers a download)
MODEL := $(shell \
	if [ -f "$(EXP_MODEL_DIR)/$(MODEL_FILE)" ]; then \
		echo "$(EXP_MODEL_DIR)/$(MODEL_FILE)"; \
	else \
		find -L "$(HOME)/.cache/huggingface/hub" -name "$(MODEL_FILE)" -type f 2>/dev/null | head -1; \
	fi)
DOWNLOAD_INCLUDE ?= $(MODEL_FILE)

.PHONY: help check check-model cache download serve chat list select export-opencode export-vscode

ifeq ($(PROMPT_FORMAT),jinja)
PROMPT_ARGS := --jinja
else
PROMPT_ARGS := --chat-template $(CHAT_TPL)
endif

ifneq ($(strip $(RPC)),)
RPC_ARGS := --rpc $(RPC)
endif

ifneq ($(strip $(METRICS)),0)
ifeq ($(METRICS),1)
METRICS_ARGS := --metrics
endif
endif

ifneq ($(strip $(ALIAS)),)
ALIAS_ARGS := --alias $(ALIAS)
endif

ifneq ($(strip $(API_KEY)),)
API_KEY_ARGS := --api-key $(API_KEY)
endif

# Advanced Performance & Multimodal detection
# We use the parent directory of the resolved model for MM checks
RESOLVED_MODEL_DIR := $(shell dirname "$(MODEL)")
ifneq ($(wildcard $(RESOLVED_MODEL_DIR)/mmproj*),)
MMPROJ_FILE := $(firstword $(wildcard $(RESOLVED_MODEL_DIR)/mmproj*))
MMPROJ_ARGS := --mmproj $(MMPROJ_FILE)
endif

# Speculative Decoding
ifneq ($(strip $(DRAFT_MODEL)),)
DRAFT_ARGS := -md $(shell echo "$(DRAFT_MODEL)" | sed "s|^~|$$HOME|")
endif

# Context Shifting & Embeddings
ifneq ($(strip $(EMBEDDINGS)),)
EMBED_ARGS := --embeddings
endif

ifneq ($(strip $(CTX_SHIFT)),)
CTX_SHIFT_ARGS := --ctx-shift
endif

SERVER_ARGS := $(strip $(SERVER_EXTRA_ARGS))
CHAT_ARGS := $(strip $(CHAT_EXTRA_ARGS))

define require_cmd
	@command -v $(1) >/dev/null 2>&1 || { \
	  echo "Error: $(1) was not found in PATH."; \
	  echo ""; \
	  echo "Install it first:"; \
	  echo "  brew install $(2)"; \
	  echo ""; \
	  echo "If it is already installed, add Homebrew to PATH:"; \
	  echo "  export PATH=/opt/homebrew/bin:\$$PATH"; \
	  echo ""; \
	  echo "More help: README.md"; \
	  exit 1; \
	}
endef

help:
	@echo "Usage: make <target> [ENV=<profile>]"
	@echo ""
	@echo "Run a model:"
	@echo "  serve            Start OpenAI-compatible API server + built-in WebUI"
	@echo "  chat             Interactive terminal chat"
	@echo ""
	@echo "Manage models:"
	@echo "  download         Download model via hf CLI"
	@echo "  list             List all available model profiles in profiles/"
	@echo "  select           Interactively select and serve a profile (requires fzf or gum)"
	@echo "  cache            Show what models are in the Hugging Face cache"
	@echo ""
	@echo "Utilities:"
	@echo "  check            Verify required binaries are installed and on PATH"
	@echo "  check-model      Verify the model file for ENV is present"
	@echo "  export-opencode  Print OpenCode configuration snippet for current profile"
	@echo "  export-vscode    Print VS Code configuration snippet for current profile"
	@echo ""
	@echo "  ENV=<profile>  Profile to load, e.g. ENV=.env-gemma-4-31B-it.Q4_K_M"
	@echo "                 Koda automatically prepends profiles/ if omitted."

check:
	$(call require_cmd,llama-server,llama.cpp)
	$(call require_cmd,llama-cli,llama.cpp)
	$(call require_cmd,hf,huggingface-cli)
	@command -v fzf >/dev/null 2>&1 && echo "OK: fzf is available (for make select)" || echo "Note: fzf is not installed (optional, for make select)"
	@echo "OK: required binaries are available"

download:
	$(call require_cmd,hf,huggingface-cli)
	hf download $(HF_REPO) \
	  $(foreach f,$(DOWNLOAD_INCLUDE),--include "$(f)") \
	  --local-dir $(EXP_MODEL_DIR)

list:
	@echo "Available model profiles in profiles/:"
	@echo ""
	@printf "%-40s %-20s\n" "PROFILE" "ALIAS"
	@printf "%-40s %-20s\n" "-------" "-----"
	@for f in profiles/.env-*; do \
	  alias=$$(grep "^ALIAS=" $$f | cut -d'=' -f2); \
	  printf "%-40s %-20s\n" $${f#profiles/} "$$alias"; \
	done

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

check-model:
	@if [ -z "$(MODEL)" ] || [ ! -f "$(MODEL)" ]; then \
	  echo ""; \
	  echo "Error: model not found — $(MODEL_FILE)"; \
	  echo ""; \
	  echo "Run:  make download ENV=$(ENV)"; \
	  echo ""; \
	  exit 1; \
	fi

cache:
	$(call require_cmd,hf,huggingface-cli)
	hf cache ls

export-opencode:
	@echo "Copy this into your ~/.config/opencode/opencode.json 'models' record:"
	@echo ""
	@echo "  \"$(ALIAS)\": { \"name\": \"$(ALIAS) (Local)\" }"

export-vscode:
	@echo "Add this to your VS Code 'github.copilot.chat.customOAIModels' settings:"
	@echo ""
	@echo "  { \"endpoint\": \"http://localhost:$(PORT)/v1\", \"model\": \"$(ALIAS)\", \"name\": \"koda ($(ALIAS))\" }"

serve:
	$(call require_cmd,llama-server,llama.cpp)
	@$(MAKE) check-model ENV=$(ENV) --no-print-directory
	llama-server \
	  -m $(MODEL) \
	  -c $(CTX) \
	  -ub $(UBATCH) \
	  -b $(BATCH) \
	  --host $(HOST) \
	  --port $(PORT) \
	  $(PROMPT_ARGS) \
	  $(RPC_ARGS) \
	  $(METRICS_ARGS) \
	  $(ALIAS_ARGS) \
	  $(API_KEY_ARGS) \
	  $(MMPROJ_ARGS) \
	  $(DRAFT_ARGS) \
	  $(EMBED_ARGS) \
	  $(CTX_SHIFT_ARGS) \
	  -ngl $(GPU_LAYERS) \
	  $(SERVER_ARGS)

chat:
	$(call require_cmd,llama-cli,llama.cpp)
	@$(MAKE) check-model ENV=$(ENV) --no-print-directory
	llama-cli \
	  -m $(MODEL) \
	  -c $(CTX) \
	  --temp $(TEMP) \
	  --top-p $(TOP_P) \
	  $(PROMPT_ARGS) \
	  $(RPC_ARGS) \
	  $(MMPROJ_ARGS) \
	  $(DRAFT_ARGS) \
	  -ngl $(GPU_LAYERS) \
	  $(CHAT_ARGS)
