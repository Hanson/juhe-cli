---
name: juhecli-device
description: 设备管理 - 查询当前 app_key 下所有未过期设备列表
---

# juhecli-device

查询开放平台设备列表，获取 GUID 等基础信息。

## 可用命令

### 获取设备列表

```bash
juhe-cli device list
```

参数：无（使用配置文件中的 app_key 和 app_secret 自动认证）

返回值：
- 设备列表，每条包含 `guid`、设备名称、过期时间等信息
- **guid** 字段是其他所有命令的核心参数来源

## 参数来源说明

此命令不需要任何参数，仅依赖配置文件中的 app_key/app_secret。

此命令的**返回值**是其他 skill 的参数来源：
- 返回的 `guid` → 企微/个微所有命令的 guid 参数

## 典型工作流

1. 首次使用时调用 `device list` 查看可用设备
2. 从返回结果中获取目标设备的 GUID
3. 将 GUID 配置到 config 或直接在后续命令中使用

## 错误处理

- app_key/app_secret 未配置：提示先运行 `juhe-cli init`
- 网络错误：检查 API URL 配置
