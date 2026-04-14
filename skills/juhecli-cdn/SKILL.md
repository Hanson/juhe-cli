---
name: juhecli-cdn
description: 企微CDN文件管理 - 获取私有化云存储文件、CDN认证信息
---

# juhecli-cdn

企微私有化 CDN 文件管理，用于获取云存储文件和 CDN 认证信息。

## 可用命令

### 获取 CDN 认证信息

```bash
juhe-cli cdn get_info '{}'
```

说明：获取私有化 CDN 服务认证信息。参数可复用，建议每 3 小时更新一次。

参数：无额外 JSON 参数（使用全局 guid 认证）

### 获取云存储文件

```bash
juhe-cli cdn get_file '{}'
```

说明：获取私有化云存储文件。

参数：无额外 JSON 参数（使用全局 guid 认证）

## 参数来源说明

| 参数 | 类型 | 来源 |
|------|------|------|
| `guid` | `[需查询]` | 通过 `device list` 获取，或通过全局 --guid 参数传入 |

此模块的命令不依赖其他命令的返回值，仅需 guid 即可调用。

## 典型工作流

1. **获取 CDN 认证**：`cdn get_info` → 获取 CDN 认证信息 → 用于后续文件操作
2. **下载文件**：`cdn get_info` 获取认证 → `cdn get_file` 下载文件

## 错误处理

- CDN 信息过期：需重新调用 `get_info` 刷新（建议每 3 小时）
- guid 无效：返回认证失败，检查 `device list` 获取正确 guid
- 私有化部署未启用 CDN：检查服务端配置
