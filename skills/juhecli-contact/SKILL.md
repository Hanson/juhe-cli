---
name: juhecli-contact
description: 企微联系人管理 - 增量同步、批量查询、搜索、更新、删除、黑名单、同意申请
---

# juhecli-contact

企微联系人全生命周期管理，包括同步、搜索、批量查询、更新、删除、黑名单操作和联系人申请处理。

## 可用命令

### 搜索联系人

```bash
juhe-cli contact search '{"keyword":"张三","type":1}'
```

说明：按关键词搜索联系人，支持姓名、备注名等模糊搜索。

参数：
- `keyword` (string, 必填): 搜索关键词 `[用户提供]`
- `type` (int, 可选): 搜索类型，默认 1

### 增量同步联系人

```bash
juhe-cli contact sync '{"limit":10,"seq":""}'
```

说明：增量同步联系人列表，首次 seq 为空。

参数：
- `limit` (int, 可选): 每次同步数量，默认 10
- `seq` (string, 可选): 同步序列号，空字符串表示从头同步 `[来自上次同步返回值]`

### 批量获取联系人信息

```bash
juhe-cli contact batch_get_info '{"user_list":[]}'
```

说明：批量获取联系人详细信息。

参数：
- `user_list` (array, 必填): 用户 ID 列表 `[用户提供]`

### 批量获取企业联系人信息

```bash
juhe-cli contact batch_get_corp '{"corp_list":[]}'
```

说明：批量获取企业联系人信息。

参数：
- `corp_list` (array, 必填): 企业联系人列表 `[用户提供]`

### 同意联系人申请

```bash
juhe-cli contact agree '{"corp_id":"0","user_id":"0"}'
```

说明：同意他人的联系人申请。

参数：
- `corp_id` (string, 必填): 企业 ID `[需查询]`
- `user_id` (string, 必填): 用户 ID `[需查询]`

### 同步申请联系人

```bash
juhe-cli contact sync_apply '{}'
```

说明：同步收到的联系人申请列表。

参数：无额外 JSON 参数

### 更新联系人

```bash
juhe-cli contact update '{"user_id":"","remark":"","company_remark":"","desc":"","label_info_list":[],"phone_list":[],"remark_url":""}'
```

说明：更新联系人信息，如备注、描述、标签等。

参数：
- `user_id` (string, 必填): 用户 ID `[需查询]`
- `remark` (string, 可选): 备注名 `[用户提供]`
- `company_remark` (string, 可选): 企业备注 `[用户提供]`
- `desc` (string, 可选): 描述 `[用户提供]`
- `label_info_list` (array, 可选): 标签列表 `[用户提供]`
- `phone_list` (array, 可选): 电话列表 `[用户提供]`
- `remark_url` (string, 可选): 备注链接 `[用户提供]`

### 删除联系人

```bash
juhe-cli contact delete '{"corp_id":"0","user_id":"0"}'
```

说明：删除指定联系人。

参数：
- `corp_id` (string, 必填): 企业 ID `[需查询]`
- `user_id` (string, 必填): 用户 ID `[需查询]`

### 操作黑名单

```bash
juhe-cli contact op_black_list '{"op_type":1,"username":""}'
```

说明：添加或移除黑名单。op_type: 1=添加, 2=移除。

参数：
- `op_type` (int, 必填): 操作类型，1=添加黑名单，2=移除黑名单 `[用户提供]`
- `username` (string, 必填): 用户名 `[需查询]`

## 参数来源说明

| 参数 | 类型 | 来源 |
|------|------|------|
| `keyword` | `[用户提供]` | 用户直接提供搜索关键词 |
| `user_id` | `[需查询]` | 通过 `contact search` 或 `contact sync` 获取 |
| `corp_id` | `[需查询]` | 通过 `contact search` 或 `contact batch_get_corp` 获取 |
| `seq` | `[来自上次同步返回值]` | 从 `contact sync` 返回值获取，空=从头同步 |
| `remark`/`desc` | `[用户提供]` | 用户直接提供 |

## 典型工作流

1. **搜索联系人→发消息**：`contact search` 获取 user_id → `db contact search` 获取 conversation_id → `msg send_text` 发送消息
2. **首次同步联系人**：`contact sync` seq="" → 获取联系人列表 → 保存 seq → 继续同步
3. **同意好友申请**：`contact sync_apply` 查看申请列表 → `contact agree` 同意申请
4. **更新联系人备注**：`contact search` 找到联系人 → `contact update` 修改备注
5. **拉黑联系人**：`contact search` 获取 username → `contact op_black_list` op_type=1

## 错误处理

- 搜索无结果：检查关键词是否正确，尝试模糊搜索
- sync 返回空：可能已同步完所有联系人
- user_id 不存在：检查 ID 是否正确，可能需要先 sync 同步
- 重复申请：agree 已同意的联系人不会重复添加
