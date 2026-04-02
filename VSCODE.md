# Visual Studio Code Integration

This guide explains how to use your local LLM server from within Visual Studio Code.

## GitHub Copilot Chat

GitHub Copilot Chat supports local LLMs through the **["Bring Your Own Model" (BYOM)](https://docs.github.com/en/copilot/how-tos/use-ai-models/change-the-chat-model)** feature.

### 1. Using OpenAI-Compatible Providers (koda)

To add your local server to Copilot Chat:

1. **Start your local server:** Ensure you have a model running (e.g., `make serve ENV=profiles/.env-Qwen3.5-27B.Q4_K_M`).
   This exposes both the built-in WebUI at `http://localhost:8080` and the OpenAI-compatible API at `http://localhost:8080/v1`.
2. **Configure VS Code Settings:**
   - Open **Settings** (`Cmd+,` or `Ctrl+,`).
   - Search for `github.copilot.chat.customOAIModels`.
   - Click **"Add Item"** and enter your local server details:
     - **Endpoint:** `http://localhost:8080/v1`
     - **Model:** the `ALIAS` of the running profile (e.g. `gemma-4-31b-it`, `nemotron-nano-3-30b`, `qwen3.5-27b`)
     - **Name:** `koda (Local)`
   - See [profiles/README.md](./profiles/README.md) for the full list of available aliases.
3. **Select the Model in Chat:**
   - Open the **Copilot Chat** panel (`Cmd+Shift+I`).
   - Click on the model name at the top (e.g., "GPT-4o").
   - Select **"koda (Local)"** from the list.

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

Koda defaults to the GGUF model's embedded Jinja template, so most models work without extra prompt-template setup in VS Code clients.
