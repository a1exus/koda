# OpenCode Integration

This guide explains how to use OpenCode with the local inference server provided by this project.

## Step-by-Step Configuration

1. **Start your local server:**
   In your terminal, run the following command to start the model you want to use:
   ```bash
   make serve ENV=profiles/.env-Qwen3.5-27B.Q4_K_M
   ```
   This starts both the browser WebUI at `http://localhost:8080` and the OpenAI-compatible API at `http://localhost:8080/v1`.

3. **Add the llama.cpp provider:**
   Copy and paste the following snippet into the `provider` section of your `opencode.json` file. Ensure the `baseURL` points to your local server. To generate a single model entry for any profile, run `make export-opencode ENV=<profile>`.

   ```json
   {
     "provider": {
       "llama.cpp": {
         "name": "llama.cpp",
         "api": "openai",
         "options": {
           "baseURL": "http://127.0.0.1:8080/v1",
           "apiKey": "local-no-key-required"
         },
         "models": {
           "qwen3.5-9b": { "name": "Qwen 3.5 9B (Local)" },
           "qwen3.5-27b": { "name": "Qwen 3.5 27B Reasoning Distilled (Local)" },
           "qwen3.5-35b-a3b": { "name": "Qwen 3.5 35B-A3B (Local)" },
           "deepseek-r1-distill-qwen-1.5b": { "name": "DeepSeek R1 Distill Qwen 1.5B (Local)" },
          "deepseek-r1-distill-qwen-7b": { "name": "DeepSeek R1 Distill Qwen 7B (Local)" },
          "deepseek-r1-distill-llama-8b": { "name": "DeepSeek R1 Distill Llama 8B (Local)" },
          "deepseek-r1-0528-qwen3-8b": { "name": "DeepSeek R1 0528 Qwen3 8B (Local)" },
          "deepseek-r1-distill-qwen-14b": { "name": "DeepSeek R1 Distill Qwen 14B (Local)" },
          "deepseek-r1-distill-qwen-32b": { "name": "DeepSeek R1 Distill Qwen 32B (Local)" },
          "deepseek-r1-distill-llama-70b": { "name": "DeepSeek R1 Distill Llama 70B (Local)" },
          "deepseek-r1": { "name": "DeepSeek R1 671B (Local)" },
          "deepseek-r1-0528": { "name": "DeepSeek R1 0528 671B (Local)" },
           "kimi-k2.5": { "name": "Kimi K2.5 (Local)" },
           "gpt-oss-20b": { "name": "GPT-OSS 20B (Local)" },
           "gpt-oss-120b": { "name": "GPT-OSS 120B (Local)" },
           "gemma-4-e2b-it": { "name": "Gemma 4 E2B Instruct (Local)" },
           "gemma-4-e4b-it": { "name": "Gemma 4 E4B Instruct (Local)" },
           "gemma-4-26b-a4b-it": { "name": "Gemma 4 26B-A4B Instruct (Local)" },
           "gemma-4-31b-it": { "name": "Gemma 4 31B Instruct (Local)" },
           "nemotron-3-nano-4b": { "name": "Nemotron 3 Nano 4B (Local)" },
          "nemotron-cascade-2-30b": { "name": "Nemotron Cascade 2 30B (Local)" },
          "nemotron-nano-3-30b": { "name": "Nemotron Nano 3 30B (Local)" },
           "nemotron-3-super-120b": { "name": "Nemotron 3 Super 120B (Local)" }
         }
       }
     }
   }
   ```


4. **Restart OpenCode:**
   Launch or restart the OpenCode application.

5. **Select the Model:**
   In the OpenCode interface, select **llama.cpp** as your provider and **Qwen 3.5 27B (Local)** as your model.

### Compatibility

Any OpenAI-compatible client can use `http://localhost:8080/v1` with any non-empty API key. See [README.md](./README.md#-quick-start) for server defaults and override options.
