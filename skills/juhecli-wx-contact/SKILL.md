---
name: juhecli-wx-contact
description: 个微联系人管理 - 同步/置顶/详情/搜索/加好友/验证/备注/删除
---

# juhecli-wx-contact

管理微信（个微）的联系人操作。

## 可用命令

### 同步联系人

```bash
juhe-cli wx contact init '{"contact_seq": 0, "room_seq": 0}'
```

参数：
- `contact_seq` (int, 可选): 联系人序列号，0 表示全量同步
- `room_seq` (int, 可选): 群序列号，0 表示全量同步

### 置顶聊天

```bash
juhe-cli wx contact top '{"username": "wxid_xxx", "status": 1}'
```

参数：
- `username` (string, 必填): 联系人 username `[需查询]`
- `status` (int, 必填): 0=取消置顶, 1=置顶

### 获取联系人详情

```bash
juhe-cli wx contact get '{"username_list": ["wxid_xxx"], "room_username": ""}'
```

参数：
- `username_list` (array, 必填): username 列表 `[需查询]`
- `room_username` (string, 可选): 群 username，仅在查询群成员详情时使用

### 批量获取简要信息

```bash
juhe-cli wx contact brief '{"username_list": ["wxid_a", "wxid_b"]}'
```

参数：
- `username_list` (array, 必填): username 列表 `[需查询]`

### 搜索联系人

```bash
juhe-cli wx contact search '{"username": "13800138000", "from_scene": 0, "search_scene": 1}'
```

参数：
- `username` (string, 必填): 搜索内容（手机号/微信号/QQ号）`[用户提供]`
- `from_scene` (int, 可选): 来源场景，默认 0
- `search_scene` (int, 必填): 搜索类型：1=手机号, 2=微信号, 3=QQ号

### 添加好友

```bash
juhe-cli wx contact add_friend '{"username": "wxid_xxx", "verify_content": "你好", "scene": 3, "ticket": ""}'
```

参数：
- `username` (string, 必填): 目标 username `[需查询]`
- `verify_content` (string, 可选): 验证消息内容
- `scene` (int, 可选): 添加来源场景，默认 3
- `ticket` (string, 可选): 验证票据

### 好友状态验证

```bash
juhe-cli wx contact verify '{"username": "wxid_xxx", "ticket": "", "scene": 6, "opcode": 1}'
```

参数：
- `username` (string, 必填): 目标 username `[需查询]`
- `opcode` (int, 必填): 1=检查好友状态, 2=单向加好友, 3=同意好友申请
- `ticket` (string, 可选): 验证票据
- `scene` (int, 可选): 场景值，默认 6

### 修改好友备注

```bash
juhe-cli wx contact remark '{"username": "wxid_xxx", "remark": "新备注"}'
```

参数：
- `username` (string, 必填): 联系人 username `[需查询]`
- `remark` (string, 必填): 新备注名 `[用户提供]`

### 删除好友

```bash
juhe-cli wx contact del '{"username": "wxid_xxx"}'
```

参数：
- `username` (string, 必填): 联系人 username `[需查询]`

## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `username` | `[需查询]` | `db contact search '{"keyword": "姓名"}'` |
| `remark` | `[用户提供]` | 用户直接提供 |
| `verify_content` | `[用户提供]` | 用户直接提供 |
| `search_scene` | `[用户提供]` | 用户说明搜索方式（手机号/微信号/QQ号） |

## 典型工作流

1. **按姓名查 ID**：`db contact search '{"keyword": "张三"}'` → 获取 username
2. **查看详情**：`wx contact get '{"username_list": ["wxid_xxx"]}'`
3. **加好友**：`wx contact add_friend '{"username": "wxid_xxx", "verify_content": "你好"}'`
4. **修改备注**：`wx contact remark '{"username": "wxid_xxx", "remark": "客户-张三"}'`

## 错误处理

- username 不存在：返回用户不存在错误
- 已是好友：添加好友时返回已是好友提示
- 好友申请已发送：避免重复发送
