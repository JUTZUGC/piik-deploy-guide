# Piik 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://piik.tv/docs/?lang=en
# 更新日期：2026-10-31
# 类型：docker
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

foreach ($cmd in @('git', 'docker')) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "需要先安装 $cmd" }
}
docker compose version | Out-Null
if ($LASTEXITCODE -ne 0) { throw '需要 Docker Compose v2（docker compose 子命令）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

New-Item -ItemType Directory -Force piik | Out-Null; Set-Location piik
curl.exe -fsSLo compose.yaml https://raw.githubusercontent.com/TNTcraftHIM/Piik/main/deploy/container/compose.yaml
curl.exe -fsSLo .env https://raw.githubusercontent.com/TNTcraftHIM/Piik/main/deploy/container/.env.example
docker compose run --rm piik --check-config
docker compose up -d
Write-Host "已启动：默认端口 8787，按 .env 里的 PORT 与 PUBLIC_BASE_URL 调整对外地址"

Write-Host ''
$url = 'http://localhost:8787'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成，浏览器访问 http://localhost:8787'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://piik.tv/docs/?lang=en'
