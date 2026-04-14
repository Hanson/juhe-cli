---
name: juhecli-wx-login
description: 个微登录管理 - 获取二维码、检查扫码状态、推送手机确认、验证码验证
---

# juhecli-wx-login

管理微信（个微）实例的登录流程。

## 可用命令

### 获取登录二维码

```bash
juhe-cli wx login qrcode '{}'
```

返回值：
- `qrcode`: base64 编码的二维码图片
- `qrcode_content`: 二维码扫码链接

### 检查扫码状态

```bash
juhe-cli wx login check '{}'
```

说明：获取二维码后需要轮询此接口检查扫码状态。

### 推送手机确认

```bash
juhe-cli wx login push '{}'
```

说明：推送手机确认登录通知，用户在手机上点击确认即可。

### 验证码验证

```bash
juhe-cli wx login verify '{"ticket": "xxx", "pin": "123456"}'
```

参数：
- `ticket` (string, 必填): 验证票据，从二维码回调的 authUrl 中获取 `[需查询]`
- `pin` (string, 必填): 验证码 `[用户提供]`

说明：登录 IPAD 类型设备时，如果二维码回调返回 status==1，需要输入验证码完成登录。

## 典型工作流

### 标准扫码登录

1. `wx login qrcode` → 获取二维码
2. 展示二维码或链接给用户扫码
3. `wx login check` → 轮询检查扫码状态（直到成功）
4. 扫码成功后实例自动上线

### 手机确认登录

1. `wx login qrcode` → 获取二维码
2. `wx login push` → 推送确认到手机
3. 用户手机确认后自动登录

### IPAD 验证码登录

1. `wx login qrcode` → 获取二维码
2. `wx login check` → 检查状态
3. 若返回 status==1，说明需要验证码
4. `wx login verify` → 传入 ticket 和验证码完成登录

## 错误处理

- 二维码过期：重新获取二维码
- 验证码错误：提示重新输入
- 实例已登录：返回当前登录状态
