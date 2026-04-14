---
name: juhecli-wx-cloud
description: 个微 CDN 云存储 - 上传/下载图片/视频/文件/表情等媒体资源
---

# juhecli-wx-cloud

微信（个微）CDN 云存储操作，用于上传和下载媒体文件。**上传是发送媒体消息的前置步骤。**

## 可用命令

### 上传操作

#### 上传到 CDN

```bash
juhe-cli wx cloud upload '{"file_type": 2, "url": "https://example.com/image.jpg"}'
```

参数：
- `file_type` (int, 必填): 文件类型（2=图片）`[用户提供]`
- `url` (string, 必填): 文件 URL `[用户提供]`

返回值（**关键** — 用于后续发送命令）：
- `file_id` → `wx msg send_image` 的 file_id
- `aes_key` → `wx msg send_image` 的 aes_key
- `file_size` → `wx msg send_image` 的 file_size
- `file_md5` → `wx msg send_image` 的 file_md5

#### 上传朋友圈图片

```bash
juhe-cli wx cloud upload_sns_image '{"url": "https://example.com/img.jpg"}'
```

#### 上传朋友圈视频

```bash
juhe-cli wx cloud upload_sns_video '{"url": "https://example.com/video.mp4"}'
```

#### 上传文件

```bash
juhe-cli wx cloud upload_file '{"file_type": 2, "url": "https://example.com/doc.pdf"}'
```

#### 上传朋友圈视频文件

```bash
juhe-cli wx cloud upload_sns_video_file '{}'
```

#### 上传朋友圈图片文件

```bash
juhe-cli wx cloud upload_sns_image_file '{}'
```

#### 上传大文件

```bash
juhe-cli wx cloud upload_big '{}'
```

#### 更新 CDN DNS

```bash
juhe-cli wx cloud update_dns '{}'
```

### 下载操作

#### 下载 CDN 文件

```bash
juhe-cli wx cloud download '{"file_type": 2, "file_id": "xxx", "aes_key": "xxx", "file_size": 12345, "file_name": "image.jpg"}'
```

参数：
- `file_type` (int, 必填): 文件类型
- `file_id` (string, 必填): 文件 ID `[来自消息记录]`
- `aes_key` (string, 必填): 加密密钥 `[来自消息记录]`
- `file_size` (int, 必填): 文件大小 `[来自消息记录]`
- `file_name` (string, 必填): 保存文件名 `[用户提供]`

#### 下载收藏文件

```bash
juhe-cli wx cloud download_fav '{"file_type": 2, "file_id": "xxx", "aes_key": "xxx", "file_size": 0, "file_name": "fav.jpg"}'
```

#### 下载企微文件

```bash
juhe-cli wx cloud download_wwfile '{"url": "", "auth_key": "", "aes_key": "", "file_name": "", "fast_download": false}'
```

#### 下载语音

```bash
juhe-cli wx cloud download_voice '{"msg_id": "xxx", "length": 0, "room_username": "", "file_name": "voice.amr", "to_mp3": false}'
```

参数：
- `msg_id` (string, 必填): 语音消息 ID `[来自消息记录]`
- `to_mp3` (bool, 可选): 是否转为 MP3，默认 false

#### 下载微信表情

```bash
juhe-cli wx cloud download_wxemotion '{"url": "", "token": "", "enc_idx": "", "key": "", "file_name": "emoji.gif"}'
```

#### 下载图片

```bash
juhe-cli wx cloud download_image '{}'
```

#### 下载视频

```bash
juhe-cli wx cloud download_video '{}'
```

#### 下载文件

```bash
juhe-cli wx cloud download_file '{}'
```

#### 下载收藏文件

```bash
juhe-cli wx cloud download_fav_file '{}'
```

#### 下载微信表情

```bash
juhe-cli wx cloud download_wx_emotion '{}'
```

## 参数映射关系（上传 → 发送）

### 上传图片 → 发送图片

| upload 返回字段 | send_image 参数 |
|-----------------|-----------------|
| `file_id` | `file_id` |
| `aes_key` | `aes_key` |
| `file_size` | `file_size` |
| `file_md5` | `file_md5` |

### 上传文件 → 发送文件

| upload 返回字段 | send_file 参数 |
|-----------------|----------------|
| `file_id` | `file_id` |
| `aes_key` | `aes_key` |
| `file_size` | `file_size` |
| `file_md5` | `file_md5` |

## 典型工作流

1. **发送图片**：`wx cloud upload` 上传 → 获取 file_id/aes_key → `wx msg send_image`
2. **发送文件**：`wx cloud upload_file` 上传 → 获取参数 → `wx msg send_file`
3. **下载消息媒体**：从消息记录获取 file_id/aes_key → `wx cloud download`

## 错误处理

- URL 无效或无法访问：返回下载失败
- 文件过大：可能需要使用 upload_big
- file_id/aes_key 不匹配：返回解密失败
