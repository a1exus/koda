# Playwright MCP (Browser Tools)

[MCP](https://modelcontextprotocol.io/) (Model Context Protocol) lets your local model use external tools. Your llama-server provides the LLM, [Playwright MCP](https://github.com/microsoft/playwright-mcp) (`@playwright/mcp`) provides browser automation — navigate pages, click elements, fill forms, take screenshots, and extract content — and the client (OpenCode, Cursor, VS Code) wires them together.

```
Client (orchestrator)     →  OpenCode, Cursor, VS Code (Continue / Roo Code)
  ↕ MCP protocol
MCP Server (tools)        →  Playwright (@playwright/mcp)
  ↕ tool calls
LLM (inference)           →  llama-server (Koda)
```

> **Prerequisites:** Node.js 18+. On first run, `npx` downloads the `@playwright/mcp` package and its bundled browser (~200 MB).

## Playwright Options

These flags can be appended to the `args` array in any client config below:

| Argument | Effect |
| :--- | :--- |
| `--headless` | Run without a visible browser window |
| `--browser chrome` | Use Chrome instead of bundled Chromium |
| `--viewport-size 1280x720` | Set the browser viewport size |
| `--caps vision` | Enable screenshot-based vision capabilities |

---

## OpenCode

Add the `mcpServers` section to your `opencode.json` (alongside the existing `provider` section):

```json
{
  "mcpServers": {
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["@playwright/mcp"]
    }
  }
}
```

Example with headless Chrome and vision:

```json
{
  "mcpServers": {
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["@playwright/mcp", "--headless", "--browser", "chrome", "--caps", "vision"]
    }
  }
}
```

Restart OpenCode. Playwright tools (navigate, click, fill, snapshot, etc.) will be available to the model automatically.

---

## Cursor

Add to `.cursor/mcp.json` in your project root (or `~/.cursor/mcp.json` for global):

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp"]
    }
  }
}
```

Restart Cursor. Playwright tools will be available in Cursor's agent and composer modes.

---

## VS Code — Continue

Add to the `mcpServers` array in `~/.continue/config.json` (global) or `.continue/config.json` (workspace):

```json
{
  "mcpServers": [
    {
      "name": "playwright",
      "command": "npx",
      "args": ["@playwright/mcp"]
    }
  ]
}
```

> **Note:** Continue uses an array (not an object) for `mcpServers`. Each entry needs a `"name"` field.

Restart VS Code. Playwright tools will be available to Continue automatically.

---

## VS Code — Roo Code

Add to `.roo/mcp.json` in your workspace root (or `~/.roo/mcp.json` for global):

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp"]
    }
  }
}
```

Restart VS Code. Playwright tools will be available to Roo Code automatically.

---

### Compatibility

Any OpenAI-compatible client can use `http://localhost:8080/v1` with any non-empty API key. See [README.md](./README.md#-quick-start) for server defaults and override options.
