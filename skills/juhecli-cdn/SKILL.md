---
name: juhecli-cdn
description: 企微CDN文件管理 - 获取云存储文件、CDN信息
---

# juhecli-cdn

企微CDN文件管理 - 获取云存储文件、CDN信息。

## 可用命令

### get_file

```bash
  juhe-cli cdn get_file '{}'
```

### get_info

```bash
  juhe-cli cdn get_info '{}'
```


## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `guid` | `[需查询]` | `device list` 获取 |
| `conversation_id` | `[需查询]` | 私聊：`db contact search` 获取 user_id → 加 `S:` 前缀；群聊：`db room list` 获取 room_id → 加 `R:` 前缀 |
| `content` | `[用户提供]` | 用户直接提供 |

## 错误处理

所有命令在 API 返回错误时输出错误信息到 stderr。
