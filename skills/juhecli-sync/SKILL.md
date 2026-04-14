---
name: juhecli-sync
description: 企微同步管理 - 同步消息、同步联系人数据，通过 sync_key 增量拉取
---

# juhecli-sync

企微数据同步管理，支持通过 sync_key 增量同步消息和联系人数据。

## 可用命令

### 同步消息

```bash
juhe-cli sync msg '{"limit":100,"sync_key":""}'
```

说明：通过 sync_key 增量同步消息。sync_key 不要传 0 或不传，可先发一条消息根据新消息 seq 减去一定数字来获取。

参数：
- `limit` (int, 可选): 同步消息数量，默认 100
- `sync_key` (string, 必填): 同步序列号 `[来自上次同步返回值]` 或 `[需查询]`

**注意**：首次同步时 sync_key 可以从 `db sync-status` 获取 seq 字段。

### 同步联系人数据

```bash
juhe-cli sync multi_data '{"business_id":1,"limit":10,"seq":""}'
```

说明：同步联系人等多维数据。

参数：
- `business_id` (int, 必填): 业务类型 ID `[用户提供]`，1 表示联系人
- `limit` (int, 可选): 同步数量，默认 10
- `seq` (string, 可选): 序列号，空字符串表示从头同步 `[来自上次同步返回值]`

## 参数来源说明

| 参数 | 类型 | 来源 |
|------|------|------|
| `sync_key` | `[来自上次同步返回值]` | 首次从 `db sync-status` 获取 seq，后续从 sync msg 返回值获取 |
| `business_id` | `[用户提供]` | 业务类型 ID，1=联系人 |
| `limit` | `[可选]` | 每次同步数量 |
| `seq` | `[来自上次同步返回值]` | 空字符串=从头同步，后续从 multi_data 返回值获取 |

## 典型工作流

1. **首次同步消息**：`db sync-status` 获取当前 seq → `sync msg` 传入 sync_key → 保存返回的新 sync_key
2. **持续同步消息**：使用上次 `sync msg` 返回的 sync_key → `sync msg` 增量拉取新消息
3. **同步联系人**：`sync multi_data` 传入 business_id=1 → 获取联系人增量数据
4. **完整初始化**：`client restore` 启动实例 → `sync multi_data` 同步联系人 → `sync msg` 同步消息

## 错误处理

- sync_key 为空或 0：sync msg 会报错，需从 `db sync-status` 获取有效 seq
- 同步频率过高：API 可能有频率限制，适当降低同步频率
- 实例未启动：需先 `client restore` 启动实例
- seq 过旧：返回数据量可能很大，建议适当设置 limit
