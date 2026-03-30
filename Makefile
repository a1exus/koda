-include .env

ifdef ENV
-include $(ENV)
endif

ifneq ($(filter-out help check,$(or $(MAKECMDGOALS),help)),)
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

MODEL := $(MODEL_DIR)/$(MODEL_FILE)
DOWNLOAD_INCLUDE ?= $(MODEL_FILE)

.PHONY: help check download serve chat

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
	@echo "Usage: make <target> ENV=<file>"
	@echo ""
	@echo "  serve     Start OpenAI-compatible API server + built-in WebUI (http://localhost:$(PORT))"
	@echo "  chat      Interactive terminal chat"
	@echo "  download  Download model via hf CLI"
	@echo "  check     Verify required binaries are installed and on PATH"
	@echo ""
	@echo "  ENV=<file>  Env file to load (e.g. ENV=.env-Qwen3.5-27B.Q4_K_M)"

check:
	$(call require_cmd,llama-server,llama.cpp)
	$(call require_cmd,llama-cli,llama.cpp)
	$(call require_cmd,hf,huggingface-cli)
	@echo "OK: required binaries are available"

download:
	$(call require_cmd,hf,huggingface-cli)
	hf download $(HF_REPO) \
	  --include "$(DOWNLOAD_INCLUDE)" \
	  --local-dir $(MODEL_DIR)

serve:
	$(call require_cmd,llama-server,llama.cpp)
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
	  -ngl $(GPU_LAYERS) \
	  $(SERVER_ARGS)

chat:
	$(call require_cmd,llama-cli,llama.cpp)
	llama-cli \
	  -m $(MODEL) \
	  -c $(CTX) \
	  --temp $(TEMP) \
	  --top-p $(TOP_P) \
	  $(PROMPT_ARGS) \
	  $(RPC_ARGS) \
	  -ngl $(GPU_LAYERS) \
	  $(CHAT_ARGS)
