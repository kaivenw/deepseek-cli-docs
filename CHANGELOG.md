# 更新日志 / Changelog

本项目通过 npm 发布:[`@kavienw/deepseek-cli`](https://www.npmjs.com/package/@kavienw/deepseek-cli)。
升级:`npm i -g @kavienw/deepseek-cli@latest`(国内加 `--registry=https://registry.npmmirror.com`)。

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
