ifdef ENV
-include $(ENV)
endif

ifneq ($(filter-out help,$(or $(MAKECMDGOALS),help)),)
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

CTX        ?= 0
HOST       ?= 0.0.0.0
PORT       ?= 8080
GPU_LAYERS ?= 99
CHAT_TPL   ?= chatml
TEMP       ?= 0.6
TOP_P      ?= 0.95

MODEL := $(MODEL_DIR)/$(MODEL_FILE)

.PHONY: help download serve chat

help:
	@echo "Usage: make <target> ENV=<file>"
	@echo ""
	@echo "  serve     Start OpenAI-compatible API server (http://localhost:$(PORT)/v1)"
	@echo "  chat      Interactive terminal chat"
	@echo "  download  Download model via hf CLI"
	@echo ""
	@echo "  ENV=<file>  Env file to load (e.g. ENV=.env-Qwen3.5-27B.Q4_K_M)"

download:
	hf download $(HF_REPO) \
	  --include "$(MODEL_FILE)" \
	  --local-dir $(MODEL_DIR)

serve:
	llama-server \
	  -m $(MODEL) \
	  -c $(CTX) \
	  --host $(HOST) \
	  --port $(PORT) \
	  --chat-template $(CHAT_TPL) \
	  -ngl $(GPU_LAYERS)

chat:
	llama-cli \
	  -m $(MODEL) \
	  -c $(CTX) \
	  --temp $(TEMP) \
	  --top-p $(TOP_P) \
	  --chat-template $(CHAT_TPL) \
	  -ngl $(GPU_LAYERS)
