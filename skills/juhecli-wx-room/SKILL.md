---
name: juhecli-wx-room
description: 个微群组管理 - 群信息/成员/创建/加人/踢人/改名/公告/置顶/免打扰/转让等 21+ 命令
---

# juhecli-wx-room

微信（个微）群组的完整管理操作。

## 可用命令

### 群信息与成员

#### 获取群详情

```bash
juhe-cli wx room detail '{"room_username": "xxx@chatroom"}'
```

参数：
- `room_username` (string, 必填): 群 ID `[需查询]`

#### 获取群成员详情

```bash
juhe-cli wx room members '{"room_username": "xxx@chatroom", "version": 0}'
```

参数：
- `room_username` (string, 必填): 群 ID `[需查询]`
- `version` (int, 可选): 版本号，默认 0

#### 获取群二维码

```bash
juhe-cli wx room qrcode '{"room_username": "xxx@chatroom"}'
```

### 群操作

#### 创建群组

```bash
juhe-cli wx room create '{"username_list": ["wxid_a", "wxid_b"]}'
```

参数：
- `username_list` (array, 必填): 群成员 username 列表 `[需查询]`

#### 添加群成员（低于 40 人）

```bash
juhe-cli wx room add_member '{"room_username": "xxx@chatroom", "username_list": ["wxid_c"]}'
```

#### 邀请群成员

```bash
juhe-cli wx room invite '{"room_username": "xxx@chatroom", "username_list": ["wxid_d"]}'
```

#### 移除群成员

```bash
juhe-cli wx room del_member '{"room_username": "xxx@chatroom", "username_list": ["wxid_e"]}'
```

#### 退出群

```bash
juhe-cli wx room quit '{"room_username": "xxx@chatroom"}'
```

#### 转让群主

```bash
juhe-cli wx room transfer_owner '{"room_username": "xxx@chatroom", "username": "wxid_newowner"}'
```

参数：
- `room_username` (string, 必填): 群 ID `[需查询]`
- `username` (string, 必填): 新群主 username `[需查询]`

### 群设置

#### 修改群名称

```bash
juhe-cli wx room modify_name '{"room_username": "xxx@chatroom", "name": "新群名"}'
```

#### 设置群公告

```bash
juhe-cli wx room announcement '{"room_username": "xxx@chatroom", "announcement": "群公告内容"}'
```

#### 修改群显示昵称

```bash
juhe-cli wx room display_name '{"room_username": "xxx@chatroom", "display_name": "我的群昵称"}'
```

#### 显示/隐藏群成员昵称

```bash
juhe-cli wx room show_name '{"room_username": "xxx@chatroom", "status": 0}'
```

参数：`status`: 0=隐藏, 1=显示

#### 保存群到通讯录

```bash
juhe-cli wx room contact_flag '{"room_username": "xxx@chatroom", "status": 0}'
```

参数：`status`: 0=取消保存, 1=保存

#### 折叠/展开群

```bash
juhe-cli wx room fold '{"room_username": "xxx@chatroom", "status": 0}'
```

参数：`status`: 0=展开, 1=折叠

#### 消息免打扰

```bash
juhe-cli wx room disturb '{"room_username": "xxx@chatroom", "status": 0}'
```

参数：`status`: 0=关闭免打扰, 1=开启免打扰

#### 群置顶开关

```bash
juhe-cli wx room top_flag '{"room_username": "xxx@chatroom", "status": 1}'
```

参数：`status`: 0=取消置顶, 1=置顶

### 群置顶消息

#### 设置群置顶消息

```bash
juhe-cli wx room set_top_msg '{"room_username": "xxx@chatroom", "summary": "摘要", "msg_info": {"from_username": "wxid_xxx", "to_username": "xxx@chatroom", "chatroom_sender": "", "create_time": 0, "desc": "", "msg_id": "xxx", "msg_type": 1, "chatroom": "xxx@chatroom", "source": "", "content": "消息内容"}}'
```

#### 移除群置顶消息

```bash
juhe-cli wx room remove_top_msg '{"room_username": "xxx@chatroom", "msg_id": "xxx"}'
```

#### 获取群置顶消息列表

```bash
juhe-cli wx room top_msg_list '{"room_username": "xxx@chatroom"}'
```

### 添加群成员为好友

```bash
juhe-cli wx room add_friend '{"room_username": "xxx@chatroom", "username": "wxid_xxx", "verify_content": "你好"}'
```

参数：
- `room_username` (string, 必填): 群 ID `[需查询]`
- `username` (string, 必填): 群成员 username `[需查询]`
- `verify_content` (string, 可选): 验证消息 `[用户提供]`

## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| `room_username` | `[需查询]` | `db room list` 或 `db contact search` 搜索群名 |
| `username_list` | `[需查询]` | `db contact search` 逐个查询获取 |
| `name`/`announcement` | `[用户提供]` | 用户直接提供 |

## 典型工作流

1. **创建群**：`db contact search` 查询所有成员 → `wx room create`
2. **邀请入群**：`db room list` 找到群 → `db contact search` 找到人 → `wx room invite`
3. **管理群设置**：`db room list` 找到群 → `wx room modify_name`/`announcement`/`display_name` 等

## 错误处理

- room_username 不存在或已解散：返回错误
- 无权限操作（非群主/管理员）：返回权限不足
- add_member 超过 40 人限制：改用 invite 命令
- 创建群至少需要 2 人：username_list 至少 2 个成员
