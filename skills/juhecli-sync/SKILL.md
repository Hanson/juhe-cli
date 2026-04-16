---
name: juhecli-sync
description: 企微同步管理 - 同步消息、同步联系人数据
---

# juhecli-sync

企微同步管理 - 同步消息、同步联系人数据。

## 可用命令

### msg

```bash
  juhe-cli sync msg '{"limit":100,"sync_key":""}'
```

### multi_data

```bash
  juhe-cli sync multi_data '{"business_id":1,"limit":10,"seq":""}'
```


## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `guid` | `[需查询]` | `device list` 获取 |
| `conversation_id` | `[需查询]` | 私聊：`db contact search` 获取 user_id → 加 `S:` 前缀；群聊：`db room list` 获取 room_id → 加 `R:` 前缀 |
| `content` | `[用户提供]` | 用户直接提供 |

## 错误处理

所有命令在 API 返回错误时输出错误信息到 stderr。
