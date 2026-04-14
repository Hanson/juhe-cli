---
name: juhecli-wx-label
description: 个微标签管理 - 标签增删改查、联系人标签管理、按标签查询联系人
---

# juhecli-wx-label

微信（个微）标签管理和联系人标签操作。

## 可用命令

### 获取标签列表

```bash
juhe-cli wx label list '{}'
```

返回值：标签列表，包含 `label_id`、`label_name` 等。

### 添加标签

```bash
juhe-cli wx label add '{"label_name": "客户"}'
```

参数：
- `label_name` (string, 必填): 标签名称 `[用户提供]`

返回值：新创建的标签 label_id。

### 更新标签

```bash
juhe-cli wx label update '{"label_id": 1, "label_name": "VIP客户"}'
```

参数：
- `label_id` (int, 必填): 标签 ID `[需查询]` — 通过 `label list` 获取
- `label_name` (string, 必填): 新标签名 `[用户提供]`

### 删除标签

```bash
juhe-cli wx label del '{"label_id": 1}'
```

参数：
- `label_id` (int, 必填): 标签 ID `[需查询]`

### 修改联系人标签

```bash
juhe-cli wx label modify '{"username_list": ["wxid_a", "wxid_b"], "label_id_list": [1, 2]}'
```

参数：
- `username_list` (array, 必填): 联系人 username 列表 `[需查询]`
- `label_id_list` (array, 必填): 标签 ID 列表 `[需查询]`

### 按标签查询联系人

```bash
juhe-cli wx label contacts '{"label_id_list": [1, 2]}'
```

参数：
- `label_id_list` (array, 必填): 标签 ID 列表 `[需查询]`

返回值：该标签下的联系人列表。

### 查询标签使用数量

```bash
juhe-cli wx label usage '{"label_id_list": [1, 2]}'
```

参数：
- `label_id_list` (array, 必填): 标签 ID 列表 `[需查询]`

## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `label_id` | `[需查询]` | `wx label list` 获取标签列表 |
| `label_name` | `[用户提供]` | 用户直接提供 |
| `username_list` | `[需查询]` | `db contact search` 查询 |

## 典型工作流

1. **创建标签并应用**：`wx label add` 创建 → 获取 label_id → `wx label modify` 给联系人打标签
2. **按标签查找联系人**：`wx label list` 找到标签 → `wx label contacts` 查询联系人
3. **标签整理**：`wx label list` → `wx label update` 重命名 → `wx label del` 删除无用标签

## 错误处理

- 标签名重复：返回已存在错误
- label_id 不存在：返回标签不存在错误
- username 不存在：返回联系人不存在
