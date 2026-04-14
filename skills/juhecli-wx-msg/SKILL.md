---
name: juhecli-wx-msg
description: 个微消息管理 - 发送文本/图片/视频/文件/表情/名片/位置/链接/小程序/视频号，撤回/引用/标记已读/语音转文字
---

# juhecli-wx-msg

微信（个微）消息收发和操作管理。

## 可用命令

### 发送文本消息

```bash
juhe-cli wx msg send_text '{"to_username": "wxid_xxx", "content": "hello"}'
```

参数：
- `to_username` (string, 必填): 接收人 username `[需查询]`
- `content` (string, 必填): 消息内容 `[用户提供]`

### 发送群@消息

```bash
juhe-cli wx msg send_room_at '{"to_username": "xxx@chatroom", "content": "@张三 你好", "at_list": ["wxid_zhangsan"]}'
```

参数：
- `to_username` (string, 必填): 群 ID `[需查询]`
- `content` (string, 必填): 消息内容 `[用户提供]`
- `at_list` (array, 必填): 被@人的 username 列表 `[需查询]`

### 发送名片分享

```bash
juhe-cli wx msg send_share_card '{"to_username": "wxid_xxx", "share_username": "wxid_share", "share_nickname": "张三", "share_head_img": ""}'
```

参数：
- `to_username` (string, 必填): 接收人 `[需查询]`
- `share_username` (string, 必填): 被分享人的 username `[需查询]`
- `share_nickname` (string, 必填): 被分享人昵称 `[用户提供]`
- `share_head_img` (string, 可选): 被分享人头像 URL

### 发送原始名片

```bash
juhe-cli wx msg send_share_card_raw '{"to_username": "wxid_xxx", "xml": "<msg>...</msg>"}'
```

### 发送位置

```bash
juhe-cli wx msg send_location '{"to_username": "wxid_xxx", "latitude": 39.9042, "longitude": 116.4074, "title": "天安门", "address": "北京市东城区", "scale": 15}'
```

参数：
- `to_username` (string, 必填): 接收人 `[需查询]`
- `latitude` (float, 必填): 纬度 `[用户提供]`
- `longitude` (float, 必填): 经度 `[用户提供]`
- `title` (string, 必填): 位置标题 `[用户提供]`
- `address` (string, 必填): 详细地址 `[用户提供]`
- `scale` (int, 可选): 缩放级别，默认 15

### 发送图片

```bash
juhe-cli wx msg send_image '{"to_username": "wxid_xxx", "file_id": "xxx", "aes_key": "xxx", "file_size": 12345, "big_file_size": 0, "thumb_file_size": 0, "file_md5": "xxx", "thumb_width": 0, "thumb_height": 0, "file_crc": 0}'
```

参数：
- `to_username` (string, 必填): 接收人 `[需查询]`
- `file_id` (string, 必填): CDN 文件 ID `[需上传获取]`
- `aes_key` (string, 必填): 加密密钥 `[需上传获取]`
- `file_size` (int, 必填): 文件大小 `[需上传获取]`
- 其他字段均为 `[需上传获取]` 或可选

**前置步骤**：需先调用 `wx cloud upload` 上传图片获取 file_id/aes_key/file_md5 等。

### 发送视频

```bash
juhe-cli wx msg send_video '{"to_username": "wxid_xxx", "file_id": "xxx", "aes_key": "xxx", "file_size": 12345, "file_md5": "xxx", "thumb_file_size": 0, "thumb_file_md5": "", "video_duration": 15, "file_crc": 0, "mp4_identify": ""}'
```

参数：
- `to_username` (string, 必填): 接收人 `[需查询]`
- file_id/aes_key/file_size 等 `[需上传获取]`
- `video_duration` (int, 可选): 视频时长（秒），默认 15

**前置步骤**：需先调用 `wx cloud upload` 上传视频。

### 发送文件

```bash
juhe-cli wx msg send_file '{"to_username": "wxid_xxx", "file_id": "xxx", "aes_key": "xxx", "file_size": 12345, "file_md5": "xxx", "file_name": "doc.pdf", "file_crc": 0, "file_key": ""}'
```

参数：
- `to_username` (string, 必填): 接收人 `[需查询]`
- file_id/aes_key/file_size/file_md5 `[需上传获取]`
- `file_name` (string, 必填): 文件名 `[用户提供]`

**前置步骤**：需先调用 `wx cloud upload_file` 上传文件。

### 发送表情

```bash
juhe-cli wx msg send_emoji '{"to_username": "wxid_xxx", "file_id": "xxx", "aes_key": "xxx", "file_size": 1234, "file_md5": "xxx"}'
```

### 通过 URL 发送表情

```bash
juhe-cli wx msg send_emoji_url '{"to_username": "wxid_xxx", "url": "https://example.com/emoji.gif"}'
```

### 通过 MD5 发送表情

```bash
juhe-cli wx msg send_emoji_md5 '{"to_username": "wxid_xxx", "file_md5": "xxx", "file_size": 1234}'
```

### 拍一拍

```bash
juhe-cli wx msg send_pat '{"to_username": "xxx@chatroom", "patted_username": "wxid_xxx"}'
```

参数：
- `to_username` (string, 必填): 群 ID `[需查询]`
- `patted_username` (string, 必填): 被拍的人 `[需查询]`

### 发送链接卡片 CDN

```bash
juhe-cli wx msg send_link_card_cdn '{"to_username": "wxid_xxx", "title": "标题", "desc": "描述", "url": "https://example.com", "thumb_file_id": "", "thumb_aes_key": "", "thumb_file_size": 0, "thumb_file_md5": ""}'
```

### 发送应用消息

```bash
juhe-cli wx msg send_app_msg '{"to_username": "wxid_xxx", "app_type": 0, "xml": "<msg>...</msg>", "appid": ""}'
```

### 发送小程序

```bash
juhe-cli wx msg send_mini_app '{"to_username": "wxid_xxx", "username": "gh_xxx", "appid": "wx123", "appname": "小程序名", "appicon": "", "title": "标题", "page_path": "pages/index", "file_id": "", "aes_key": "", "file_size": 0, "file_md5": ""}'
```

### 发送视频号视频

```bash
juhe-cli wx msg send_finder_video '{"to_username": "wxid_xxx", "object_id": "", "object_nonce_id": "", "username": "", "nickname": "", "avatar": "", "desc": "", "thumb_url": "", "url": "", "feed_type": 4}'
```

### 撤回消息

```bash
juhe-cli wx msg revoke '{"to_username": "wxid_xxx", "msg_id": "xxx", "client_msg_id": 0}'
```

参数：
- `to_username` (string, 必填): 消息接收人 `[需查询]`
- `msg_id` (string, 必填): 消息 ID `[来自发送返回值]`
- `client_msg_id` (int, 可选): 客户端消息 ID

### 发送引用回复

```bash
juhe-cli wx msg send_refer '{"to_username": "wxid_xxx", "content": "回复内容", "refer_msg": {"msg_type": 1, "msg_id": "xxx", "from_username": "wxid_yyy", "from_nickname": "张三", "source": "", "content": "原始消息"}}'
```

参数：
- `to_username` (string, 必填): 接收人 `[需查询]`
- `content` (string, 必填): 回复内容 `[用户提供]`
- `refer_msg` (object, 必填): 被引用的原始消息信息 `[来自消息记录]`

### 标记会话已读

```bash
juhe-cli wx msg set_read '{"to_username": "wxid_xxx"}'
```

### 新建语音转文字任务

```bash
juhe-cli wx msg new_trans_voice '{}'
```

### 检查语音转文字状态

```bash
juhe-cli wx msg check_voice_trans '{"voice_id": "xxx", "msg_id": "", "length": 0}'
```

### 上传语音转文字

```bash
juhe-cli wx msg upload_voice_trans '{"voice_id": "xxx", "msg_id": "", "length": 0}'
```

### 获取语音转文字结果

```bash
juhe-cli wx msg get_voice_trans '{"voice_id": "xxx"}'
```

## 参数来源说明

| 参数类型 | 来源 | 说明 |
|----------|------|------|
| `to_username` | `[需查询]` | 通过 `db contact search` 获取 |
| `content` | `[用户提供]` | 用户直接提供 |
| `file_id`/`aes_key`/`file_md5` | `[需上传获取]` | 先通过 `wx cloud upload` 获取 |
| `msg_id` | `[来自发送返回值]` | 发送消息后 API 返回 |

## 典型工作流

1. **发文本**：`db contact search` → 获取 to_username → `wx msg send_text`
2. **发图片**：`db contact search` → `wx cloud upload` 上传 → `wx msg send_image`
3. **发文件**：`db contact search` → `wx cloud upload_file` → `wx msg send_file`
4. **撤回消息**：发送消息后保存 msg_id → `wx msg revoke`
5. **回复消息**：`db msg list` 获取原始消息 → `wx msg send_refer`

## 错误处理

- to_username 不存在：返回发送失败
- file_id 无效：检查上传是否成功
- 撤回超时：消息超过 2 分钟无法撤回
- 群@需要 at_list：at_list 不能为空
