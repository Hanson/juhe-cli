---
name: juhecli-login
description: 企微登录管理 - 获取二维码、检查扫码状态、自动登录
---

# juhecli-login

管理企微实例的登录流程，支持二维码扫码登录和自动登录。

## 可用命令

### 获取登录二维码

```bash
juhe-cli login qrcode '{"verify_login":false}'
```

说明：获取企微登录二维码，返回 base64 图片和扫码链接。

参数：
- `verify_login` (bool, 可选): 是否验证登录，默认 false

返回值：
- 二维码 base64 图片和扫码链接

### 检查扫码状态

```bash
juhe-cli login check '{}'
```

说明：检查登录二维码的扫码状态，需在获取二维码后轮询调用。

参数：无额外 JSON 参数

返回值：
- 扫码状态（等待扫码/已扫码待确认/已确认/二维码过期）

### 自动登录

```bash
juhe-cli login auto_login '{}'
```

说明：模拟退出企微后重新打开自动登录的场景，适用于已登录过且未过期的实例。

参数：无额外 JSON 参数

## 参数来源说明

| 参数 | 类型 | 来源 |
|------|------|------|
| `guid` | `[需查询]` | 通过 `device list` 获取，或通过全局 --guid 参数传入 |
| `verify_login` | `[可选]` | 布尔值，是否验证登录 |

## 典型工作流

1. **扫码登录（完整流程）**：`login qrcode` 获取二维码 → 展示给用户扫码 → 轮询 `login check` 确认状态 → 登录成功
2. **自动登录**：已登录过的实例 → `login auto_login` → 直接恢复登录状态
3. **重新登录**：`client stop` 停止实例 → `login qrcode` 重新获取二维码 → `login check` 等待扫码

## 错误处理

- 二维码过期：需重新调用 `login qrcode` 获取新二维码
- 扫码超时：二维码有效期有限，长时间未扫码需刷新
- 自动登录失败：实例可能已过期，需重新扫码登录
- 实例已在线：check 返回已登录状态，无需重复操作
