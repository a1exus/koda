# Pi Coding Agent Integration

This guide explains how to use [Pi Coding Agent](https://github.com/badlogic/pi-mono) with the local inference server provided by Koda.

## What Is Pi Coding Agent?

Pi is an interactive coding agent CLI from the [pi-mono](https://github.com/badlogic/pi-mono) toolkit. It supports tool calling (file editing, terminal, web search), multi-provider LLM access, session management, and a terminal UI. It connects to any OpenAI-compatible endpoint via a `models.json` config file.

## Prerequisites

Install Pi globally:

```bash
npm install -g @mariozechner/pi-coding-agent
```

## Step-by-Step Configuration

### 1. Start your local server

```bash
make serve ENV=models/bartowski/Qwen_Qwen3.5-27B-GGUF.Q4_K_M.env
```

This starts both the browser WebUI at `http://localhost:8080` and the OpenAI-compatible API at `http://localhost:8080/v1`.

### 2. Add Koda as a custom provider

Create or edit `~/.pi/agent/models.json`:

```json
{
  "providers": {
    "koda": {
      "baseUrl": "http://127.0.0.1:8080/v1",
      "api": "openai-completions",
      "apiKey": "local-no-key-required",
      "compat": {
        "supportsDeveloperRole": false,
        "supportsReasoningEffort": false,
        "supportsUsageInStreaming": false
      },
      "models": [
        { "id": "qwen3.5-0.8b", "name": "Qwen 3.5 0.8B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "qwen3.5-2b", "name": "Qwen 3.5 2B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "qwen3.5-4b", "name": "Qwen 3.5 4B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "qwen3.5-9b", "name": "Qwen 3.5 9B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "qwen3.5-27b", "name": "Qwen 3.5 27B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "qwen3.5-35b-a3b", "name": "Qwen 3.5 35B-A3B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "qwen3.5-122b-a10b", "name": "Qwen 3.5 122B-A10B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "qwen3.5-397b-a17b", "name": "Qwen 3.5 397B-A17B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "qwen3.6-27b", "name": "Qwen 3.6 27B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 262144, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "qwen3.6-35b-a3b", "name": "Qwen 3.6 35B-A3B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 262144, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "gemma-4-e2b-it", "name": "Gemma 4 E2B Instruct (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "gemma-4-e4b-it", "name": "Gemma 4 E4B Instruct (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "gemma-4-26b-a4b-it", "name": "Gemma 4 26B-A4B Instruct (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "gemma-4-31b-it", "name": "Gemma 4 31B Instruct (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "gpt-oss-20b", "name": "GPT-OSS 20B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "gpt-oss-120b", "name": "GPT-OSS 120B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "nemotron-nano-3-30b", "name": "Nemotron Nano 3 30B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "nemotron-3-super-120b", "name": "Nemotron 3 Super 120B (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "kimi-k2.5", "name": "Kimi K2.5 (Local)", "reasoning": false, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "deepseek-r1", "name": "DeepSeek R1 671B (Local)", "reasoning": true, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "deepseek-r1-0528", "name": "DeepSeek R1 0528 671B (Local)", "reasoning": true, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "deepseek-r1-distill-qwen-32b", "name": "DeepSeek R1 Distill Qwen 32B (Local)", "reasoning": true, "input": ["text"], "contextWindow": 131072, "maxTokens": 8192, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } }
      ]
    }
  }
}
```

Add or remove entries to match the profiles you use. The model `id` must match the `ALIAS` in the running profile. Run `make list` to see all available profiles.

### 3. Start Pi with Koda

```bash
pi --provider koda --model qwen3.5-27b
```

Or start Pi and select the model interactively with `/model`.

## Compatibility Notes

The `compat` block disables features that `llama.cpp` does not support:

| Flag | Why |
|------|-----|
| `supportsDeveloperRole: false` | llama.cpp uses `system` role, not `developer` |
| `supportsReasoningEffort: false` | No reasoning effort API parameter |
| `supportsUsageInStreaming: false` | Avoids `stream_options` errors |

For reasoning models (DeepSeek R1 distills), add `"thinkingFormat": "deepseek"` to the model's `compat` override if Pi does not parse `<think>` blocks correctly:

```json
{
  "id": "deepseek-r1-distill-qwen-32b",
  "reasoning": true,
  "compat": { "thinkingFormat": "deepseek" }
}
```

## Tool-Calling Support

Pi relies on tool calling for file editing, terminal commands, and web search. Models without tool calling support can still be used for conversation via `--no-tools`. See [HERMES-AGENT.md](./HERMES-AGENT.md#tool-calling-support) for the full tool-calling compatibility table.

## Switching Models

The `models.json` file reloads each time you open `/model` in a Pi session — no restart required. When you swap `make serve` profiles, just select the new alias from the model picker.

## Minimal Configuration

If you only run one model at a time, a single-entry config is enough:

```json
{
  "providers": {
    "koda": {
      "baseUrl": "http://127.0.0.1:8080/v1",
      "api": "openai-completions",
      "apiKey": "local-no-key-required",
      "compat": {
        "supportsDeveloperRole": false,
        "supportsReasoningEffort": false,
        "supportsUsageInStreaming": false
      },
      "models": [
        { "id": "qwen3.5-27b" }
      ]
    }
  }
}
```

Only the `id` field is required per model. Pi uses sensible defaults for the rest.

## MCP

Pi does not include built-in MCP support. Its philosophy favors CLI tools with READMEs and an extension system. MCP integration can be added via extensions if needed.

## Compatibility

Any OpenAI-compatible client can use `http://localhost:8080/v1` with any non-empty API key. See [README.md](./README.md#-quick-start) for server defaults and override options.
