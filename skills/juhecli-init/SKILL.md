---
name: juhecli-init
description: 初始化安装 - 自动检测系统并下载 juhe-cli/juhe-sync，完成环境配置
---

# juhecli-init

自动检测操作系统和架构，从 GitHub Releases 下载对应版本的 `juhe-cli`（和可选的 `juhe-sync`），完成安装初始化。

## 执行步骤

### 步骤 1：检测操作系统和架构

通过以下命令检测：

```bash
# 操作系统
uname -s   # Linux / Darwin / MINGW* / MSYS* / CYGWIN*

# 架构
uname -m   # x86_64 / arm64 / aarch64
```

**系统映射表**：

| uname -s | uname -m | 平台标识 | juhe-cli 文件名 | juhe-sync 文件名 |
|----------|----------|---------|----------------|-----------------|
| `MINGW*` / `MSYS*` / `CYGWIN*` / 含 `Windows` | 任意 | `windows` | `juhe-cli.exe` | `juhe-sync.exe` |
| `Darwin` | `x86_64` | `darwin-amd64` | `juhe-cli-darwin-amd64` | `juhe-sync-darwin-amd64` |
| `Darwin` | `arm64` | `darwin-arm64` | `juhe-cli-darwin-arm64` | `juhe-sync-darwin-arm64` |
| `Linux` | `x86_64` / `amd64` | `linux` | `juhe-cli-linux` | `juhe-sync-linux` |

> **注意**：Windows 平台也检查环境变量 `OS` 或 `PROCESSOR_ARCHITECTURE` 作为备选检测。

若检测到不支持的系统或架构，提示用户手动从 [Releases](https://github.com/Hanson/juhe-cli/releases) 下载。

### 步骤 2：获取最新版本号

```bash
# 从 GitHub API 获取最新 release tag
curl -sL https://api.github.com/repos/Hanson/juhe-cli/releases/latest | grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/'
```

如果 API 请求失败（网络问题、rate limit），使用已知最新版本 `v1.0.0`。

### 步骤 3：下载 juhe-cli

构建下载 URL：

```
https://github.com/Hanson/juhe-cli/releases/download/{version}/{filename}
```

下载命令（优先使用 curl）：

```bash
# 下载到当前目录
curl -sL -o {filename} "https://github.com/Hanson/juhe-cli/releases/download/{version}/{filename}"
```

如果 curl 不可用，使用 wget：

```bash
wget -q -O {filename} "https://github.com/Hanson/juhe-cli/releases/download/{version}/{filename}"
```

下载完成后验证文件大小 > 0。

**Linux/macOS 需要添加执行权限**：

```bash
chmod +x {filename}
```

**Windows 平台**：如果文件名包含平台后缀（如 `juhe-cli-linux`），重命名为 `juhe-cli.exe`；如果已经是 `juhe-cli.exe` 则无需重命名。

**非 Windows 平台**：将下载的文件重命名为 `juhe-cli`，方便后续使用：

```bash
mv {filename} juhe-cli
chmod +x juhe-cli
```

### 步骤 4：初始化 juhe-cli 配置

```bash
# 运行 init 命令，按提示输入 App Key 和 App Secret
./juhe-cli init
```

> 如果 `./juhe-cli init` 需要交互式输入，提示用户手动执行。

也可通过环境变量快速配置：

```bash
export JUHE_API_URL=https://chat-api.juhebot.com
export JUHE_APP_KEY=your-app-key
export JUHE_APP_SECRET=your-app-secret
```

### 步骤 5：询问是否安装 juhe-sync

使用 AskUserQuestion 工具询问用户：

**问题**：是否需要安装 juhe-sync 数据同步服务？

**选项**：
1. **是，安装 juhe-sync** — 下载同步服务，用于接收回调、存储联系人和消息记录
2. **否，跳过** — 仅使用 juhe-cli 基础功能

如果用户选择安装：

1. 使用步骤 2 的版本号，下载对应平台的 `juhe-sync` 文件
2. 下载 URL 同步骤 3 的模式
3. Linux/macOS 添加执行权限并重命名为 `juhe-sync`
4. 创建默认配置文件 `juhe-sync.json`：

```json
{
  "api_url": "https://chat-api.juhebot.com",
  "app_key": "",
  "app_secret": "",
  "guids": [],
  "port": 8070,
  "db_path": "./juhe-sync.db"
}
```

5. 提示用户填写 `app_key`、`app_secret` 和 `guids`
6. 告知启动命令：`./juhe-sync run --config juhe-sync.json`

### 步骤 6：安装 Claude Code Skills

```bash
# 复制 skills 到 Claude Code 技能目录
cp -r skills/* ~/.claude/skills/
```

## 下载 URL 模板

```
https://github.com/Hanson/juhe-cli/releases/download/{VERSION}/{FILENAME}
```

**可用文件**：
- `juhe-cli.exe` (Windows)
- `juhe-cli-darwin-amd64` (macOS Intel)
- `juhe-cli-darwin-arm64` (macOS Apple Silicon)
- `juhe-cli-linux` (Linux amd64)
- `juhe-sync.exe` (Windows)
- `juhe-sync-darwin-amd64` (macOS Intel)
- `juhe-sync-darwin-arm64` (macOS Apple Silicon)
- `juhe-sync-linux` (Linux amd64)

## 错误处理

- **下载失败**：检查网络连接，确认 GitHub 可访问；提示用户手动下载
- **curl/wget 均不可用**：提示用户安装 curl 或 wget
- **权限不足**：Linux/macOS 使用 `chmod +x` 添加执行权限
- **init 需要交互**：提示用户手动运行 `./juhe-cli init` 并输入凭证
- **不支持的系统/架构**：提供 GitHub Releases 页面链接，让用户手动选择

## 完成后输出

安装完成后，输出汇总信息：

```
juhe-cli 安装完成！

系统：{platform}
版本：{version}
安装路径：{install_path}

已安装组件：
- juhe-cli ✓
- juhe-sync ✓（如已安装）
- Claude Code Skills ✓

下一步：
1. 运行 ./juhe-cli init 配置 API 凭证
2. 运行 ./juhe-cli device list 查看设备
3. 如安装了 juhe-sync：编辑 juhe-sync.json 后运行 ./juhe-sync run --config juhe-sync.json
```
