#!/usr/bin/env bash
set -euo pipefail
# Piik 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://piik.tv/docs/?lang=en
# 更新日期：2026-10-31
# 类型：docker
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "需要先安装 Docker"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "需要 Docker Compose v2（docker compose 子命令）"; exit 1; }

mkdir -p .download
cd .download

mkdir -p piik && cd piik
curl -fsSLo compose.yaml https://raw.githubusercontent.com/TNTcraftHIM/Piik/main/deploy/container/compose.yaml
curl -fsSLo .env https://raw.githubusercontent.com/TNTcraftHIM/Piik/main/deploy/container/.env.example
docker compose run --rm piik --check-config
docker compose up -d
echo "已启动：默认端口 8787，按 .env 里的 PORT 与 PUBLIC_BASE_URL 调整对外地址"

echo ""
if command -v curl >/dev/null 2>&1; then
  echo "等待服务启动：http://localhost:8787"
  ready=0
  for _ in $(seq 1 30); do
    if curl -sS -o /dev/null "http://localhost:8787" 2>/dev/null; then ready=1; break; fi
    sleep 2
  done
  if [ "$ready" = "1" ]; then
    echo "服务已就绪"
  else
    echo "警告：60 秒内未探测到 http://localhost:8787，请手动打开确认或查看日志"
    exit 1
  fi
else
  echo "未检测到 curl，跳过启动探测；请手动访问 http://localhost:8787 确认"
fi
echo "部署完成，浏览器访问 http://localhost:8787"
echo "若结果异常或需要改配置，请参考官方文档：https://piik.tv/docs/?lang=en"
