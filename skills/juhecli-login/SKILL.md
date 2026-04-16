---
name: juhecli-login
description: 企微登录管理 - 获取登录二维码、检查登录状态
---

# juhecli-login

企微登录管理 - 获取登录二维码、检查登录状态。

## 可用命令

### auto_login

```bash
  juhe-cli login auto_login '{}'
```

### check

```bash
  juhe-cli login check '{}'
```

### qrcode

```bash
  juhe-cli login qrcode '{"verify_login":false}'
```


## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `guid` | `[需查询]` | `device list` 获取 |
| `conversation_id` | `[需查询]` | 私聊：`db contact search` 获取 user_id → 加 `S:` 前缀；群聊：`db room list` 获取 room_id → 加 `R:` 前缀 |
| `content` | `[用户提供]` | 用户直接提供 |

## 错误处理

所有命令在 API 返回错误时输出错误信息到 stderr。
