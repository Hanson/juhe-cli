---
name: juhecli-client
description: 企微客户端管理 - 升级、恢复、停止实例，设置通知地址、代理
---

# juhecli-client

企微客户端管理 - 升级、恢复、停止实例，设置通知地址、代理。

## 可用命令

### restore

```bash
  juhe-cli client restore '{"auto_start":true,"bridge":"","force_online":false,"proxy":"","sync_history_msg":true}'
```

### set_bridge

```bash
  juhe-cli client set_bridge '{"bridge":""}'
```

### set_notify_url

```bash
  juhe-cli client set_notify_url '{"notify_url":""}'
```

### set_proxy

```bash
  juhe-cli client set_proxy '{"proxy":""}'
```

### stop

```bash
juhe-cli client stop '{"guid": "xxx"}'
```

### update

```bash
  juhe-cli client update '{"new_client_type":0}'
```


## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `guid` | `[需查询]` | `device list` 获取 |
| `conversation_id` | `[需查询]` | 私聊：`db contact search` 获取 user_id → 加 `S:` 前缀；群聊：`db room list` 获取 room_id → 加 `R:` 前缀 |
| `content` | `[用户提供]` | 用户直接提供 |

## 错误处理

所有命令在 API 返回错误时输出错误信息到 stderr。
