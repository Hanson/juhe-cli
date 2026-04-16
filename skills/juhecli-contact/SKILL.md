---
name: juhecli-contact
description: 企微联系人管理 - 增量同步、批量查询、搜索、更新
---

# juhecli-contact

企微联系人管理 - 增量同步、批量查询、搜索、更新。

## 可用命令

### agree

```bash
  juhe-cli contact agree '{"corp_id":"0","user_id":"0"}'
```

### batch_get_corp

```bash
  juhe-cli contact batch_get_corp '{"corp_list":[]}'
```

### batch_get_info

```bash
  juhe-cli contact batch_get_info '{"user_list":[]}'
```

### delete

```bash
  juhe-cli contact delete '{"corp_id":"0","user_id":"0"}'
```

### op_black_list

```bash
  juhe-cli contact op_black_list '{"op_type":1,"username":""}'
```

### search

```bash
  juhe-cli contact search '{"keyword":"","type":1}'
```

### sync

```bash
  juhe-cli contact sync '{"limit":10,"seq":""}'
```

### sync_apply

```bash
juhe-cli contact sync_apply '{"guid": "xxx"}'
```

### update

```bash
  juhe-cli contact update '{"company_remark":"","desc":"","label_info_list":[],"phone_list":[],"remark":"","remark_url":"","user_id":""}'
```


## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `guid` | `[需查询]` | `device list` 获取 |
| `conversation_id` | `[需查询]` | 私聊：`db contact search` 获取 user_id → 加 `S:` 前缀；群聊：`db room list` 获取 room_id → 加 `R:` 前缀 |
| `content` | `[用户提供]` | 用户直接提供 |

## 错误处理

所有命令在 API 返回错误时输出错误信息到 stderr。
