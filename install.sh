#!/usr/bin/env bash
#
# DeepSeek CLI 一键安装脚本
#   curl -fsSL https://raw.githubusercontent.com/kaivenw/deepseek-cli-docs/main/install.sh | bash
#
# 作用:检测 Node.js(>=18)→ 全局安装 npm 包 → 校验 PATH → 提示下一步。
set -euo pipefail

PKG="@kavienw/deepseek-cli"
BIN="deepseek"

# ---- 颜色(仅当输出是终端时启用)----
if [ -t 1 ]; then
  BOLD=$(printf '\033[1m'); GREEN=$(printf '\033[32m'); YELLOW=$(printf '\033[33m')
  RED=$(printf '\033[31m'); DIM=$(printf '\033[2m'); RESET=$(printf '\033[0m')
else
  BOLD=""; GREEN=""; YELLOW=""; RED=""; DIM=""; RESET=""
fi
info() { printf '%s\n' "$*"; }
ok()   { printf '%s✓%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '%s!%s %s\n' "$YELLOW" "$RESET" "$*"; }
err()  { printf '%s✗%s %s\n' "$RED" "$RESET" "$*" >&2; }

printf '\n%sDeepSeek CLI 安装程序%s\n\n' "$BOLD" "$RESET"

# ---- 1. 检查 Node.js ----
if ! command -v node >/dev/null 2>&1; then
  err "未检测到 Node.js,请先安装 Node.js >= 18:"
  info "  • macOS (Homebrew):  brew install node"
  info "  • nvm (推荐):        https://github.com/nvm-sh/nvm"
  info "  • 官网下载:          https://nodejs.org/"
  exit 1
fi
NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)
if [ "${NODE_MAJOR:-0}" -lt 18 ]; then
  err "Node.js 版本过低($(node -v)),需要 >= 18,请升级后重试。"
  exit 1
fi
ok "Node.js $(node -v)"

# ---- 2. 检查 npm ----
if ! command -v npm >/dev/null 2>&1; then
  err "未检测到 npm(通常随 Node.js 一起安装)。"
  exit 1
fi
ok "npm $(npm -v)"

# ---- 3. 全局安装 ----
info ""
info "正在全局安装 ${BOLD}${PKG}${RESET} ..."
if npm install -g "$PKG"; then
  ok "安装完成"
else
  err "安装失败。"
  warn "若为权限错误(EACCES),可任选一种解决:"
  info "  • 用 nvm 管理 Node(推荐,免 sudo)"
  info "  • 设置全局前缀:  npm config set prefix \"\$HOME/.npm-global\""
  info "                  再把 \$HOME/.npm-global/bin 加入 PATH"
  info "  • 临时(不推荐): sudo npm install -g $PKG"
  exit 1
fi

# ---- 4. 校验命令是否可用 ----
info ""
if command -v "$BIN" >/dev/null 2>&1; then
  ok "命令已就绪:${BOLD}${BIN}${RESET} -> $(command -v "$BIN")"
else
  GLOBAL_BIN="$(npm prefix -g 2>/dev/null)/bin"
  warn "命令 '$BIN' 还不在 PATH 中。请将 npm 全局 bin 目录加入 PATH:"
  info "  export PATH=\"${GLOBAL_BIN}:\$PATH\""
  info "  (写进 ~/.zshrc 或 ~/.bashrc 后重开终端)"
fi

# ---- 5. 下一步 ----
cat <<EOF

${BOLD}下一步${RESET}
  1) 配置 API Key:   ${GREEN}export DEEPSEEK_API_KEY="sk-..."${RESET}
     获取地址:        https://platform.deepseek.com/api_keys
  2) 启动:            ${GREEN}${BIN}${RESET}
     或单次提问:      ${GREEN}${BIN} "总结这个项目"${RESET}

${DIM}文档与更新:  https://www.npmjs.com/package/${PKG}${RESET}
EOF
