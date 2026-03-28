# Visual Studio Code Integration

This guide explains how to use your local LLM server from within Visual Studio Code.

## GitHub Copilot Chat

GitHub Copilot Chat supports local LLMs through the **"Bring Your Own Model" (BYOM)** feature.

### 1. Using OpenAI-Compatible Providers (koda)

To add your local server to Copilot Chat:

1.  **Start your local server:** Ensure you have a model running (e.g., `make serve ENV=.env-Qwen3.5-27B.Q4_K_M`).
2.  **Configure VS Code Settings:**
    *   Open **Settings** (`Cmd+,` or `Ctrl+,`).
    *   Search for `github.copilot.chat.customOAIModels`.
    *   Click **"Add Item"** and enter your local server details:
        *   **Endpoint:** `http://localhost:8080/v1`
        *   **Model:** `qwen3.5-27b` (or your model's name)
        *   **Name:** `koda (Local)`
3.  **Select the Model in Chat:**
    *   Open the **Copilot Chat** panel (`Cmd+Shift+I`).
    *   Click on the model name at the top (e.g., "GPT-4o").
    *   Select **"koda (Local)"** from the list.

### 2. Using Ollama (Native)

If you use Ollama, Copilot Chat can detect it automatically:

1.  Open the model picker in the Copilot Chat panel.
2.  Select **"Manage Models..."**.
3.  Enable the **Ollama** provider and select your local models.

---

## Recommended Extensions (Alternatives)

If you want a fully "local-first" experience without requiring a GitHub Copilot subscription or login, these extensions are highly recommended:

### [Continue](https://marketplace.visualstudio.com/items?itemName=Continue.continue)

Continue is a popular open-source AI autopilot that supports both chat and **inline tab-completions** using local models.

1.  **Install:** Search for "Continue" in the VS Code Marketplace.
2.  **Configure:** Open the `config.json` file in Continue.
3.  **Add Model:**
    ```json
    {
      "title": "Local Model (koda)",
      "model": "qwen3.5-27b",
      "apiBase": "http://localhost:8080/v1",
      "provider": "openai"
    }
    ```

### [Roo Cline](https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline)

Roo Cline is an autonomous coding agent that works excellently with local backends.

1.  **Install:** Search for "Roo Cline" in the Marketplace.
2.  **Configure:** Click "Settings" in the Roo Cline sidebar.
3.  **API Provider:** Select **OpenAI Compatible**.
4.  **Base URL:** `http://localhost:8080/v1`.

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
