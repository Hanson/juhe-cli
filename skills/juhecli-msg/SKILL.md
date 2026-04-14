---
name: juhecli-msg
description: 企微消息管理 - 发送文本/图片/文件/链接/语音/位置消息，群@消息，撤回，确认已读
---

# juhecli-msg

企微消息收发管理，支持文本、图片、文件、链接、语音、位置等多种消息类型，以及撤回和已读确认。

## 可用命令

### 发送文本消息

```bash
juhe-cli msg send_text '{"content":"你好","conversation_id":"S:user_id_xxx"}'
```

说明：发送文本消息。

参数：
- `content` (string, 必填): 消息内容 `[用户提供]`
- `conversation_id` (string, 必填): 会话 ID `[需查询]`

### 发送图片消息

```bash
juhe-cli msg send_image '{"aes_key":"xxx","conversation_id":"S:user_id_xxx","file_id":"xxx","image_height":0,"image_width":0,"is_hd":false,"md5":"xxx","size":0}'
```

说明：发送图片消息。

参数：
- `conversation_id` (string, 必填): 会话 ID `[需查询]`
- `file_id` (string, 必填): CDN 文件 ID `[需上传获取]`
- `aes_key` (string, 必填): 加密密钥 `[需上传获取]`
- `md5` (string, 必填): 文件 MD5 `[需上传获取]`
- `size` (int, 必填): 文件大小 `[需上传获取]`
- `image_height` (int, 可选): 图片高度
- `image_width` (int, 可选): 图片宽度
- `is_hd` (bool, 可选): 是否高清，默认 false

### 发送文件消息

```bash
juhe-cli msg send_file '{"aes_key":"xxx","conversation_id":"S:user_id_xxx","file_id":"xxx","file_name":"文档.pdf","md5":"xxx","size":0}'
```

说明：发送文件消息。

参数：
- `conversation_id` (string, 必填): 会话 ID `[需查询]`
- `file_id` (string, 必填): CDN 文件 ID `[需上传获取]`
- `aes_key` (string, 必填): 加密密钥 `[需上传获取]`
- `md5` (string, 必填): 文件 MD5 `[需上传获取]`
- `size` (int, 必填): 文件大小 `[需上传获取]`
- `file_name` (string, 必填): 文件名 `[用户提供]`

### 发送链接卡片消息

```bash
juhe-cli msg send_link '{"conversation_id":"S:user_id_xxx","title":"标题","description":"描述","url":"https://example.com","image_url":""}'
```

说明：发送链接卡片消息。

参数：
- `conversation_id` (string, 必填): 会话 ID `[需查询]`
- `title` (string, 必填): 链接标题 `[用户提供]`
- `description` (string, 必填): 链接描述 `[用户提供]`
- `url` (string, 必填): 链接 URL `[用户提供]`
- `image_url` (string, 可选): 缩略图 URL `[用户提供]`

### 发送位置消息

```bash
juhe-cli msg send_location '{"conversation_id":"S:user_id_xxx","title":"天安门","address":"北京市东城区","latitude":39.9042,"longitude":116.4074,"zoom":15}'
```

说明：发送位置消息。

参数：
- `conversation_id` (string, 必填): 会话 ID `[需查询]`
- `title` (string, 必填): 位置标题 `[用户提供]`
- `address` (string, 必填): 详细地址 `[用户提供]`
- `latitude` (float, 必填): 纬度 `[用户提供]`
- `longitude` (float, 必填): 经度 `[用户提供]`
- `zoom` (int, 可选): 缩放级别，默认 15

### 发送语音消息

```bash
juhe-cli msg send_voice '{"aes_key":"xxx","conversation_id":"S:user_id_xxx","file_id":"xxx","md5":"xxx","size":0,"voice_time":0}'
```

说明：发送语音消息。

参数：
- `conversation_id` (string, 必填): 会话 ID `[需查询]`
- `file_id` (string, 必填): CDN 文件 ID `[需上传获取]`
- `aes_key` (string, 必填): 加密密钥 `[需上传获取]`
- `md5` (string, 必填): 文件 MD5 `[需上传获取]`
- `size` (int, 必填): 文件大小 `[需上传获取]`
- `voice_time` (int, 必填): 语音时长（秒）`[用户提供]`

### 发送群@消息

```bash
juhe-cli msg send_room_at '{"conversation_id":"R:room_id_xxx","content":"@张三 你好","at_list":["user_id_zhangsan"]}'
```

说明：发送群聊@消息，可同时@多人。

参数：
- `conversation_id` (string, 必填): 群会话 ID `[需查询]`
- `content` (string, 必填): 消息内容 `[用户提供]`
- `at_list` (array, 必填): 被@人的 user_id 列表 `[需查询]`

### 撤回消息

```bash
juhe-cli msg revoke '{"conversation_id":"S:user_id_xxx","msgid":"msg_xxx"}'
```

说明：撤回已发送的消息。

参数：
- `conversation_id` (string, 必填): 会话 ID `[需查询]`
- `msgid` (string, 必填): 消息 ID `[来自发送返回值]`

### 确认消息已读

```bash
juhe-cli msg confirm '{"message_type":0,"msgid":"","receiver":"","roomid":"","sender":""}'
```

说明：确认消息已读。

参数：
- `message_type` (int, 必填): 消息类型 `[用户提供]`
- `msgid` (string, 必填): 消息 ID `[来自消息记录]`
- `receiver` (string, 必填): 接收人 `[需查询]`
- `roomid` (string, 可选): 群 ID（群消息时必填）
- `sender` (string, 必填): 发送人 `[需查询]`

## 参数来源说明

| 参数类型 | 来源 | 说明 |
|----------|------|------|
| `conversation_id` | `[需查询]` | 私聊：`db contact search` 获取 user_id → 加 `S:` 前缀；群聊：`db room list` 获取 room_id → 加 `R:` 前缀 |
| `content` | `[用户提供]` | 用户直接提供消息内容 |
| `file_id`/`aes_key`/`md5`/`size` | `[需上传获取]` | 需先上传文件到 CDN 获取 |
| `msgid` | `[来自发送返回值]` | 发送消息后 API 返回 |
| `at_list` | `[需查询]` | 通过 `contact search` 或 `room batch_members` 获取 user_id |

## 典型工作流

1. **发送文本消息**：`contact search` 获取 user_id → 构造 `S:user_id` 作为 conversation_id → `msg send_text`
2. **发送群@消息**：`room list` 获取 room_id → 构造 `R:room_id` → `contact search` 获取 at_list → `msg send_room_at`
3. **发送文件**：上传文件到 CDN 获取 file_id → `msg send_file` 发送
4. **撤回消息**：发送消息后保存 msgid → `msg revoke` 撤回
5. **发送链接**：`msg send_link` 传入 URL、标题、描述等参数

## 错误处理

- conversation_id 格式错误：确保私聊 `S:` 前缀、群聊 `R:` 前缀
- conversation_id 不存在：检查 user_id/room_id 是否正确
- 文件上传未完成：send_image/send_file 需先完成 CDN 上传
- 撤回超时：消息超过一定时间无法撤回
- 群@ at_list 为空：send_room_at 的 at_list 不能为空数组
