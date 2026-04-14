---
name: juhecli-room
description: 企微群组管理 - 群列表/详情/成员/创建/邀请/踢人/改名/公告/解散/退出/同步
---

# juhecli-room

企微群组全生命周期管理，包括群列表查询、创建群、邀请/移除成员、修改群信息、解散/退出群等操作。

## 可用命令

### 获取群列表

```bash
juhe-cli room list '{"limit":10,"start_index":0}'
```

说明：获取当前帐号的群组列表。

参数：
- `limit` (int, 可选): 每页数量，默认 10
- `start_index` (int, 可选): 起始索引，默认 0

返回值：
- 群列表，每条包含 room_id、群名称等

### 批量获取群详情

```bash
juhe-cli room batch_detail '{"room_list":["room_id_1","room_id_2"]}'
```

说明：批量获取群组的详细信息。

参数：
- `room_list` (array, 必填): 群 ID 列表 `[需查询]`

### 批量获取群成员

```bash
juhe-cli room batch_members '{"room_id":"room_id_xxx","user_list":[]}'
```

说明：批量获取群成员的详细信息。

参数：
- `room_id` (string, 必填): 群 ID `[需查询]`
- `user_list` (array, 必填): 用户 ID 列表 `[需查询]`

### 创建内部群

```bash
juhe-cli room create_inner '{"user_list":["user_id_1","user_id_2"]}'
```

说明：创建企业内部群组。

参数：
- `user_list` (array, 必填): 初始成员 user_id 列表 `[需查询]`

### 创建外部群

```bash
juhe-cli room create_outer '{"user_list":["user_id_1","user_id_2"]}'
```

说明：创建外部群组（可包含非企业成员）。

参数：
- `user_list` (array, 必填): 初始成员 user_id 列表 `[需查询]`

### 邀请进群

```bash
juhe-cli room invite '{"room_id":"room_id_xxx","user_list":["user_id_1"]}'
```

说明：邀请用户加入群组。

参数：
- `room_id` (string, 必填): 群 ID `[需查询]`
- `user_list` (array, 必填): 被邀请人的 user_id 列表 `[需查询]`

### 移除群成员

```bash
juhe-cli room remove '{"room_id":"room_id_xxx","user_list":["user_id_1"]}'
```

说明：将成员移出群组。

参数：
- `room_id` (string, 必填): 群 ID `[需查询]`
- `user_list` (array, 必填): 被移除人的 user_id 列表 `[需查询]`

### 修改群名称

```bash
juhe-cli room modify_name '{"room_id":"room_id_xxx","room_name":"新群名"}'
```

说明：修改群组名称。

参数：
- `room_id` (string, 必填): 群 ID `[需查询]`
- `room_name` (string, 必填): 新群名称 `[用户提供]`

### 修改群公告

```bash
juhe-cli room modify_notice '{"room_id":"room_id_xxx","notice":"新公告内容"}'
```

说明：修改群组公告。

参数：
- `room_id` (string, 必填): 群 ID `[需查询]`
- `notice` (string, 必填): 公告内容 `[用户提供]`

### 解散群

```bash
juhe-cli room dismiss '{"room_id":"room_id_xxx"}'
```

说明：解散群组（仅群主可操作）。

参数：
- `room_id` (string, 必填): 群 ID `[需查询]`

### 退出群

```bash
juhe-cli room quit '{"room_id":"room_id_xxx"}'
```

说明：退出指定群组。

参数：
- `room_id` (string, 必填): 群 ID `[需查询]`

### 增量同步群信息

```bash
juhe-cli room sync_info '{"room_id":"room_id_xxx","version":0}'
```

说明：增量同步群组信息，获取最新的群名称、公告等。

参数：
- `room_id` (string, 必填): 群 ID `[需查询]`
- `version` (int, 可选): 版本号，0 表示全量同步

## 参数来源说明

| 参数 | 类型 | 来源 |
|------|------|------|
| `room_id` | `[需查询]` | 通过 `room list` 或 `db room list` 获取 |
| `user_list` | `[需查询]` | 通过 `contact search` 或 `room batch_members` 获取 user_id |
| `room_name`/`notice` | `[用户提供]` | 用户直接提供 |
| `version` | `[来自上次同步返回值]` | 从 `room sync_info` 返回值获取 |

## 典型工作流

1. **创建群→邀请成员→改名**：`room create_inner` 创建群 → 获取 room_id → `room invite` 邀请成员 → `room modify_name` 改名
2. **查询群信息**：`room list` 获取群列表 → `room batch_detail` 查看群详情
3. **查看群成员**：`room list` 获取 room_id → `room batch_members` 查看成员详情
4. **管理群成员**：`room batch_members` 查看成员 → `room remove` 移除 或 `room invite` 邀请新人
5. **发群消息**：`room list` 获取 room_id → 构造 `R:room_id` → `msg send_text` 发送群消息
6. **解散/退出群**：群主 `room dismiss` 解散群；普通成员 `room quit` 退出群

## 错误处理

- room_id 不存在：检查 `room list` 获取正确的 room_id
- 非群主操作：dismiss/modify_name 等需要群主权限
- user_list 为空：invite/remove 需要至少一个 user_id
- 创建群失败：至少需要 2 个成员才能创建群
- 已在群中：invite 已在群中的成员会返回提示
