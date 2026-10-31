# Piik 一键部署指南

> 第三方部署指南 · 非 Piik 官方仓库。官方项目：[TNTcraftHIM/Piik](https://github.com/TNTcraftHIM/Piik)
> 内容来自官方文档（2026-10-31）。项目迭代快，请以[官方文档](https://piik.tv/docs/?lang=en)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用装客户端：主人选屏幕或窗口，发个邀请链接，朋友在手机或电脑浏览器里就能看，还能接管键鼠。

⚠️ 自建站点需要 Docker Compose v2 的 Linux x64 / ARM64 服务器（Windows 用 Windows x64 服务端包）。默认端口 8787，P2P 还需要放行 STUN 的 3478。它是给熟人小圈子用的共享工具，最多 20 人观看；请只共享你有权共享的内容，别用来转播付费内容或做公开直播。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/piik-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会检查 Docker Compose，下载部署文件、校验配置，再拉起 Web 界面与信令服务，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）

4. **打开管理面板**
   浏览器访问 [http://localhost:8787](http://localhost:8787)，按官方引导完成初始化配置。

## Piik 是什么？

Piik 是开源的开一个小房间共享屏幕或游戏，朋友用浏览器就能看，媒体默认点对点直连，也能自己架站（协议：MIT，<img src="https://img.shields.io/github/stars/TNTcraftHIM/Piik?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

一个程序同时提供 Web 界面、房间管理与可选媒体转发：主人共享屏幕、窗口、标签页或摄像头，观众用浏览器加入，支持语音、聊天、画面内互动与经批准的远程接管。

- 观众零安装：发链接，浏览器直接看
- P2P 优先：媒体点对点直连，服务器压力小
- 可选 SFU：网络复杂的场景可开启转发兜底
- 房间可控：邀请链接、房间码与可选密码
- 一起玩：共享键鼠与手柄，可随时收回控制
- 一个程序架站：Web 界面与信令打包在一起

（来源：[官方仓库](https://github.com/TNTcraftHIM/Piik)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 3 | . |
| 观 | 众 |
| P | 2 |
| 房 | 间 |
| 可 | 共 |
| M | I |

| 需要注意 | 说明 |
|---|---|
| 自 | 建 |
| P | 2 |
| 最 | 多 |
| 自 | 签 |
| 项 | 目 |

> 以上基于官方文档与社区反馈整理（2026-10-31），以官方最新文档为准。

## 快速部署（官方方式）

```bash
mkdir -p piik && cd piik
curl -fsSLo compose.yaml https://raw.githubusercontent.com/TNTcraftHIM/Piik/main/deploy/container/compose.yaml
curl -fsSLo .env https://raw.githubusercontent.com/TNTcraftHIM/Piik/main/deploy/container/.env.example
docker compose run --rm piik --check-config
docker compose up -d
echo "已启动：默认端口 8787，按 .env 里的 PORT 与 PUBLIC_BASE_URL 调整对外地址"
```

启动后浏览器访问 [http://localhost:8787](http://localhost:8787)（管理面板）。（来源：[https://github.com/TNTcraftHIM/Piik#self-hosting](https://github.com/TNTcraftHIM/Piik#self-hosting)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README 与 self-hosting 文档确认端口 8787、Compose 步骤与 STUN 配置 | 已核对 2026-10-31 |
| Release v2.5.0 资产名与大小已核对 | 已核对 2026-10-31 |
| 未实测部署与共享画面 | 说明 2026-10-31 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-10-31 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-31 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；本仓库的 MCP 只提供部署步骤、端口与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-31）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\piik-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 两种用法

| 用法 | 适合 | 怎么做 |
|---|---|---|
| 本地开房 | 临时和朋友看个片子、打个游戏 | 装 Piik App，选 Public invite，复制邀请链接 |
| 自建站点 | 固定小圈子、想要自己的域名 | 用 Docker Compose 部署服务端 |

## 自建关键配置

`.env` 里最常改的几项：

| 变量 | 作用 |
|---|---|
| `PORT` | 服务端口，示例为 8787 |
| `PUBLIC_BASE_URL` | 对外访问地址，邀请链接会用它 |
| `TLS_SELF_SIGNED` | 没有证书时先自签，正式使用请换成真证书 |
| `STUN_URLS` | P2P 打洞用的 STUN 地址 |

启动前先跑 `docker compose run --rm piik --check-config`，配置有问题会直接报出来。

## 发布包对照（v2.5.0）

| 用途 | 文件 | 大小 |
|---|---|---|
| Linux x64 服务端 | piik-4997896-runtime.tar.gz | 14.2 MB |
| Linux ARM64 服务端 | piik-4997896-linux-arm64-runtime.tar.gz | 12.9 MB |
| Windows x64 服务端 | piik-4997896-windows-amd64-runtime.zip | 14.4 MB |
| Windows 客户端 | piik-app-windows-amd64.zip | 37.5 MB |
| macOS 客户端 | piik-app-darwin-arm64.zip / darwin-amd64.zip | 34.3 / 37.2 MB |
| Linux 客户端 | piik-app-linux-amd64.zip | 35.3 MB |
| Android 客户端 | piik-app-android-universal.apk | 48.5 MB |

## 注意

- 自建站点要配好 `PUBLIC_BASE_URL`，否则邀请链接打不开
- P2P 需要放行 STUN 端口，NAT 严格时开 SFU 兜底
- 只共享你有权共享的内容，不用于公开转播
- 远程接管要主人逐个批准，用完记得收回
- 房间数据存在 `piik-data` 卷里，备份它就行

## 常见坑

- docker compose 不可用：升级 Docker Desktop，确认 v2 子命令
- 邀请链接打不开：检查 PUBLIC_BASE_URL 是否写成局域网 IP 或域名
- 连不上房间：放行 8787 与 STUN 端口，必要时开 SFU
- 浏览器提示证书不安全：自签证书属正常，正式使用换正规证书
- 画面卡顿：先确认是不是走了 P2P，再看上行带宽
- 远程接管没反应：确认主人已在界面上批准
- 想换端口：改 .env 的 PORT，防火墙同步放行

## 免责声明

本仓库为第三方指南，与 Piik 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-31），项目迭代快，请以[官方文档](https://piik.tv/docs/?lang=en)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
