---
name: juhecli-wx-sns
description: 个微朋友圈管理 - 浏览/发布/评论/点赞/删除朋友圈
---

# juhecli-wx-sns

微信（个微）朋友圈的浏览、发布和互动操作。

## 可用命令

### 浏览朋友圈

#### 获取朋友圈时间线

```bash
juhe-cli wx sns timeline '{"max_id": "", "first_page_md5": "", "source_type": 0}'
```

参数：
- `max_id` (string, 可选): 翻页用，上一页最后一条的 ID
- `first_page_md5` (string, 可选): 首页 MD5，翻页时使用
- `source_type` (int, 可选): 来源类型，默认 0

#### 获取用户朋友圈

```bash
juhe-cli wx sns userpage '{"username": "wxid_xxx", "max_id": "", "first_page_md5": "", "source_type": 0}'
```

参数：
- `username` (string, 必填): 用户 username `[需查询]`
- 其他参数同 timeline

#### 获取朋友圈详情

```bash
juhe-cli wx sns object_detail '{"object_id": "xxx", "source_type": 0}'
```

参数：
- `object_id` (string, 必填): 朋友圈动态 ID `[来自 timeline/userpage 返回]`

### 发布朋友圈

```bash
juhe-cli wx sns post '{"title": "今天天气真好", "content_url": ""}'
```

参数：
- `title` (string, 必填): 朋友圈文本内容 `[用户提供]`
- `content_url` (string, 可选): 内容 URL（如含图片，需要先上传获取 URL）

### 互动操作

#### 评论朋友圈

```bash
juhe-cli wx sns comment '{"object_id": "xxx", "content": "不错", "reply_comment_id": "0"}'
```

参数：
- `object_id` (string, 必填): 朋友圈动态 ID `[来自 timeline 返回]`
- `content` (string, 必填): 评论内容 `[用户提供]`
- `reply_comment_id` (string, 可选): 回复的评论 ID，默认 "0"（直接评论动态）

#### 删除评论

```bash
juhe-cli wx sns delete_comment '{"object_id": "xxx", "comment_id": "123"}'
```

#### 点赞/取消点赞

```bash
juhe-cli wx sns like '{"object_id": "xxx", "status": 0}'
```

参数：
- `object_id` (string, 必填): 朋友圈动态 ID `[来自 timeline 返回]`
- `status` (int, 必填): 0=取消点赞, 1=点赞

#### 删除朋友圈

```bash
juhe-cli wx sns delete '{"object_id": "xxx"}'
```

参数：
- `object_id` (string, 必填): 自己的朋友圈动态 ID `[来自 timeline 返回]`

## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `object_id` | `[来自 timeline 返回]` | `wx sns timeline` 或 `wx sns userpage` |
| `username` | `[需查询]` | `db contact search` |
| `title`/`content` | `[用户提供]` | 用户直接提供 |

## 典型工作流

1. **浏览朋友圈**：`wx sns timeline` → 查看动态列表 → `wx sns object_detail` 查看详情
2. **互动**：timeline 获取 object_id → `wx sns like`/`wx sns comment`
3. **发带图朋友圈**：`wx cloud upload_sns_image` 上传 → 获取 content_url → `wx sns post`
4. **查看某人朋友圈**：`db contact search` 获取 username → `wx sns userpage`

## 错误处理

- object_id 不存在或已删除：返回错误
- 非好友无法查看朋友圈：返回权限错误
- 评论失败：可能被对方设置为不可评论
