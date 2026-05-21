#!/usr/bin/env pwsh
# DeepSeek CLI 安装脚本 (Windows PowerShell)
#   irm https://raw.githubusercontent.com/kaivenw/deepseek-cli-docs/main/install.ps1 | iex
#
# 作用:检测 Node.js(>=18)→ 全局安装 npm 包 → 校验 PATH → 提示下一步。

$Pkg = "@kavienw/deepseek-cli"
$Bin = "deepseek"

Write-Host ""
Write-Host "DeepSeek CLI 安装程序" -ForegroundColor Cyan
Write-Host ""

# ---- 1. 检查 Node.js ----
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Host "✗ 未检测到 Node.js,请先安装 Node.js >= 18:" -ForegroundColor Red
  Write-Host "    • winget:  winget install OpenJS.NodeJS.LTS"
  Write-Host "    • 官网:    https://nodejs.org/"
  return
}
$nodeMajor = [int](node -p "process.versions.node.split('.')[0]")
if ($nodeMajor -lt 18) {
  Write-Host "✗ Node.js 版本过低($(node -v)),需要 >= 18,请升级后重试。" -ForegroundColor Red
  return
}
Write-Host "✓ Node.js $(node -v)" -ForegroundColor Green

# ---- 2. 检查 npm ----
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
  Write-Host "✗ 未检测到 npm(通常随 Node.js 一起安装)。" -ForegroundColor Red
  return
}
Write-Host "✓ npm $(npm -v)" -ForegroundColor Green

# ---- 3. 全局安装 ----
Write-Host ""
Write-Host "正在全局安装 $Pkg ..."
npm install -g $Pkg
if ($LASTEXITCODE -ne 0) {
  Write-Host "✗ 安装失败。可尝试以管理员身份打开 PowerShell 重试,或检查 npm 全局目录权限。" -ForegroundColor Red
  return
}
Write-Host "✓ 安装完成" -ForegroundColor Green

# ---- 4. 校验命令 ----
Write-Host ""
$cmd = Get-Command $Bin -ErrorAction SilentlyContinue
if ($cmd) {
  Write-Host "✓ 命令已就绪:$Bin -> $($cmd.Source)" -ForegroundColor Green
} else {
  Write-Host "! 命令 '$Bin' 还不在 PATH。请确认 npm 全局 bin 目录在 PATH 中:" -ForegroundColor Yellow
  Write-Host "    npm prefix -g    # 该目录应在 PATH 里(重开终端生效)"
}

# ---- 5. 下一步 ----
Write-Host ""
Write-Host "下一步" -ForegroundColor Cyan
Write-Host "  1) 配置 API Key:  `$env:DEEPSEEK_API_KEY = `"sk-...`""
Write-Host "     永久写入:       setx DEEPSEEK_API_KEY `"sk-...`""
Write-Host "     获取地址:       https://platform.deepseek.com/api_keys"
Write-Host "  2) 启动:           $Bin"
Write-Host "     或单次提问:     $Bin `"总结这个项目`""
Write-Host ""
Write-Host "文档与更新: https://www.npmjs.com/package/$Pkg" -ForegroundColor DarkGray
