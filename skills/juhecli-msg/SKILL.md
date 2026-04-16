---
name: juhecli-msg
description: 企微消息管理 - 发送文本/图片/文件/链接消息，撤回，确认已读
---

# juhecli-msg

企微消息管理 - 发送文本/图片/文件/链接消息，撤回，确认已读。

## 可用命令

### confirm

```bash
  juhe-cli msg confirm '{"message_type":0,"msgid":"","receiver":"","roomid":"","sender":""}'
```

### revoke

```bash
  juhe-cli msg revoke '{"conversation_id":"","msgid":""}'
```

### send_file

```bash
  juhe-cli msg send_file '{"aes_key":"","conversation_id":"","file_id":"","file_name":"","md5":"","size":0}'
```

### send_image

```bash
  juhe-cli msg send_image '{"aes_key":"","conversation_id":"","file_id":"","image_height":0,"image_width":0,"is_hd":false,"md5":"","size":0}'
```

### send_link

```bash
  juhe-cli msg send_link '{"conversation_id":"","description":"","image_url":"","title":"","url":""}'
```

### send_location

```bash
  juhe-cli msg send_location '{"address":"","conversation_id":"","latitude":0,"longitude":0,"title":"","zoom":0}'
```

### send_room_at

```bash
  juhe-cli msg send_room_at '{"at_list":[],"content":"","conversation_id":""}'
```

### send_text

```bash
  juhe-cli msg send_text '{"content":"","conversation_id":""}'
```

### send_voice

```bash
  juhe-cli msg send_voice '{"aes_key":"","conversation_id":"","file_id":"","md5":"","size":0,"voice_time":0}'
```


## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `guid` | `[需查询]` | `device list` 获取 |
| `conversation_id` | `[需查询]` | 私聊：`db contact search` 获取 user_id → 加 `S:` 前缀；群聊：`db room list` 获取 room_id → 加 `R:` 前缀 |
| `content` | `[用户提供]` | 用户直接提供 |

## 错误处理

所有命令在 API 返回错误时输出错误信息到 stderr。
