---
name: juhecli-wx-client
description: 个微客户端管理 - 恢复/停止实例，查询状态/版本，设置通知地址/代理/桥接
---

# juhecli-wx-client

管理微信（个微）实例的客户端生命周期。

## 可用命令

### 恢复实例

```bash
juhe-cli wx client restore '{"proxy": "", "is_login_proxy": false, "bridge": "", "sync_history_msg": true, "auto_start": true}'
```

参数：
- `proxy` (string, 可选): 代理地址，支持 http/socks4/socks5
- `is_login_proxy` (bool, 可选): 是否使用登录代理 **[个微独有]**（企微无此参数）
- `bridge` (string, 可选): 桥接 ID
- `sync_history_msg` (bool, 可选): 是否同步历史消息，默认 true
- `auto_start` (bool, 可选): 是否自动启动，默认 true

### 停止实例

```bash
juhe-cli wx client stop '{}'
```

### 获取实例状态

```bash
juhe-cli wx client status '{}'
```

返回值：
- `status` 字段：0=已停止, 1=运行中, 2=已在线

### 获取实例版本

```bash
juhe-cli wx client version '{}'
```

### 设置通知地址

```bash
juhe-cli wx client set_notify_url '{"notify_url": "https://example.com/callback"}'
```

参数：
- `notify_url` (string, 必填): 回调通知 URL

### 设置代理

```bash
juhe-cli wx client set_proxy '{"proxy": "socks5://127.0.0.1:1080", "is_long_proxy": false}'
```

参数：
- `proxy` (string, 必填): 代理地址
- `is_long_proxy` (bool, 可选): 是否长代理 **[个微独有]**

### 设置桥接 ID

```bash
juhe-cli wx client set_bridge '{"bridge": "bridge-id"}'
```

### 升级实例

```bash
juhe-cli wx client update '{"new_client_type": 1}'
```

参数：
- `new_client_type` (int, 必填): 新版本类型（只能升级不能降级）

## 与企微差异

| 参数 | 企微 | 个微 |
|------|------|------|
| restore 的 is_login_proxy | 无 | 有 |
| set_proxy 的 is_long_proxy | 无 | 有 |
| status 命令 | 无 | 有 |
| version 命令 | 无 | 有 |

## 典型工作流

1. `wx client status` 检查实例状态
2. 若已停止：`wx client restore` 恢复实例
3. `wx client status` 确认恢复成功（status=2 表示在线）

## 错误处理

- 实例不存在：返回错误
- 重复恢复：提示实例已运行
- 升级失败：版本类型无效或已是最高版本
