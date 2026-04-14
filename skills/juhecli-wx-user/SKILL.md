---
name: juhecli-wx-user
description: 个微用户信息 - 获取个人资料、二维码、退出登录
---

# juhecli-wx-user

查看和管理微信（个微）登录账号信息。

## 可用命令

### 获取个人资料

```bash
juhe-cli wx user profile '{}'
```

说明：获取当前登录账号的昵称、微信号、头像等信息。**不要频繁规律调用。**

返回值：
- 昵称、微信号、头像 URL、个性签名等

### 获取个人二维码

```bash
juhe-cli wx user qrcode '{"style": 0, "opcode": 1}'
```

参数：
- `style` (int, 可选): 二维码样式，默认 0
- `opcode` (int, 可选): 操作码，默认 1

### 退出登录

```bash
juhe-cli wx user logout '{}'
```

说明：退出当前微信登录。退出后需重新扫码登录。

## 典型工作流

1. `wx user profile` 查看当前登录账号信息
2. `wx user qrcode` 获取个人二维码用于分享
3. 不再使用时 `wx user logout` 安全退出

## 错误处理

- 未登录：提示需要先登录
- 频繁调用 profile：可能被限制
