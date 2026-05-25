# 更新日志 / Changelog

本项目通过 npm 发布:[`@kavienw/deepseek-cli`](https://www.npmjs.com/package/@kavienw/deepseek-cli)。
升级:`npm i -g @kavienw/deepseek-cli@latest`(国内加 `--registry=https://registry.npmmirror.com`)。

## 0.3.0

**PDF 支持**
- 拖入 / `@` 引用 / `read_file` PDF 时**自动提取文字**(`unpdf`,纯 JS、无原生依赖、懒加载),不再把二进制塞给模型。
- 扫描件(无文字层)给出"无法提取、不支持 OCR"的清晰提示;其它二进制文件(`.docx`/`.zip` 等)会被识别并跳过,而非输出乱码。

**交互细节打磨**
- 生成中**中断提示更显眼**:状态行常驻高亮 `Esc`(有队列时为 `Ctrl+C`)to interrupt。
- `/` 命令菜单显示 **`+N more · keep typing to narrow`** 计数。
- `@` 选择器支持**目录补全**:选中目录不补空格、可继续往下钻。

## 0.2.0

**输入交互大幅增强(对标 Claude Code / readline)**
- **多行粘贴保留换行**:启用 bracketed paste,粘贴代码/日志不再被压成一行(此前会丢换行)。
- **行内编辑快捷键**:Ctrl+A/E 行首尾、Ctrl+U/K 删到行首/尾、Ctrl+W 与 Alt+Backspace 删词、Alt+D 删后词、Ctrl/Alt+←→ 与 Alt+B/F 按词移动、Ctrl+D 删字符/空行退出、Ctrl+L 清屏。
- **输入历史持久化**:按项目存到 `~/.deepseek-cli/history/`,重启后 ↑ 仍可调出;新增 **Ctrl+R 反向增量搜索**。
- **原生换行**:Option/Alt+Enter(及受支持终端的 Shift+Enter)直接插入换行;多行输入时 ↑↓ 在行间移动光标。
- 空输入时底部常驻浅色快捷键提示条。

## 0.1.9

**多 API Key 管理与切换(`/key`)**
- 新增 `/key`(别名 `/keys`):
  - 裸 `/key` 弹出交互菜单 —— 选择切换、➕ 添加、✕ 删除,所有 Key 显示掩码(`sk-86…bd47`)。
  - `/key add` 录入名称 → 密码式隐藏输入 Key → 可选自定义端点;`/key use <名>`、`/key rm <名>`、`/key list`。
- **切换 / 添加先校验有效性**(转圈 + ✓/✗,失效则不切换),校验走轻量的 `models.list`。
- **切换 Key 保留当前会话**,只重建底层客户端、不清空上下文。
- 配置新增 `apiKeys` / `activeApiKey`;旧的单 `apiKey` 自动迁移为 `default` 档案;环境变量 Key 标记 `(env)`、优先生效、永不写盘、不可删除。
- 启动 Banner 与 `/config` 显示当前 Key(掩码 + 名称)。

## 0.1.8

**对齐 Claude Code 的交互逻辑**
- **Ctrl+C**:有输入时清空当前行;空输入时再按一次才退出(不再一按即退)。
- **Esc**:有输入时清空当前行;空输入时连按两次回退到检查点(`/rewind`)。
- **Shift+Tab**:循环权限模式 `normal → accept edits → plan`(提示符显示当前模式)。
  - `accept edits` 自动批准文件编辑、`bash` 仍确认;`plan` 只读、模型只产出计划。
- **@ 交互式文件选择**:输入 `@` 弹出模糊文件搜索,↑↓ 选择、Tab/Enter 插入路径。
- **任务执行中排队**(对齐 Claude Code v2.1):边跑边输入,Enter 入队并逐条显示(`⏳ 1. …`),↑ 取回编辑,Esc 在有队列时取回、无队列时中断,Ctrl+C 中断。

**修复与优化**
- `search_text` 缓存 ripgrep 探测,避免每次搜索都启动子进程。
- `read_file` 行数统计修正(不再因末尾换行多算 1)。
- `SIGTERM`/`SIGHUP` 时清理 MCP 子进程,避免残留。

## 0.1.x(早期)
- 智能体循环、内置工具(读写/编辑带 diff/bash/搜索/联网/todo/task)。
- 项目记忆与智能 `/init`、会话保存/恢复、上下文压缩、检查点回溯(`/rewind`)。
- 自定义技能、插件市场、MCP 服务器(stdio + HTTP/SSE)、工具钩子。
- 拖拽附件、`@文件`、`!命令`、`#记忆`、thinking 显示控制、国内 npm 镜像说明。
