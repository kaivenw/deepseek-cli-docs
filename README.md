# DeepSeek CLI

[![npm version](https://img.shields.io/npm/v/@kavienw/deepseek-cli.svg)](https://www.npmjs.com/package/@kavienw/deepseek-cli)
[![npm downloads](https://img.shields.io/npm/dm/@kavienw/deepseek-cli.svg)](https://www.npmjs.com/package/@kavienw/deepseek-cli)
[![license](https://img.shields.io/npm/l/@kavienw/deepseek-cli.svg)](./LICENSE)

**📖 中文** · [English](./README.en.md)

> 基于 DeepSeek 模型的智能体编程命令行工具——在终端里让 AI 读你的代码、改文件、跑命令、联网搜索。Claude Code 式体验,一行命令安装即用。

```bash
npm install -g @kavienw/deepseek-cli
deepseek
```

---

## 目录

- [它能做什么](#它能做什么)
- [安装](#安装)
- [配置 API Key](#配置-api-key)
- [快速上手](#快速上手)
- [输入与交互技巧](#输入与交互技巧)
- [内置工具](#内置工具)
- [斜杠命令](#斜杠命令)
- [检查点与回溯](#检查点与回溯)
- [扩展能力](#扩展能力)
- [配置](#配置)
- [常见问题](#常见问题)

## 它能做什么

- 🤖 **智能体循环**:理解需求 → 读文件/搜代码/跑命令/改代码 → 自我验证 → 直到完成
- 📝 **文件编辑带彩色 diff**,改了什么一目了然
- 🧠 **项目记忆**(`DEEPSEEK.md`)、**会话自动保存/恢复**、**上下文自动压缩**
- ↩️ **检查点回溯**:一条命令撤销对话和文件改动
- 🧩 **可扩展**:自定义技能、插件市场、MCP 服务器、工具钩子
- 👷 **子代理**:把子任务委派给隔离的 sub-agent
- 🔎 **联网搜索**(博查 / Tavily / DuckDuckGo)、网页抓取
- 📄 **PDF / Word 自动提取文字**:拖入或 `@` 引用 `.pdf` / `.docx`,自动转成文本喂给模型
- 🖱️ **拖拽文件**进窗口即作为上下文、`@文件` 引用、`!命令` 直跑 Shell
- 🧵 **流式输出**,生成中按 `Esc` 随时打断

## 安装

**前置要求**:Node.js >= 18,以及一个 DeepSeek API Key([在此获取](https://platform.deepseek.com/api_keys))。

```bash
# 全局安装(之后直接用 deepseek 命令)
npm install -g @kavienw/deepseek-cli

# 或者免安装、即用即走
npx @kavienw/deepseek-cli "总结这个项目"
```

或用一键脚本(自动检测 Node 并安装):

```bash
curl -fsSL https://raw.githubusercontent.com/kaivenw/deepseek-cli-docs/main/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/kaivenw/deepseek-cli-docs/main/install.ps1 | iex
```

### 国内加速(npm 镜像)

如果访问 npm 官方源慢或失败,改用 [npmmirror](https://npmmirror.com)(淘宝镜像,自动同步官方源):

```bash
# 临时指定镜像安装
npm install -g @kavienw/deepseek-cli --registry=https://registry.npmmirror.com

# 或把默认源永久切到镜像(之后所有 npm 都走镜像)
npm config set registry https://registry.npmmirror.com
npm install -g @kavienw/deepseek-cli
```

装完命令同样是 `deepseek`。一键脚本如需走镜像,可先执行上面的 `npm config set registry ...` 再运行脚本。

更新与卸载:

```bash
npm install -g @kavienw/deepseek-cli@latest   # 更新到最新
npm uninstall -g @kavienw/deepseek-cli        # 卸载
```

## 配置 API Key

任选一种:

```bash
# 方式一:环境变量(推荐写进 ~/.zshrc / ~/.bashrc)
export DEEPSEEK_API_KEY="sk-xxxxxxxxxxxxxxxx"
```

```bash
# 方式二:首次运行时按提示输入,可选保存到 ~/.deepseek-cli/config.json
deepseek
```

> 从环境变量读取的密钥**不会**被写入磁盘。

### 多 Key 管理与切换(`/key`)

可以保存多把 Key(例如个人 / 团队 / 中转代理),在会话里随时切换 —— **切换不会清空当前对话**,只换凭证。

```bash
/key            # 弹出交互菜单:选择切换、➕ 添加、✕ 删除(均显示掩码 sk-86…bd47)
/key add        # 录入名称 → 密码式输入 Key(隐藏)→ 可选自定义端点
/key use 团队    # 切到指定 Key
/key list       # 列出全部 Key(● 标记当前)
/key rm 团队     # 删除某个 Key
```

- **切换 / 添加都会先校验有效性**(转圈 + ✓/✗,失效则不切换)。
- 所有 Key 在界面里只显示掩码,绝不打印完整明文。
- 设置了 `DEEPSEEK_API_KEY` 环境变量时,它标记为 `(env)` 且优先生效、不可删除。

## 快速上手

```bash
# 交互模式(多轮对话)
deepseek
› 帮我看看 src/index.ts 的入口逻辑
› 给 utils.ts 写一个单元测试
› 修复刚才那个测试里的报错

# 单次提问(问完即退出)
deepseek "把项目里所有 console.log 换成 logger.debug"

# 管道输入(把内容作为提示词)
cat error.log | deepseek "分析这段报错并给出修复建议"

# 自动批准所有工具操作(谨慎,适合可信脚本场景)
deepseek --yes "格式化整个 src 目录"

# 恢复上次会话后继续
deepseek --continue "接着上次的登录模块"
```

多行输入:**Option/Alt+Enter**(或受支持终端的 Shift+Enter)直接换行,也可行末加 `\` 续行。生成过程中按 **Esc / Ctrl-C** 可中断。

## 输入与交互技巧

| 用法 | 作用 |
|------|------|
| `@` | 输入 `@` 弹出**模糊文件/目录选择**;↑↓ 选择、Tab/Enter 插入(选目录可继续往下钻),也可直接 `@src/app.ts` |
| **拖拽文件/PDF/Word 到窗口** | 自动作为附件,无需 `@` 前缀;**PDF 与 Word(.docx)自动提取文字** |
| `# 这个项目用 PostgreSQL` | 一句话写入项目记忆(`DEEPSEEK.md`) |
| `! npm test` | 直接执行 Shell 命令,不经过 AI |
| `/` | 弹出斜杠命令菜单,Tab 补全 + 模糊搜索 |

### 键盘快捷键

| 按键 | 作用 |
|------|------|
| **Enter** | 提交(若有补全候选先采用所选项) |
| **Option/Alt+Enter** | 插入换行(多行输入,不提交) |
| **Tab** | 采用当前补全候选(命令 / @文件) |
| **↑ / ↓** | 浏览历史 / 在补全候选间移动;多行输入时在行间移动光标 |
| **Ctrl+R** | 反向增量搜索历史(再按 Ctrl+R 跳更早的匹配,↵ 采纳,Esc 取消) |
| **Ctrl+A / Ctrl+E** | 跳到行首 / 行尾 |
| **Ctrl+W / Alt+Backspace** | 删除前一个词 |
| **Ctrl+U / Ctrl+K** | 删除到行首 / 到行尾 |
| **Alt+←→ · Ctrl+←→ · Alt+B/F** | 按词移动光标 |
| **Ctrl+L** | 清屏(保留当前输入) |
| **Shift+Tab** | 循环权限模式:`normal → accept edits → plan` |
| **Esc** | 有输入时清空当前行;空输入时连按两次 → 回退检查点(`/rewind`) |
| **Ctrl+C** | 有输入时清空当前行;空输入时再按一次退出 |

> 输入历史**按项目持久化**,重启后 ↑ 仍可调出;**多行粘贴保留换行**(粘贴代码/日志不会被压成一行)。

**权限模式**(Shift+Tab 切换,提示符显示当前模式):
- **normal**:写文件 / 执行命令前逐次确认。
- **accept edits**:自动批准文件编辑(`write_file`/`edit_file`),`bash` 仍确认。
- **plan**:只读——拦截所有写 / 执行工具,模型只产出计划。

### 任务执行中(边跑边输入 / 排队)

任务运行时底部输入框可用,**可继续打字**(行为与 Claude Code 一致):

| 按键 | 作用 |
|------|------|
| **Enter** | 把消息**排队**(不打断当前任务),结束后按顺序自动执行;可排多条 |
| **↑** | 把最近一条排队消息取回输入框编辑 |
| **Esc** | 有排队消息:取回最近一条到输入框;无排队:中断当前任务 |
| **Ctrl+C** | 中断当前任务 |

排队中的消息会逐条显示在状态区(`⏳ 1. …`)。

## 内置工具

AI 会按需自动调用这些工具(有副作用的会先征求你同意):

| 工具 | 功能 | 需确认 |
|------|------|--------|
| `read_file` / `list_files` / `search_text` | 读文件(PDF / Word 自动提取文字)/ 列文件 / 正则搜索 | ✗ |
| `write_file` / `edit_file` | 写文件 / 精确编辑(带 diff 展示) | ✓ |
| `bash` | 执行 Shell 命令 | ✓ |
| `web_search` / `web_fetch` | 联网搜索 / 抓取网页 | ✗ |
| `todo_read` / `todo_write` | 维护多步任务的待办清单 | ✗ |
| `task` | 委派隔离子代理完成子任务 | ✗ |
| `set_thinking` | 用对话开关推理显示 | ✗ |

> 加 `--yes` 可跳过所有确认。也可在 `~/.deepseek-cli/config.json` 的 `alwaysAllow` 里列出免确认的工具。

## 斜杠命令

交互模式下输入 `/`(按 **Tab** 补全,单独 `/` 浏览全部):

| 命令 | 说明 |
|------|------|
| `/help` | 帮助与命令列表 |
| `/init` | 勘探项目并生成/更新 `DEEPSEEK.md` |
| `/model` · `/models` | 切换 / 列出模型 |
| `/key [add\|use\|rm\|list]` | 切换 / 添加 / 删除 API Key(带有效性校验,保留会话) |
| `/thinking [on\|off\|collapsed\|full]` | 控制推理过程显示 |
| `/review [ref]` | 审查 Git 改动 |
| `/task <prompt>` | 跑一个隔离子任务 |
| `/rewind [n]` · `/undo` | 回退对话并撤销文件改动 |
| `/btw <note>` | 记一条"顺便提一句"的题外待办 |
| `/todos` | 查看待办清单 |
| `/compress` | 手动压缩上下文 |
| `/usage` | 本次会话 Token 用量与费用 |
| `/save` · `/resume` · `/clear` | 保存 / 恢复 / 清除会话 |
| `/skills` · `/skill-new <name>` | 列出 / 新建自定义技能 |
| `/plugin <...>` | 安装与管理插件 |
| `/mcp <list\|init\|reload>` | 管理 MCP 服务器 |
| `/hooks [init\|list]` | 管理工具钩子 |
| `/config` · `/doctor` | 查看配置 / 体检环境 |
| `/exit` | 退出(自动保存) |

## 检查点与回溯

每个回合开始前自动建检查点,编辑文件前记录原内容。随时回退:

```bash
/rewind        # 交互选择回退点
/rewind 2      # 回退到第 2 个检查点
/undo          # 撤销最近一个回合
```

回退会**同时还原对话历史和文件**(回合内新建的文件会被删除)。检查点是会话内有效,不跨重启。

## 扩展能力

### 自定义技能

把常用提示词做成可复用的斜杠命令(Markdown + 前置元数据):

```bash
/skill-new deploy-staging      # 生成 .deepseek/skills/deploy-staging.md
# 编辑后即得 /deploy-staging 命令
```

支持 `{{input}}`、`{{args}}`、`{{cwd}}` 占位符。项目级 `.deepseek/skills/`,全局级 `~/.deepseek-cli/skills/`。

### 插件

```bash
/plugin search <keyword>           # 搜索市场(需配 DEEPSEEK_PLUGIN_REGISTRY)
/plugin install <name|git|路径>    # 安装
/plugin new my-plugin              # 脚手架
/plugin list | enable | disable | remove | update
```

插件可打包多个技能,装好即用。

### MCP 服务器

加载外部工具(数据库、API 等),支持 **stdio** 与 **HTTP/SSE** 两种传输。配置 `.deepseek/mcp.json`(兼容 Claude 的 `.mcp.json`):

```json
{
  "mcpServers": {
    "filesystem": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path"] },
    "remote":     { "url": "https://example.com/mcp", "type": "http", "headers": { "Authorization": "Bearer xxx" } }
  }
}
```

```bash
/mcp init      # 生成配置模板
/mcp reload    # 重新加载
/mcp list      # 查看已加载工具
```

### 工具钩子

在生命周期节点自动跑脚本(`.deepseek/hooks.json`),事件:`sessionStart` / `userPromptSubmit` / `preToolUse` / `postToolUse` / `stop`。

```json
{
  "preToolUse":  [{ "command": "echo 即将执行 $DEEPSEEK_TOOL_NAME", "continueOnError": true }],
  "postToolUse": [{ "command": "echo 完成 $DEEPSEEK_TOOL_NAME:$DEEPSEEK_TOOL_STATUS" }]
}
```

`preToolUse` / `userPromptSubmit` 失败(且未设 `continueOnError`)会阻断对应动作。

## 配置

### 配置文件 `~/.deepseek-cli/config.json`

```json
{
  "baseURL": "https://api.deepseek.com",
  "model": "deepseek-v4-pro",
  "thinkingMode": "collapsed",
  "alwaysAllow": [],
  "apiKeys": {
    "default": { "key": "sk-xxxx" },
    "团队":    { "key": "sk-yyyy", "baseURL": "https://代理地址" }
  },
  "activeApiKey": "default"
}
```

- `thinkingMode`:`off`(隐藏推理)/ `collapsed`(折叠前几行)/ `full`(完整)。
- `alwaysAllow`:始终免确认的工具名列表。
- `apiKeys` / `activeApiKey`:命名 Key 档案与当前选中项,一般用 `/key` 管理而无需手改。环境变量 Key 永不写入此处。

### 环境变量

| 变量 | 说明 |
|------|------|
| `DEEPSEEK_API_KEY` | API 密钥(必填) |
| `DEEPSEEK_BASE_URL` | API 端点(默认 `https://api.deepseek.com`) |
| `DEEPSEEK_MODEL` | 默认模型 |
| `DEEPSEEK_THINKING` | 推理显示模式 off/collapsed/full |
| `WEB_SEARCH_PROVIDER` | 搜索后端 bocha/tavily/duckduckgo |
| `BOCHA_API_KEY` / `TAVILY_API_KEY` | 搜索服务密钥 |
| `DEEPSEEK_PLUGIN_REGISTRY` | 插件市场索引地址 |

环境变量优先级高于配置文件。

### 联网搜索

`web_search` 自动选择后端:`WEB_SEARCH_PROVIDER` 指定 > 有 `BOCHA_API_KEY`(博查,**国内推荐**)> 有 `TAVILY_API_KEY` > 回退 DuckDuckGo(免 key,国内常不稳)。

```bash
export BOCHA_API_KEY="sk-你的博查key"
```

## 常见问题

**Q:安装后用什么命令?**
A:`deepseek`。

**Q:配置和会话存在哪?**
A:`~/.deepseek-cli/`(配置、会话、全局技能、插件、MCP 配置)。

**Q:支持 Windows 吗?**
A:支持(Node 跨平台)。`search_text` 在装了 ripgrep 时更快,否则自动回退。

**Q:能识别图片吗?**
A:当前 DeepSeek 对话接口为纯文本,拖入图片不会被发送(会有文本提示);待支持视觉的模型出现后可启用。

**Q:能读 PDF / Word 吗?**
A:可以。拖入或 `@` 引用 `.pdf` 或 `.docx` 会自动提取其中的文字喂给模型(纯 JS 实现,无需额外安装)。PDF 扫描件(只有图片、没有文字层)无法提取,会给出明确提示。其它二进制文件会被识别并跳过,而不是塞乱码。

**Q:更新/卸载?**
A:`npm i -g @kavienw/deepseek-cli@latest` / `npm uninstall -g @kavienw/deepseek-cli`。

---

📦 **npm**: <https://www.npmjs.com/package/@kavienw/deepseek-cli>
🐛 **问题反馈**: <https://github.com/kaivenw/deepseek-cli-docs/issues>
📜 **更新日志**: [CHANGELOG.md](./CHANGELOG.md)

## License

[MIT](./LICENSE)
