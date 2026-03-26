ENV ?= .env

-include $(ENV)

QUANT        ?= Q4_K_M
MODEL_DIR    ?= $(HOME)/models/qwen3.5-27b-distilled
MODEL_FILE   ?= Qwen3.5-27B.$(QUANT).gguf
HF_REPO      ?= Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF
CTX          ?= 8192
HOST         ?= 0.0.0.0
PORT         ?= 8080
GPU_LAYERS   ?= 99
CHAT_TPL     ?= chatml
TEMP         ?= 0.6
TOP_P        ?= 0.95

MODEL := $(MODEL_DIR)/$(MODEL_FILE)

.PHONY: download serve chat

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
