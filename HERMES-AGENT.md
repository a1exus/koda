# Hermes Agent Integration

This guide explains how to use [Hermes Agent](https://github.com/nousresearch/hermes-agent) with the local inference server provided by Koda.

## What Is Hermes Agent?

Hermes Agent is a self-improving AI agent by Nous Research. It features tool use (40+ built-in tools), persistent memory, skill creation, MCP support, and multi-platform messaging (CLI, Telegram, Discord, Slack, and more). It works with any OpenAI-compatible endpoint.

## Prerequisites

Install Hermes Agent:

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
source ~/.bashrc   # or: source ~/.zshrc
```

Then run `hermes setup` for the first-time wizard, or configure manually below.

## Step-by-Step Configuration

### 1. Start your local server

```bash
make serve ENV=profiles/.env-Qwen3.5-27B.Q4_K_M
```

This starts both the browser WebUI at `http://localhost:8080` and the OpenAI-compatible API at `http://localhost:8080/v1`.

### 2. Configure the model provider

**Option A — Environment variables** (add to `~/.hermes/.env`):

```bash
OPENAI_BASE_URL=http://127.0.0.1:8080/v1
OPENAI_API_KEY=local-no-key-required
HERMES_MODEL=qwen3.5-27b
```

**Option B — Config file** (edit `~/.hermes/config.yaml`):

```yaml
model:
  provider: "custom"
  base_url: "http://127.0.0.1:8080/v1"
  api_key: "local-no-key-required"
  model: "qwen3.5-27b"
```

**Option C — CLI commands:**

```bash
hermes config set model.provider custom
hermes config set model.base_url http://127.0.0.1:8080/v1
hermes config set model.api_key local-no-key-required
hermes config set model.model qwen3.5-27b
```

The model name must match the `ALIAS` in the running profile. Run `make list` to see all available profiles and their aliases.

### 3. Start Hermes

```bash
hermes
```

## Tool-Calling Support

Hermes Agent relies on tool calling for its agentic features (file editing, terminal, web search, etc.). Use a model that supports tool calling:

| Model | Tool Calling |
|-------|:------------:|
| Qwen 3.5 (all sizes) | Yes |
| Qwen 3.6 (all sizes) | Yes |
| Gemma 4 (all variants) | Yes |
| GPT-OSS 20B / 120B | Yes |
| Nemotron Nano 3 30B | Yes |
| Nemotron 3 Super 120B | Yes |
| Kimi K2.5 | Yes |
| DeepSeek R1 (all distills) | No |
| Nemotron 3 Nano 4B | No |
| Nemotron Cascade 2 30B | No |
| GLM 4.7 / 4.7 Flash / 5.1 | No |
| MiniMax M2.1 / M2.7 | No |

Models without tool calling can still be used for conversation, but Hermes cannot invoke its built-in tools.

## Switching Models

When you swap `make serve` profiles, update the model name to match:

```bash
# Terminal 1: switch the server
make serve ENV=profiles/.env-gemma-4-31B-it.Q4_K_M

# Terminal 2: update Hermes (or use /model in the chat)
hermes config set model.model gemma-4-31b-it
```

Inside a running Hermes session, use the `/model` slash command to switch without restarting.

## Adding MCP Servers

Hermes Agent supports MCP (Model Context Protocol) servers via `~/.hermes/config.yaml`. For example, to add Playwright browser tools:

```yaml
mcp_servers:
  playwright:
    command: "npx"
    args: ["-y", "@anthropic-ai/mcp-server-playwright"]
```

See [MCP-PLAYWRIGHT.md](./MCP-PLAYWRIGHT.md) for the full Playwright setup guide. For more MCP options, see the [Hermes MCP docs](https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp).

## Remote Access

To use Hermes Agent from another machine on your network, start Koda with `HOST=0.0.0.0`:

```bash
make serve ENV=profiles/.env-Qwen3.5-27B.Q4_K_M HOST=0.0.0.0
```

Then point Hermes at the remote IP:

```bash
OPENAI_BASE_URL=http://<server-ip>:8080/v1
```

Set `API_KEY` in your profile if the server is not on localhost — Koda warns when serving on a non-loopback address without an API key. See [TAILSCALE.md](./TAILSCALE.md) for private encrypted access across machines.

## Messaging Gateway

Hermes can forward your local model to Telegram, Discord, Slack, WhatsApp, and more via its messaging gateway:

```bash
hermes gateway setup   # Interactive platform configuration
hermes gateway         # Start the gateway
```

All messages are processed through your local Koda server — no data leaves your network.

## Compatibility

Any OpenAI-compatible client can use `http://localhost:8080/v1` with any non-empty API key. See [README.md](./README.md#-quick-start) for server defaults and override options.
