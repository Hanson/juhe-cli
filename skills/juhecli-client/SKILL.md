---
name: juhecli-client
description: 企微客户端管理 - 恢复/停止实例，升级版本，设置通知地址/代理/桥接
---

# juhecli-client

管理企微实例的客户端生命周期，包括恢复、停止、升级、设置回调通知、代理和桥接。

## 可用命令

### 恢复实例

```bash
juhe-cli client restore '{"auto_start":true,"bridge":"","force_online":false,"proxy":"","sync_history_msg":true}'
```

说明：恢复（启动）企微实例，使实例上线运行。

参数：
- `auto_start` (bool, 可选): 是否自动启动，默认 true
- `bridge` (string, 可选): 桥接 ID `[可选]`
- `force_online` (bool, 可选): 是否强制上线，默认 false
- `proxy` (string, 可选): 代理地址 `[用户提供]`
- `sync_history_msg` (bool, 可选): 是否同步历史消息，默认 true

### 停止实例

```bash
juhe-cli client stop '{"guid": "xxx"}'
```

说明：停止企微实例，相当于退出登录。

参数：
- `guid` (string, 必填): 实例 GUID `[需查询]`

### 升级实例

```bash
juhe-cli client update '{"new_client_type":0}'
```

说明：升级企微实例到新版本。

参数：
- `new_client_type` (int, 可选): 新客户端类型，默认 0

### 设置通知地址

```bash
juhe-cli client set_notify_url '{"notify_url":"https://example.com/callback"}'
```

说明：设置企微实例的回调通知 URL，用于接收消息推送等事件。

参数：
- `notify_url` (string, 必填): 回调通知 URL `[用户提供]`

### 设置代理

```bash
juhe-cli client set_proxy '{"proxy":"http://proxy:8080"}'
```

说明：设置企微实例的代理地址。

参数：
- `proxy` (string, 必填): 代理地址 `[用户提供]`

### 设置桥接 ID

```bash
juhe-cli client set_bridge '{"bridge":"bridge_id_xxx"}'
```

说明：设置企微实例的桥接 ID，用于多实例桥接通信。

参数：
- `bridge` (string, 必填): 桥接 ID `[用户提供]`

## 参数来源说明

| 参数 | 类型 | 来源 |
|------|------|------|
| `guid` | `[需查询]` | 通过 `device list` 获取 |
| `auto_start` | `[可选]` | 布尔值，默认 true |
| `bridge` | `[用户提供]` | 用户提供的桥接 ID |
| `proxy` | `[用户提供]` | 用户提供的代理地址 |
| `notify_url` | `[用户提供]` | 用户提供的回调 URL |

## 典型工作流

1. **首次启动实例**：`device list` 获取 guid → `client restore` 恢复实例 → `client set_notify_url` 设置回调
2. **更换回调地址**：`client set_notify_url` → 设置新的通知地址
3. **通过代理启动**：`client restore` 传入 proxy 参数 → 实例通过代理上线
4. **升级实例**：`client update` → 升级到新版本
5. **停止实例**：`client stop` → 停止运行中的实例

## 错误处理

- 实例已在线：restore 会返回提示，不影响运行
- guid 不存在：stop/update 返回错误，检查 `device list`
- notify_url 格式错误：确保是有效的 HTTP/HTTPS URL
- proxy 连接失败：检查代理地址是否可达
