# Cursor Integration

This guide explains how to use Cursor with the local inference server provided by Koda.

## Requirement: HTTPS Endpoint

Cursor requires an **HTTPS endpoint** — it will not connect to a plain `http://localhost` server. You need to expose your local server over HTTPS first.

**Options:**

| Method | Works with | HTTPS | Guide |
| --- | --- | --- | --- |
| **Traefik** | Docker only | Via reverse proxy | [GEMINI.md](./GEMINI.md) |
| **Tailscale** | `make serve` or Docker | Built-in — `tailscale serve` provisions a cert automatically | [TAILSCALE.md](./TAILSCALE.md) |
| **Caddy** | `make serve` (non-Docker) | Local/LAN only — no Tailscale, same machine or same network | [CADDY.md](./CADDY.md) |

Once you have an HTTPS URL (e.g. `https://my-machine.tail1234.ts.net`), use that as the base URL below.

---

## Configuration

Cursor does not use a plain JSON config file — all model settings are managed through the UI and stored internally.

### Steps

1. **Start your local server:**
   ```bash
   make serve ENV=profiles/.env-gemma-4-31B-it.Q4_K_M
   ```

2. **Open Cursor Settings:**
   `Cmd+Shift+J` → **Models** tab → **Add Model**

3. **Fill in the fields:**
   - **Model name:** the `ALIAS` of the running profile (e.g. `gemma-4-31b-it`)
   - **Base URL:** your HTTPS endpoint with `/v1` (e.g. `https://my-machine.tail1234.ts.net/v1`)
   - **API Key:** any non-empty string (e.g. `local`)

4. Click **Verify** to test the connection, then **Save**.

Repeat for each model you want available in Cursor. The model name must exactly match the `ALIAS` in the profile.

---

## Available Model Aliases

See [profiles/README.md](./profiles/README.md#api-identity-aliases) for the full alias list, model sizes, and hardware requirements.

---

## Notes

- Cursor stores one active model at a time. Switch models in the model picker as you swap `make serve` profiles.
- Reasoning models (DeepSeek, GLM-4.7, GLM-5.1, MiniMax-M2.x, Qwen3.5 distills) output `<think>...</think>` blocks before the final answer — Cursor displays these in the chat.

---

## MCP (Browser Tools)

Playwright MCP adds browser automation to your local model. See [MCP-PLAYWRIGHT.md](./MCP-PLAYWRIGHT.md) for Cursor-specific setup.
