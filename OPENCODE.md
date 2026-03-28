# OpenCode Integration

This guide explains how to use OpenCode with the local inference server provided by this project.

## Step-by-Step Configuration

1. **Start your local server:**
   In your terminal, run the following command to start the model you want to use:
   ```bash
   make serve ENV=.env-Qwen3.5-27B.Q4_K_M
   ```

2. **Open the OpenCode config file:**
   Open your OpenCode configuration file in your favorite text editor:
   ```bash
   nano ~/.config/opencode/opencode.json
   ```

3. **Add the llama.cpp provider:**
   Copy and paste the following snippet into the `providers` section of your `opencode.json` file. Ensure the `baseUrl` points to your local server:

   ```json
   {
     "name": "llama.cpp",
     "provider": "openai",
     "baseUrl": "http://127.0.0.1:8080/v1",
     "apiKey": "local-no-key-required",
     "models": [
       {
         "id": "qwen3.5-27b",
         "name": "Qwen 3.5 27B (Local)"
       }
     ]
   }
   ```

4. **Restart OpenCode:**
   Launch or restart the OpenCode application.

5. **Select the Model:**
   In the OpenCode interface, select **llama.cpp** as your provider and **Qwen 3.5 27B (Local)** as your model.

### Compatibility

Since the server is OpenAI-compatible, any client can use the same base URL (`http://localhost:8080/v1`) with any non-empty API key to interact with the running model.
