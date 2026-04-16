---
name: juhecli-room
description: 企微群组管理 - 获取群列表、群成员、创建群、修改群信息
---

# juhecli-room

企微群组管理 - 获取群列表、群成员、创建群、修改群信息。

## 可用命令

### batch_detail

```bash
  juhe-cli room batch_detail '{"room_list":[]}'
```

### batch_members

```bash
  juhe-cli room batch_members '{"room_id":"","user_list":[]}'
```

### create_inner

```bash
  juhe-cli room create_inner '{"user_list":[]}'
```

### create_outer

```bash
  juhe-cli room create_outer '{"user_list":[]}'
```

### dismiss

```bash
  juhe-cli room dismiss '{"room_id":""}'
```

### invite

```bash
  juhe-cli room invite '{"room_id":"","user_list":[]}'
```

### list

```bash
  juhe-cli room list '{"limit":10,"start_index":0}'
```

### modify_name

```bash
  juhe-cli room modify_name '{"room_id":"","room_name":""}'
```

### modify_notice

```bash
  juhe-cli room modify_notice '{"notice":"","room_id":""}'
```

### quit

```bash
  juhe-cli room quit '{"room_id":""}'
```

### remove

```bash
  juhe-cli room remove '{"room_id":"","user_list":[]}'
```

### sync_info

```bash
  juhe-cli room sync_info '{"room_id":"","version":0}'
```


## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `guid` | `[需查询]` | `device list` 获取 |
| `conversation_id` | `[需查询]` | 私聊：`db contact search` 获取 user_id → 加 `S:` 前缀；群聊：`db room list` 获取 room_id → 加 `R:` 前缀 |
| `content` | `[用户提供]` | 用户直接提供 |

## 错误处理

所有命令在 API 返回错误时输出错误信息到 stderr。
