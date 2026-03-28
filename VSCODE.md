# Visual Studio Code Integration

This guide explains how to use your local LLM server from within Visual Studio Code.

## Recommended Extensions

Since the server is OpenAI-compatible, you can use several popular extensions:

### [Continue](https://marketplace.visualstudio.com/items?itemName=Continue.continue)

Continue is a popular open-source AI autopilot for VS Code.

1.  **Install:** Search for "Continue" in the VS Code Extensions Marketplace and install it.
2.  **Configure:** Open the `config.json` file for Continue (click the gear icon in the Continue sidebar).
3.  **Add Model:** Add a new model entry pointing to your local server:

    ```json
    {
      "title": "Local Model (koda)",
      "model": "qwen3.5-27b",
      "apiBase": "http://localhost:8080/v1",
      "completionOptions": {
        "temperature": 0.6,
        "topP": 0.95
      },
      "provider": "openai"
    }
    ```

### [Roo Cline](https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline)

Roo Cline is an autonomous coding agent that supports OpenAI-compatible backends.

1.  **Install:** Search for "Roo Cline" in the Marketplace and install it.
2.  **Configure:** Click the "Settings" button in the Roo Cline sidebar.
3.  **API Provider:** Select **OpenAI Compatible**.
4.  **Base URL:** Enter `http://localhost:8080/v1`.
5.  **Model ID:** Enter the model name from your `.env` file (e.g., `qwen3.5-27b`).

### GitHub Copilot (Note)

The official GitHub Copilot extension does **not** natively support custom OpenAI-compatible endpoints. 

**Recommended Alternatives:**
- Use **[Continue](#continue)** or **[Roo Cline](#roo-cline)** (above) for the best "Copilot-like" experience using your local server.
- These extensions provide similar autocomplete, chat, and edit features but are designed to work with local LLMs.

## Manual Interaction

You can also use the **REST Client** extension or just a terminal inside VS Code to interact with the API:

```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```
