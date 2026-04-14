---
name: juhecli-user
description: 企微用户管理 - 获取帐号信息、公司信息、登出
---

# juhecli-user

查看和管理企微当前登录帐号的个人信息和公司信息。

## 可用命令

### 获取帐号信息

```bash
juhe-cli user profile '{}'
```

说明：获取当前登录帐号的个人信息。

参数：无额外 JSON 参数

返回值：
- 帐号名称、头像、企微 ID 等个人信息

### 获取公司信息

```bash
juhe-cli user corp_info '{}'
```

说明：获取当前帐号所属公司的信息。

参数：无额外 JSON 参数

返回值：
- 公司名称、公司 ID、行业等企业信息

### 登出

```bash
juhe-cli user logout '{}'
```

说明：登出当前企微帐号。

参数：无额外 JSON 参数

## 参数来源说明

此模块的命令不依赖其他命令的返回值，仅需 guid 即可调用。

| 参数 | 类型 | 来源 |
|------|------|------|
| `guid` | `[需查询]` | 通过 `device list` 获取，或通过全局 --guid 参数传入 |

## 典型工作流

1. **查看帐号**：`user profile` → 获取当前登录帐号信息
2. **确认归属公司**：`user corp_info` → 确认当前帐号所属企业
3. **切换帐号**：`user logout` 登出 → `login qrcode` 重新登录其他帐号

## 错误处理

- 未登录：profile/corp_info 返回错误，需先通过 `login qrcode` 登录
- guid 无效：返回认证失败，检查 `device list` 获取正确 guid
- logout 后操作：登出后其他命令将无法使用，需重新登录
