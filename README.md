# juhe-cli-skills

基于 Claude Code Skills 的企微/个微自动化操作工具集。通过 AI Agent 自然语言驱动，完成消息收发、联系人管理、群组管理等日常操作。

![架构图](https://wework.qpic.cn/wwpic3az/709267_ECcctYtWRICspEj_1776159906/0)

## 工作原理

```
用户自然语言 → Claude Code + Skills → juhe-cli 命令 → 聚合聊天 SAAS API
                                              ↓
                                        juhe-sync 数据同步
                                        （联系人/消息/群聊存储）
```

本项目提供 **Claude Code Skills**（技能定义文件），配合闭源的 `juhe-cli` 和 `juhe-sync` 二进制使用，让 AI Agent 能理解和执行企微/个微操作。

## 快速开始

### 1. 下载二进制文件

从 [Releases](../../releases) 下载对应平台的 `juhe-cli` 和 `juhe-sync`：

| 平台 | 文件 |
|------|------|
| Windows | `juhe-cli.exe` + `juhe-sync.exe` |
| Linux amd64 | `juhe-cli-linux` + `juhe-sync-linux` |
| macOS Intel | `juhe-cli-darwin-amd64` + `juhe-sync-darwin-amd64` |
| macOS Apple Silicon | `juhe-cli-darwin-arm64` + `juhe-sync-darwin-arm64` |

将二进制文件放到任意目录，确保在 PATH 中或记住路径。

### 2. 初始化 CLI

```bash
juhe-cli init
```

按提示输入 App Key 和 App Secret 即可。API 地址默认为 `https://chat-api.juhebot.com`，通常无需修改。

也可通过环境变量配置：

```bash
export JUHE_API_URL=https://chat-api.juhebot.com
export JUHE_APP_KEY=your-app-key
export JUHE_APP_SECRET=your-app-secret
```

### 3. 安装 Skills

将本项目 `skills/` 目录下的所有 SKILL.md 文件复制到你的 Claude Code 技能目录：

```bash
# 方法一：直接复制整个目录
cp -r skills/* ~/.claude/skills/

# 方法二：将本项目作为子目录放在你的项目中，Claude Code 会自动识别
```

安装后的目录结构：

```
~/.claude/skills/
├── juhecli-device/SKILL.md      # 设备管理
├── juhecli-db/SKILL.md          # 数据查询
├── juhecli-client/SKILL.md      # 客户端管理（企微）
├── juhecli-login/SKILL.md       # 登录管理（企微）
├── juhecli-user/SKILL.md        # 用户管理（企微）
├── juhecli-contact/SKILL.md     # 联系人管理（企微）
├── juhecli-msg/SKILL.md         # 消息管理（企微）
├── juhecli-room/SKILL.md        # 群组管理（企微）
├── juhecli-sync/SKILL.md        # 同步管理（企微）
├── juhecli-cdn/SKILL.md         # CDN 文件管理（企微）
├── juhecli-wx-login/SKILL.md    # 登录管理（个微）
├── juhecli-wx-client/SKILL.md   # 客户端管理（个微）
├── juhecli-wx-user/SKILL.md     # 用户管理（个微）
├── juhecli-wx-contact/SKILL.md  # 联系人管理（个微）
├── juhecli-wx-msg/SKILL.md      # 消息管理（个微）
├── juhecli-wx-room/SKILL.md     # 群组管理（个微）
├── juhecli-wx-cloud/SKILL.md    # 云存储/上传（个微）
├── juhecli-wx-label/SKILL.md    # 标签管理（个微）
├── juhecli-wx-sns/SKILL.md      # 朋友圈管理（个微）
├── juhecli-wx-app/SKILL.md      # 应用消息/小程序（个微）
└── juhecli-workflows/SKILL.md   # 工作流编排（跨命令）
```

### 4. 部署 Sync 服务（可选，用于数据查询）

`juhe-sync` 是常驻服务，负责接收回调通知、同步联系人、存储聊天记录。

```bash
# 创建配置文件（api_url 默认 https://chat-api.juhebot.com，通常无需修改）
cat > juhe-sync.json << 'EOF'
{
  "api_url": "https://chat-api.juhebot.com",
  "app_key": "your-app-key",
  "app_secret": "your-app-secret",
  "guids": ["guid-001", "guid-002"],
  "port": 8070,
  "db_path": "./juhe-sync.db",
  "sync_interval": 300
}
EOF

# 启动
./juhe-sync run --config juhe-sync.json
```

启动后设置回调地址：

```bash
# 企微
juhe-cli client set_notify_url '{"guid": "xxx", "notify_url": "http://your-server:8070/callback"}'

# 个微
juhe-cli wx client set_notify_url '{"guid": "xxx", "notify_url": "http://your-server:8070/callback"}'
```

> **注意**：`set_notify_url` 会覆盖该实例原有的回调地址。如果之前已有回调配置（如对接其他系统），请确保新地址能同时处理原有逻辑，或使用支持转发的回调服务。

### 5. 开始使用

在 Claude Code 中直接用自然语言操作：

```
你：查看我的设备列表
Claude：juhe-cli device list

你：给张三发消息"明天下午3点开会"
Claude：
  1. juhe-cli db contact search '{"keyword": "张三"}'
  2. juhe-cli wx msg send_text '{"to_username": "wxid_xxx", "content": "明天下午3点开会"}'

你：看看张三最近的聊天记录
Claude：
  1. juhe-cli db contact search '{"keyword": "张三"}'
  2. juhe-cli db msg list '{"username": "wxid_xxx", "limit": 20}'
```

## Skill 一览

### 通用 Skills

| Skill | 说明 |
|-------|------|
| `juhecli-device` | 查询设备列表，获取 GUID |
| `juhecli-db` | 查询同步的联系人/消息/群聊/同步状态 |
| `juhecli-workflows` | 跨命令工作流编排，意图路由表 |

### 企微 Skills（命令前缀无 `wx`）

| Skill | 说明 |
|-------|------|
| `juhecli-client` | 升级、恢复、停止实例，设置通知地址、代理 |
| `juhecli-login` | 获取登录二维码、检查登录状态 |
| `juhecli-user` | 获取帐号信息、公司信息、登出 |
| `juhecli-contact` | 增量同步、批量查询、搜索、更新联系人 |
| `juhecli-msg` | 发送文本/图片/文件/链接/语音/位置消息 |
| `juhecli-room` | 获取群列表、群成员、创建群、修改群信息 |
| `juhecli-sync` | 同步消息、同步联系人数据 |
| `juhecli-cdn` | 获取云存储文件、CDN 信息 |

### 个微 Skills（命令前缀 `wx`）

| Skill | 说明 |
|-------|------|
| `juhecli-wx-client` | 客户端管理 |
| `juhecli-wx-login` | 登录管理 |
| `juhecli-wx-user` | 用户信息 |
| `juhecli-wx-contact` | 添加好友、搜索、备注、删除 |
| `juhecli-wx-msg` | 文本/图片/视频/文件/表情/名片/位置/链接/小程序/视频号/撤回/引用 |
| `juhecli-wx-room` | 创建群、邀请、踢人、改群名/公告 |
| `juhecli-wx-cloud` | 上传图片/视频/文件到 CDN |
| `juhecli-wx-label` | 标签管理 |
| `juhecli-wx-sns` | 朋友圈浏览、点赞、评论、发布 |
| `juhecli-wx-app` | 应用消息、小程序 |

## 常用工作流

### 发文本消息

```
1. 查联系人：juhe-cli db contact search '{"keyword": "张三"}'
2. 发消息：
   - 个微：juhe-cli wx msg send_text '{"to_username": "wxid_xxx", "content": "hello"}'
   - 企微：juhe-cli msg send_text '{"conversation_id": "S:user_id", "content": "hello"}'
```

### 发图片/文件

```
1. 查联系人：juhe-cli db contact search '{"keyword": "张三"}'
2. 上传文件：juhe-cli wx cloud upload '{"file_type": 2, "url": "图片URL"}'
3. 发送：juhe-cli wx msg send_image '{"to_username": "wxid_xxx", ...}'
```

### 群操作

```
# 创建群
1. 查成员：juhe-cli db contact search '{"keyword": "张三"}'
2. 创建：juhe-cli wx room create '{"username_list": ["wxid_a", "wxid_b"]}'

# 邀请入群
1. 查群：juhe-cli db room list
2. 查人：juhe-cli db contact search '{"keyword": "张三"}'
3. 邀请：juhe-cli wx room invite '{"room_username": "xxx@chatroom", "username_list": [...]}'
```

## conversation_id 格式（企微）

| 类型 | 格式 | 示例 |
|------|------|------|
| 私聊 | `S:` + user_id | `S:7881303217905494` |
| 群聊 | `R:` + room_id | `R:10957014854528966` |

## 全局参数

| 参数 | 环境变量 | 说明 |
|------|---------|------|
| `--config` | | 配置文件路径 |
| `--api-url` | `JUHE_API_URL` | API 地址（默认 `https://chat-api.juhebot.com`） |
| `--app-key` | `JUHE_APP_KEY` | App Key |
| `--app-secret` | `JUHE_APP_SECRET` | App Secret |
| `--guid` | `JUHE_GUID` | 实例 GUID |

配置文件位置：`~/.config/juhe-cli/config.json`

## API 调用原理

所有请求通过 `POST /open/GuidRequest` 代理：

```json
{
  "app_key": "xxx",
  "app_secret": "xxx",
  "path": "/client/stop_client",
  "data": {
    "guid": "xxx"
  }
}
```

## Sync 服务 API

juhe-sync 提供以下 HTTP 接口（需携带 `X-App-Key` 和 `X-App-Secret` 请求头鉴权）：

| 端点 | 方法 | 说明 |
|------|------|------|
| `/callback` | POST | 接收 SAAS 回调通知 |
| `/api/contacts?guid=xxx` | GET | 查询联系人（支持 page/limit/keyword） |
| `/api/messages?guid=xxx` | GET | 查询消息（支持 username/keyword/start_time/end_time） |
| `/api/rooms?guid=xxx` | GET | 查询群聊（支持 page/limit） |
| `/api/sync-status?guid=xxx` | GET | 查看同步状态 |

## 开发

如果需要修改 Skills，可以从 CLI 二进制自动重新生成：

```bash
# 需要 juhe-cli 二进制
bash scripts/gen-skills.sh ./juhe-cli
```

## 许可证

Skills 部分采用 MIT 许可证开源。`juhe-cli` 和 `juhe-sync` 二进制文件为闭源软件，从 [Releases](../../releases) 下载。
