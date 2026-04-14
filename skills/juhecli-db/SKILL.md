---
name: juhecli-db
description: 数据库查询 - 查询 juhe-sync 同步的联系人/消息/群聊/同步状态，是跨命令工作流的核心依赖
---

# juhecli-db

查询 juhe-sync 同步服务存储的联系人、消息、群聊等数据。需要先配置 sync_url。

## 可用命令

### 联系人查询

#### 获取联系人列表

```bash
juhe-cli db contact list '{"guid": "xxx", "page": 1, "limit": 20}'
```

参数：
- `guid` (string, 必填): 实例 GUID
- `page` (int, 可选): 页码，默认 1
- `limit` (int, 可选): 每页数量，默认 20

#### 搜索联系人

```bash
juhe-cli db contact search '{"guid": "xxx", "keyword": "张三"}'
```

参数：
- `guid` (string, 必填): 实例 GUID
- `keyword` (string, 必填): 搜索关键词（姓名、备注名、微信号等）

返回值：
- 匹配的联系人列表，每条包含 `username`（个微ID）或 `user_id`（企微ID）、`nickname`、`remark` 等字段

### 消息查询

#### 获取聊天记录

```bash
juhe-cli db msg list '{"guid": "xxx", "username": "wxid_xxx", "limit": 20}'
```

参数：
- `guid` (string, 必填): 实例 GUID
- `username` (string, 必填): 对方 username `[需查询]` — 通过 `db contact search` 获取
- `limit` (int, 可选): 消息数量，默认 20

#### 搜索消息

```bash
juhe-cli db msg search '{"guid": "xxx", "keyword": "合同", "start_time": "2024-01-01", "end_time": "2024-12-31"}'
```

参数：
- `guid` (string, 必填): 实例 GUID
- `keyword` (string, 必填): 搜索关键词
- `start_time` (string, 可选): 开始时间
- `end_time` (string, 可选): 结束时间

### 群聊查询

#### 获取群列表

```bash
juhe-cli db room list '{"guid": "xxx", "page": 1, "limit": 20}'
```

参数：
- `guid` (string, 必填): 实例 GUID
- `page` (int, 可选): 页码
- `limit` (int, 可选): 每页数量

返回值：
- 群列表，每条包含 `room_username`（格式如 `xxx@chatroom`）、`nickname` 等

### 同步状态

#### 查看同步状态

```bash
juhe-cli db sync-status '{"guid": "xxx"}'
```

参数：
- `guid` (string, 必填): 实例 GUID

返回值：
- seq（同步序列号）、最后同步时间、各数据类型的同步统计

## 参数来源说明

| 参数 | 类型 | 来源 |
|------|------|------|
| `guid` | `[需查询]` | 通过 `device list` 获取 |
| `keyword` | `[用户提供]` | 用户直接提供搜索关键词 |
| `username` | `[需查询]` | 通过 `db contact search` 的返回结果获取 |
| `start_time`/`end_time` | `[可选]` | 用户指定时间范围 |

**关键映射关系：**
- `db contact search` 返回的 `username` → `db msg list` 的 `username` 参数
- `db contact search` 返回的 `username` → `wx msg send_text` 的 `to_username` 参数
- `db room list` 返回的 `room_username` → `wx room detail/members` 的 `room_username` 参数

## 典型工作流

1. **按姓名查 ID**：`db contact search` → 获取 username → 用于后续发送消息
2. **查看聊天记录**：`db contact search` → 获取 username → `db msg list` 获取消息
3. **搜索历史消息**：`db msg search` → 按关键词搜索特定消息
4. **检查同步健康**：`db sync-status` → 确认数据同步正常

## 错误处理

- sync_url 未配置：提示需要在 config 中设置 sync_url
- guid 不存在：返回空结果或错误
- 数据库连接失败：检查 juhe-sync 服务是否运行
