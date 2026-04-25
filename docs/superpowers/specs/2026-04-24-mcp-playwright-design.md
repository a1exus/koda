# MCP-PLAYWRIGHT.md Design Spec

## Goal

Create a standalone `MCP-PLAYWRIGHT.md` guide documenting Playwright MCP (browser automation tools) for use with Koda's local llama-server. Update existing docs to reference it.

## Context

MCP (Model Context Protocol) is a cross-cutting capability — it's not specific to any one client. The repo already handles cross-cutting concerns (HTTPS termination, Docker) as standalone files (`CADDY.md`, `TAILSCALE.md`, `GEMINI.md`) with one-liner links from client guides. This follows the same pattern.

Currently, Playwright MCP config exists only in `OPENCODE.md` (lines 76-119), scoped to that one client. The config is client-agnostic — the same MCP server process (`npx @playwright/mcp`) works with any MCP-capable client.

## Architecture: Three-Layer Mental Model

```
Client (orchestrator)     →  OpenCode, Cursor, VS Code (Continue/Roo)
  ↕ MCP protocol
MCP Server (tools)        →  Playwright (@playwright/mcp)
  ↕ HTTP/tool calls
LLM (inference)           →  llama-server (Koda)
```

The client wires the LLM and MCP tools together. llama-server has no MCP awareness.

## File: `MCP-PLAYWRIGHT.md`

### Structure

1. **Intro (3-4 sentences)** — Three-layer architecture: llama-server = LLM brain, Playwright MCP = browser tools, client = orchestrator. Link to modelcontextprotocol.io.

2. **Prerequisites** — Node.js 18+. First run downloads ~200 MB (Playwright + bundled browser).

3. **Playwright Options** — Universal reference table (applies to all clients):

   | Argument | Effect |
   |:--|:--|
   | `--headless` | Run without a visible browser window |
   | `--browser chrome` | Use Chrome instead of bundled Chromium |
   | `--viewport-size 1280x720` | Set the browser viewport size |
   | `--caps vision` | Enable screenshot-based vision capabilities |

4. **Client Configuration Sections:**

   **## OpenCode**
   - File: `opencode.json`
   - Format: `mcpServers` object with `type`, `command`, `args`
   - Basic config + headless+vision example
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

   **## Cursor**
   - File: `.cursor/mcp.json` (project) or `~/.cursor/mcp.json` (global)
   - Format: same `mcpServers` object (identical to OpenCode, minus `type` field)
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

   **## VS Code — Continue**
   - File: `~/.continue/config.json` (global) or `.continue/config.json` (workspace)
   - Format: `mcpServers` **array** (not object) with `name` field
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

   **## VS Code — Roo Code**
   - File: `.roo/mcp.json` (workspace) or `~/.roo/mcp.json` (global)
   - Format: same `mcpServers` object as Cursor/OpenCode
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

   Each section ends with "Restart [client]. Playwright tools (navigate, click, fill, snapshot, etc.) will be available automatically."

5. **Compatibility footer** — One-liner: any OpenAI-compatible client can use `http://localhost:8080/v1`. Link to README quick start.

### Tone and style
Matches existing guides — terse, practical, config-snippet-heavy. No emoji. Same Markdown table style as OPENCODE.md and CURSOR.md.

## Changes to Existing Files

| File | Change |
|:--|:--|
| `OPENCODE.md` | Replace lines 76-119 (full Playwright section) with ~3-line section: heading + one sentence + link to `MCP-PLAYWRIGHT.md` |
| `VSCODE.md` | Add `## MCP (Browser Tools)` section after "Alternative Extensions" — one sentence + link |
| `CURSOR.md` | Add `## MCP (Browser Tools)` section after "Notes" — one sentence + link |
| `README.md` | Add row to Documentation Index table: `MCP-PLAYWRIGHT.md` — Playwright MCP browser tools for OpenCode, Cursor, VS Code |
| `CLAUDE.md` | Add row to Documentation Files table |
| `AGENTS.md` | Add row to any docs listing (if one exists) |
| `CHANGELOG.md` | Add entry under `[Unreleased] → Added` |

## Research Notes

- **Cursor MCP format**: `.cursor/mcp.json`, identical `mcpServers` object format. Source: cursor.com/docs/context/mcp.
- **Continue MCP format**: Uses an **array** (not object) with `"name"` field. Differs from the standard keyed-object format.
- **Roo Code MCP format**: `.roo/mcp.json`, identical `mcpServers` object format.
- **Caveat**: Continue and Roo Code formats are evolving. The spec includes a note to verify against current docs. The OpenCode and Cursor configs are verified.

## Out of Scope

- Other MCP servers (filesystem, fetch, etc.) — future `MCP-*.md` files
- Claude Code MCP config (not in the existing integration guide set)
- Testing/verification of Continue and Roo Code configs (training-data-based, flagged as such)
