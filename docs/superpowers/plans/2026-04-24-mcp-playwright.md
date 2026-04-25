# MCP-PLAYWRIGHT.md Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a standalone `MCP-PLAYWRIGHT.md` guide for Playwright MCP browser tools and update all existing docs to reference it.

**Architecture:** One new Markdown file (`MCP-PLAYWRIGHT.md`) following the repo's established pattern for cross-cutting guides (like `CADDY.md`, `TAILSCALE.md`). Six existing files get small edits — replacing the inline Playwright section in `OPENCODE.md`, adding one-liner links in `VSCODE.md`/`CURSOR.md`, and updating doc indexes in `README.md`/`CLAUDE.md`/`AGENTS.md`/`CHANGELOG.md`.

**Tech Stack:** Markdown only — no application code, no tests.

**Spec:** `docs/superpowers/specs/2026-04-24-mcp-playwright-design.md`

---

### Task 1: Create `MCP-PLAYWRIGHT.md`

**Files:**
- Create: `MCP-PLAYWRIGHT.md`

- [ ] **Step 1: Write the complete file**

```markdown
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

Any OpenAI-compatible client can use `http://localhost:8080/v1` with any non-empty API key. See [README.md](../../../README.md#-quick-start) for server defaults and override options.
```

- [ ] **Step 2: Commit**

```bash
git add MCP-PLAYWRIGHT.md
git commit -m "Add MCP-PLAYWRIGHT.md — Playwright browser tools guide for all clients"
```

---

### Task 2: Replace Playwright section in `OPENCODE.md`

**Files:**
- Modify: `OPENCODE.md:76-124` (replace full Playwright MCP section + Compatibility footer)

- [ ] **Step 1: Replace lines 76-124 with a link section**

Replace the entire block from `## Adding Playwright MCP (Browser Tools)` through `### Compatibility` (and its content) with:

```markdown
## Adding Playwright MCP (Browser Tools)

Playwright MCP adds browser automation (navigate, click, fill, screenshot, extract) to your local model. See [MCP-PLAYWRIGHT.md](./MCP-PLAYWRIGHT.md) for setup instructions — covers OpenCode, Cursor, and VS Code (Continue / Roo Code).

### Compatibility

Any OpenAI-compatible client can use `http://localhost:8080/v1` with any non-empty API key. See [README.md](../../../README.md#-quick-start) for server defaults and override options.
```

- [ ] **Step 2: Commit**

```bash
git add OPENCODE.md
git commit -m "Replace inline Playwright MCP section with link to MCP-PLAYWRIGHT.md"
```

---

### Task 3: Add MCP link to `CURSOR.md`

**Files:**
- Modify: `CURSOR.md:56` (append after the last line)

- [ ] **Step 1: Add MCP section after the Notes section**

Append to end of file:

```markdown

---

## MCP (Browser Tools)

Playwright MCP adds browser automation to your local model. See [MCP-PLAYWRIGHT.md](./MCP-PLAYWRIGHT.md) for Cursor-specific setup.
```

- [ ] **Step 2: Commit**

```bash
git add CURSOR.md
git commit -m "Add MCP browser tools link to CURSOR.md"
```

---

### Task 4: Add MCP link to `VSCODE.md`

**Files:**
- Modify: `VSCODE.md:83` (insert after "Alternative Extensions" section divider, before "Manual Interaction")

- [ ] **Step 1: Add MCP section between "Alternative Extensions" and "Manual Interaction"**

Insert after line 84 (`---`) and before line 86 (`## Manual Interaction`):

```markdown

## MCP (Browser Tools)

Playwright MCP adds browser automation to your local model. See [MCP-PLAYWRIGHT.md](./MCP-PLAYWRIGHT.md) for Continue and Roo Code setup.

---

```

- [ ] **Step 2: Commit**

```bash
git add VSCODE.md
git commit -m "Add MCP browser tools link to VSCODE.md"
```

---

### Task 5: Update documentation indexes

**Files:**
- Modify: `README.md:186` (add row to Documentation Index table)
- Modify: `CLAUDE.md:71` (add row to Documentation Files table)
- Modify: `CHANGELOG.md:11` (update existing Playwright changelog entry)

- [ ] **Step 1: Add row to README.md Documentation Index**

Insert after line 186 (`| [**TAILSCALE.md**](./TAILSCALE.md) | Private remote access ...`):

```markdown
| [**MCP-PLAYWRIGHT.md**](./MCP-PLAYWRIGHT.md) | Playwright MCP browser tools for OpenCode, Cursor, and VS Code |
```

- [ ] **Step 2: Add row to CLAUDE.md Documentation Files**

Insert after line 71 (`| `CHANGELOG.md` | Version history ...`):

```markdown
| `MCP-PLAYWRIGHT.md` | Playwright MCP browser tools for OpenCode, Cursor, and VS Code. |
```

- [ ] **Step 3: Update CHANGELOG.md**

Replace line 11:
```
- Added Playwright MCP (browser tools) section to `OPENCODE.md` — configuration guide for `@playwright/mcp` with headed/headless modes and vision capabilities
```

With:
```
- Added `MCP-PLAYWRIGHT.md` — standalone Playwright MCP guide with per-client configuration for OpenCode, Cursor, and VS Code (Continue / Roo Code); replaces inline section previously in `OPENCODE.md`
```

- [ ] **Step 4: Commit**

```bash
git add README.md CLAUDE.md CHANGELOG.md
git commit -m "Add MCP-PLAYWRIGHT.md to documentation indexes"
```

---

### Task 6: Update AGENTS.md (if applicable)

**Files:**
- Modify: `AGENTS.md` (no dedicated docs listing exists — skip or add minimal reference)

- [ ] **Step 1: Verify AGENTS.md has no docs index to update**

`AGENTS.md` has no documentation index table. The file references client guides only in the "Adding a New Model Profile" checklist (lines 129-140), which is about model profiles, not MCP. No change needed.

- [ ] **Step 2: Skip — no commit needed**

No modification required. AGENTS.md does not have a documentation index.
