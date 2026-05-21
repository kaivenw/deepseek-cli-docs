# DeepSeek CLI

[![npm version](https://img.shields.io/npm/v/@kavienw/deepseek-cli.svg)](https://www.npmjs.com/package/@kavienw/deepseek-cli)
[![npm downloads](https://img.shields.io/npm/dm/@kavienw/deepseek-cli.svg)](https://www.npmjs.com/package/@kavienw/deepseek-cli)
[![license](https://img.shields.io/npm/l/@kavienw/deepseek-cli.svg)](./LICENSE)

[中文](./README.md) · **English**

> An agentic coding CLI for DeepSeek models — let the AI read your codebase, edit files, run commands and search the web, right in your terminal. A Claude Code–style experience, installable in one line.

```bash
npm install -g @kavienw/deepseek-cli
deepseek
```

---

## Table of Contents

- [What it does](#what-it-does)
- [Install](#install)
- [Configure your API key](#configure-your-api-key)
- [Quick start](#quick-start)
- [Input shortcuts](#input-shortcuts)
- [Built-in tools](#built-in-tools)
- [Slash commands](#slash-commands)
- [Checkpoints & rewind](#checkpoints--rewind)
- [Extensibility](#extensibility)
- [Configuration](#configuration)
- [FAQ](#faq)

## What it does

- 🤖 **Agent loop**: understand → read/search/run/edit → self-verify → repeat until done
- 📝 **Colored diffs** on every file edit
- 🧠 **Project memory** (`DEEPSEEK.md`), **auto session save/restore**, **auto context compression**
- ↩️ **Checkpoints & rewind**: undo conversation *and* file edits with one command
- 🧩 **Extensible**: custom skills, plugin marketplace, MCP servers, tool hooks
- 👷 **Sub-agents**: delegate sub-tasks to an isolated agent
- 🔎 **Web search** (Bocha / Tavily / DuckDuckGo) and page fetching
- 🖱️ **Drag files** into the window as context, `@file` references, `!cmd` direct shell
- 🧵 **Streaming output**, press `Esc` anytime to interrupt

## Install

**Requirements**: Node.js >= 18 and a DeepSeek API key ([get one here](https://platform.deepseek.com/api_keys)).

```bash
# Global install (then use the `deepseek` command)
npm install -g @kavienw/deepseek-cli

# Or run without installing
npx @kavienw/deepseek-cli "summarize this project"
```

Or use the one-line script (detects Node and installs):

```bash
curl -fsSL https://raw.githubusercontent.com/kaivenw/deepseek-cli-docs/main/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/kaivenw/deepseek-cli-docs/main/install.ps1 | iex
```

### Faster install in China (npm mirror)

If npmjs.org is slow or blocked, use [npmmirror](https://npmmirror.com) (a read-only mirror that auto-syncs from npm):

```bash
# Install via the mirror
npm install -g @kavienw/deepseek-cli --registry=https://registry.npmmirror.com

# Or set it as your default registry (all npm traffic goes through the mirror)
npm config set registry https://registry.npmmirror.com
npm install -g @kavienw/deepseek-cli
```

The command is still `deepseek`.

Update & uninstall:

```bash
npm install -g @kavienw/deepseek-cli@latest   # update
npm uninstall -g @kavienw/deepseek-cli        # uninstall
```

## Configure your API key

Pick one:

```bash
# Option 1: environment variable (recommended; add to ~/.zshrc / ~/.bashrc)
export DEEPSEEK_API_KEY="sk-xxxxxxxxxxxxxxxx"
```

```bash
# Option 2: enter it on first run; optionally save to ~/.deepseek-cli/config.json
deepseek
```

> A key read from the environment is **never** written to disk.

## Quick start

```bash
# Interactive mode (multi-turn)
deepseek
› Walk me through the entry logic in src/index.ts
› Write a unit test for utils.ts

# One-shot (prints and exits)
deepseek "replace every console.log with logger.debug across the repo"

# Pipe input (stdin becomes the prompt)
cat error.log | deepseek "diagnose this error and suggest a fix"

# Auto-approve all tool actions (use with care)
deepseek --yes "format the whole src directory"

# Continue the previous session
deepseek --continue "carry on with the login module"
```

Multi-line input: end a line with `\`. Press **Esc / Ctrl-C** to interrupt generation.

## Input shortcuts

| Shortcut | What it does |
|------|------|
| `@src/app.ts` | Inline a file's contents into your prompt |
| **Drag a file/image in** | Auto-attached, no `@` prefix needed |
| `# this project uses PostgreSQL` | Quick-write to project memory (`DEEPSEEK.md`) |
| `! npm test` | Run a shell command directly (bypasses the AI) |
| **Esc / Ctrl-C** | Interrupt the current generation |

## Built-in tools

The AI calls these as needed (side-effecting ones ask for confirmation first):

| Tool | Purpose | Confirm |
|------|------|--------|
| `read_file` / `list_files` / `search_text` | read / list / regex search | ✗ |
| `write_file` / `edit_file` | write / precise edit (with diff) | ✓ |
| `bash` | run a shell command | ✓ |
| `web_search` / `web_fetch` | web search / fetch a page | ✗ |
| `todo_read` / `todo_write` | maintain a multi-step task list | ✗ |
| `task` | delegate to an isolated sub-agent | ✗ |
| `set_thinking` | toggle reasoning display via chat | ✗ |

> Use `--yes` to skip all confirmations, or list always-allowed tools under `alwaysAllow` in `~/.deepseek-cli/config.json`.

## Slash commands

In interactive mode, type `/` (press **Tab** to complete, `/` alone to browse):

| Command | Description |
|------|------|
| `/help` | Help and command list |
| `/init` | Explore the project and generate/update `DEEPSEEK.md` |
| `/model` · `/models` | Switch / list models |
| `/thinking [on\|off\|collapsed\|full]` | Control reasoning display |
| `/review [ref]` | Review Git changes |
| `/task <prompt>` | Run an isolated sub-task |
| `/rewind [n]` · `/undo` | Rewind conversation and undo file edits |
| `/btw <note>` | Jot a by-the-way TODO without derailing the task |
| `/todos` | Show the task list |
| `/compress` | Manually compress context |
| `/usage` | Token usage and cost for this session |
| `/save` · `/resume` · `/clear` | Save / restore / clear session |
| `/skills` · `/skill-new <name>` | List / create custom skills |
| `/plugin <...>` | Install and manage plugins |
| `/mcp <list\|init\|reload>` | Manage MCP servers |
| `/hooks [init\|list]` | Manage tool hooks |
| `/config` · `/doctor` | Show config / health check |
| `/exit` | Quit (auto-saves) |

## Checkpoints & rewind

A checkpoint is created before each turn, and file contents are recorded before edits. Rewind anytime:

```bash
/rewind        # interactively choose a point
/rewind 2      # rewind to checkpoint #2
/undo          # undo the most recent turn
```

Rewinding restores **both the conversation and the files** (files created during the turn are deleted). Checkpoints live within the session.

## Extensibility

### Custom skills

Turn frequent prompts into reusable slash commands (Markdown + front matter):

```bash
/skill-new deploy-staging      # creates .deepseek/skills/deploy-staging.md
# edit it, then run /deploy-staging
```

Supports `{{input}}`, `{{args}}`, `{{cwd}}`. Project-level `.deepseek/skills/`, global `~/.deepseek-cli/skills/`.

### Plugins

```bash
/plugin search <keyword>           # search the marketplace (set DEEPSEEK_PLUGIN_REGISTRY)
/plugin install <name|git|path>    # install
/plugin new my-plugin              # scaffold
/plugin list | enable | disable | remove | update
```

### MCP servers

Load external tools (databases, APIs, etc.) over **stdio** or **HTTP/SSE**. Configure `.deepseek/mcp.json` (Claude-compatible `.mcp.json` also works):

```json
{
  "mcpServers": {
    "filesystem": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path"] },
    "remote":     { "url": "https://example.com/mcp", "type": "http", "headers": { "Authorization": "Bearer xxx" } }
  }
}
```

```bash
/mcp init      # generate a config template
/mcp reload    # reload
/mcp list      # show loaded tools
```

### Tool hooks

Run shell scripts at lifecycle points (`.deepseek/hooks.json`). Events: `sessionStart` / `userPromptSubmit` / `preToolUse` / `postToolUse` / `stop`.

```json
{
  "preToolUse":  [{ "command": "echo about to run $DEEPSEEK_TOOL_NAME", "continueOnError": true }],
  "postToolUse": [{ "command": "echo done $DEEPSEEK_TOOL_NAME:$DEEPSEEK_TOOL_STATUS" }]
}
```

A failing `preToolUse` / `userPromptSubmit` hook (without `continueOnError`) blocks the action.

## Configuration

### Config file `~/.deepseek-cli/config.json`

```json
{
  "baseURL": "https://api.deepseek.com",
  "model": "deepseek-v4-pro",
  "thinkingMode": "collapsed",
  "alwaysAllow": []
}
```

- `thinkingMode`: `off` (hide reasoning) / `collapsed` (first lines) / `full`.
- `alwaysAllow`: tools that never need confirmation.

### Environment variables

| Variable | Description |
|------|------|
| `DEEPSEEK_API_KEY` | API key (required) |
| `DEEPSEEK_BASE_URL` | API endpoint (default `https://api.deepseek.com`) |
| `DEEPSEEK_MODEL` | Default model |
| `DEEPSEEK_THINKING` | Reasoning display off/collapsed/full |
| `WEB_SEARCH_PROVIDER` | Search backend bocha/tavily/duckduckgo |
| `BOCHA_API_KEY` / `TAVILY_API_KEY` | Search service keys |
| `DEEPSEEK_PLUGIN_REGISTRY` | Plugin marketplace index URL |

Environment variables take precedence over the config file.

## FAQ

**Q: What's the command after install?**
A: `deepseek`.

**Q: Where are config and sessions stored?**
A: `~/.deepseek-cli/` (config, sessions, global skills, plugins, MCP config).

**Q: Windows support?**
A: Yes (Node is cross-platform). `search_text` is faster with ripgrep installed; otherwise it falls back automatically.

**Q: Can it read images?**
A: DeepSeek's chat API is currently text-only, so dropped images are not sent (you'll see a notice). It will work once a vision-capable model is available.

**Q: Update / uninstall?**
A: `npm i -g @kavienw/deepseek-cli@latest` / `npm uninstall -g @kavienw/deepseek-cli`.

---

📦 **npm**: <https://www.npmjs.com/package/@kavienw/deepseek-cli>

## License

[MIT](./LICENSE)
