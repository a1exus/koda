# Visual Studio Code Integration

This guide explains how to use your local LLM server from within Visual Studio Code.

## GitHub Copilot Chat

GitHub Copilot Chat supports local LLMs through the **["Bring Your Own Model" (BYOM)](https://docs.github.com/en/copilot/how-tos/use-ai-models/change-the-chat-model)** feature.

### 1. Using OpenAI-Compatible Providers (koda)

To add your local server to Copilot Chat:

1. **Start your local server:** Ensure you have a model running (e.g., `make serve ENV=profiles/.env-gemma-4-31B-it.Q4_K_M`).
   This exposes both the built-in WebUI at `http://localhost:8080` and the OpenAI-compatible API at `http://localhost:8080/v1`.
2. **Configure `chatLanguageModels.json`:**
   Open `~/.config/Code/User/chatLanguageModels.json` (or `Code - Insiders`) and add a `koda (Local)` provider with one entry per model alias. To generate an entry for a single profile, run `make export-vscode ENV=<profile>`.
   ```json
   [
     {
       "name": "koda (Local)",
       "vendor": "customoai",
       "models": [
         { "id": "gemma-4-e2b-it", "name": "Gemma 4 E2B Instruct", "url": "http://localhost:8080/v1", "model": "gemma-4-e2b-it", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "gemma-4-e4b-it", "name": "Gemma 4 E4B Instruct", "url": "http://localhost:8080/v1", "model": "gemma-4-e4b-it", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "gemma-4-26b-a4b-it", "name": "Gemma 4 26B-A4B Instruct", "url": "http://localhost:8080/v1", "model": "gemma-4-26b-a4b-it", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "gemma-4-31b-it", "name": "Gemma 4 31B Instruct", "url": "http://localhost:8080/v1", "model": "gemma-4-31b-it", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "qwen3.5-9b", "name": "Qwen 3.5 9B", "url": "http://localhost:8080/v1", "model": "qwen3.5-9b", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "qwen3.5-27b", "name": "Qwen 3.5 27B Reasoning Distilled", "url": "http://localhost:8080/v1", "model": "qwen3.5-27b", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "qwen3.5-35b-a3b", "name": "Qwen 3.5 35B-A3B", "url": "http://localhost:8080/v1", "model": "qwen3.5-35b-a3b", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "gpt-oss-20b", "name": "GPT-OSS 20B", "url": "http://localhost:8080/v1", "model": "gpt-oss-20b", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "gpt-oss-120b", "name": "GPT-OSS 120B", "url": "http://localhost:8080/v1", "model": "gpt-oss-120b", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "deepseek-r1-distill-qwen-1.5b", "name": "DeepSeek R1 Distill Qwen 1.5B", "url": "http://localhost:8080/v1", "model": "deepseek-r1-distill-qwen-1.5b", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "deepseek-r1-distill-qwen-7b", "name": "DeepSeek R1 Distill Qwen 7B", "url": "http://localhost:8080/v1", "model": "deepseek-r1-distill-qwen-7b", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "deepseek-r1-distill-llama-8b", "name": "DeepSeek R1 Distill Llama 8B", "url": "http://localhost:8080/v1", "model": "deepseek-r1-distill-llama-8b", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "deepseek-r1-0528-qwen3-8b", "name": "DeepSeek R1 0528 Qwen3 8B", "url": "http://localhost:8080/v1", "model": "deepseek-r1-0528-qwen3-8b", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "deepseek-r1-distill-qwen-14b", "name": "DeepSeek R1 Distill Qwen 14B", "url": "http://localhost:8080/v1", "model": "deepseek-r1-distill-qwen-14b", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "deepseek-r1-distill-qwen-32b", "name": "DeepSeek R1 Distill Qwen 32B", "url": "http://localhost:8080/v1", "model": "deepseek-r1-distill-qwen-32b", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "deepseek-r1-distill-llama-70b", "name": "DeepSeek R1 Distill Llama 70B", "url": "http://localhost:8080/v1", "model": "deepseek-r1-distill-llama-70b", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "deepseek-r1", "name": "DeepSeek R1 671B", "url": "http://localhost:8080/v1", "model": "deepseek-r1", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "deepseek-r1-0528", "name": "DeepSeek R1 0528 671B", "url": "http://localhost:8080/v1", "model": "deepseek-r1-0528", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "nemotron-3-nano-4b", "name": "Nemotron 3 Nano 4B", "url": "http://localhost:8080/v1", "model": "nemotron-3-nano-4b", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "nemotron-cascade-2-30b", "name": "Nemotron Cascade 2 30B", "url": "http://localhost:8080/v1", "model": "nemotron-cascade-2-30b", "toolCalling": false, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "nemotron-nano-3-30b", "name": "Nemotron Nano 3 30B", "url": "http://localhost:8080/v1", "model": "nemotron-nano-3-30b", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "nemotron-3-super-120b", "name": "Nemotron 3 Super 120B", "url": "http://localhost:8080/v1", "model": "nemotron-3-super-120b", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 },
         { "id": "kimi-k2.5", "name": "Kimi K2.5", "url": "http://localhost:8080/v1", "model": "kimi-k2.5", "toolCalling": true, "maxInputTokens": 131072, "maxOutputTokens": 8192 }
       ]
     }
   ]
   ```
   See [profiles/README.md](./profiles/README.md) for the full list of available aliases.
3. **Select the Model in Chat:**
   - Open the **Copilot Chat** panel (`Cmd+Shift+I`).
   - Click on the model name at the top and select any **koda (Local)** model.

### 2. Using Ollama (Native)

If you use Ollama, Copilot Chat can detect it automatically:

1. Open the model picker in the Copilot Chat panel.
2. Select **"Manage Models..."**.
3. Enable the **Ollama** provider and select your local models.

---

## Alternative Extensions

- [Continue](https://marketplace.visualstudio.com/items?itemName=Continue.continue) — open-source AI autopilot with chat and inline tab-completions
- [Roo Cline](https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline) — autonomous coding agent

Both support OpenAI-compatible backends. Point either one at `http://localhost:8080/v1` with any non-empty API key.

---

## Manual Interaction

You can also use the terminal inside VS Code to interact with the API:

```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

Any OpenAI-compatible client can use `http://localhost:8080/v1` with any non-empty API key. See [README.md](./README.md#-quick-start) for server defaults and override options.
