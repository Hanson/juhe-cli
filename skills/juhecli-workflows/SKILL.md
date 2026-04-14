---
name: juhecli-workflows
description: 跨命令工作流编排 - 意图路由表和常见多步操作的工作流指南
---

# juhecli-workflows

跨命令工作流编排中枢。当用户用自然语言描述操作意图时，通过此 skill 确定需要调用哪些命令以及执行顺序。

## 协议判断规则

执行任何操作前，先确定使用企微还是个微命令：

| 判断条件 | 使用命令前缀 | 示例 |
|----------|-------------|------|
| 用户明确说"个微/微信/个人微信" | `wx` | `wx msg send_text` |
| 用户明确说"企微/企业微信" | 无前缀 | `msg send_text` |
| 不确定 | 询问用户 | — |

## 意图路由表

| 用户意图 | 步骤 | 涉及 skill |
|----------|------|-----------|
| 给某人发文本消息 | 1. 查联系人 → 2. 发消息 | juhecli-db + juhecli-msg 或 juhecli-wx-msg |
| 给某人发图片 | 1. 查联系人 → 2. 上传图片 → 3. 发图片 | juhecli-db + juhecli-wx-cloud + juhecli-wx-msg |
| 给某人发文件 | 1. 查联系人 → 2. 上传文件 → 3. 发文件 | juhecli-db + juhecli-wx-cloud + juhecli-wx-msg |
| 查看某人聊天记录 | 1. 查联系人 → 2. 查消息列表 | juhecli-db |
| 搜索历史消息 | 1. 按关键词搜索消息 | juhecli-db |
| 创建群并邀请人 | 1. 查所有成员 → 2. 创建群 | juhecli-db + juhecli-wx-room |
| 邀请人进群 | 1. 查群 → 2. 查人 → 3. 邀请 | juhecli-db + juhecli-wx-room |
| 把某人拉出群 | 1. 查群 → 2. 查人 → 3. 踢人 | juhecli-db + juhecli-wx-room |
| 给群发消息 | 1. 查群 → 2. 发消息 | juhecli-db + juhecli-wx-msg |
| 在群里@某人 | 1. 查群 → 2. 查被@的人 → 3. 发@消息 | juhecli-db + juhecli-wx-msg |
| 加某人为好友 | 1. 搜索联系人 → 2. 添加好友 | juhecli-wx-contact |
| 修改好友备注 | 1. 查联系人 → 2. 改备注 | juhecli-db + juhecli-wx-contact |
| 删除好友 | 1. 查联系人 → 2. 删除 | juhecli-db + juhecli-wx-contact |
| 查看朋友圈 | 1. 浏览时间线 → 2. 查看详情 | juhecli-wx-sns |
| 给朋友圈点赞 | 1. 浏览时间线 → 2. 点赞 | juhecli-wx-sns |
| 评论朋友圈 | 1. 浏览时间线 → 2. 评论 | juhecli-wx-sns |
| 发朋友圈 | 1.（可选）上传图片 → 2. 发布 | juhecli-wx-cloud + juhecli-wx-sns |
| 给联系人打标签 | 1. 查联系人 → 2. 查/建标签 → 3. 打标签 | juhecli-db + juhecli-wx-label |
| 搜索消息并转发 | 1. 搜索消息 → 2. 查目标人 → 3. 转发 | juhecli-db + juhecli-wx-msg |
| 拍一拍某人 | 1. 查群 → 2. 查被拍的人 → 3. 拍一拍 | juhecli-db + juhecli-wx-msg |
| 撤回消息 | 1. 用发送时返回的 msg_id → 2. 撤回 | juhecli-wx-msg |

## 详细工作流

### 工作流 1: 给某人发文本消息

**触发**：用户说"给张三发消息 hello"、"发消息给李四说xxx"

```
步骤 1: 查询联系人
  juhe-cli db contact search '{"keyword": "张三"}'
  → 从返回结果中提取 username 字段（如 "wxid_zhangsan"）

步骤 2: 判断协议并发送
  个微: juhe-cli wx msg send_text '{"to_username": "wxid_zhangsan", "content": "hello"}'
  企微: juhe-cli msg send_text '{"conversation_id": "zhangsan", "content": "hello"}'
```

**注意**：
- 个微的接收人参数名是 `to_username`，值是 wxid 格式
- 企微的接收人参数名是 `conversation_id`，值是 user_id 格式
- 如果搜索结果有多人，需要让用户确认选择哪个

### 工作流 2: 给某人发送图片

**触发**：用户说"给张三发图片"、"发送图片给李四"

```
步骤 1: 查询联系人
  juhe-cli db contact search '{"keyword": "张三"}'
  → 获取 to_username

步骤 2: 上传图片到 CDN
  juhe-cli wx cloud upload '{"file_type": 2, "url": "图片URL"}'
  → 获取 file_id, aes_key, file_size, file_md5

步骤 3: 发送图片
  juhe-cli wx msg send_image '{"to_username": "wxid_xxx", "file_id": "xxx", "aes_key": "xxx", "file_size": 12345, ...}'
```

### 工作流 3: 创建群并邀请成员

**触发**：用户说"创建一个群，拉张三和李四"、"建群把xxx加进来"

```
步骤 1: 逐个查询成员
  juhe-cli db contact search '{"keyword": "张三"}'
  → 获取 wxid_zhangsan
  juhe-cli db contact search '{"keyword": "李四"}'
  → 获取 wxid_lisi

步骤 2: 创建群
  juhe-cli wx room create '{"username_list": ["wxid_zhangsan", "wxid_lisi"]}'
  → 返回新群的 room_username
```

### 工作流 4: 搜索消息并转发

**触发**：用户说"搜索包含'合同'的消息转发给张三"

```
步骤 1: 搜索消息
  juhe-cli db msg search '{"keyword": "合同"}'
  → 获取消息列表，包含 msg_id、content、msg_type 等

步骤 2: 查询目标联系人
  juhe-cli db contact search '{"keyword": "张三"}'
  → 获取 to_username

步骤 3: 转发（使用引用回复方式）
  juhe-cli wx msg send_refer '{"to_username": "wxid_xxx", "content": "转发消息", "refer_msg": {...}}'
```

### 工作流 5: 查看某人最近的聊天记录

**触发**：用户说"看看张三的聊天记录"、"查看和张三的最近消息"

```
步骤 1: 查询联系人
  juhe-cli db contact search '{"keyword": "张三"}'
  → 获取 username

步骤 2: 获取消息列表
  juhe-cli db msg list '{"username": "wxid_xxx", "limit": 20}'
  → 返回最近 20 条消息
```

### 工作流 6: 好友管理

**触发**：用户说"加xxx为好友"、"删掉xxx"、"给xxx改备注"

```
加好友:
  1. juhe-cli wx contact search '{"username": "手机号/微信号", "search_scene": 1}'
  2. juhe-cli wx contact add_friend '{"username": "wxid_xxx", "verify_content": "你好"}'

改备注:
  1. juhe-cli db contact search '{"keyword": "张三"}'
  2. juhe-cli wx contact remark '{"username": "wxid_xxx", "remark": "新备注"}'

删好友:
  1. juhe-cli db contact search '{"keyword": "张三"}'
  2. juhe-cli wx contact del '{"username": "wxid_xxx"}'
```

### 工作流 7: 群操作

**触发**：用户说"邀请张三进xxx群"、"把李四踢出群"、"修改群名"

```
邀请入群:
  1. juhe-cli db room list '{"guid": "xxx"}' → 找到目标群的 room_username
     或 juhe-cli db contact search '{"keyword": "群名"}' → 搜索群
  2. juhe-cli db contact search '{"keyword": "张三"}' → 获取 username
  3. juhe-cli wx room invite '{"room_username": "xxx@chatroom", "username_list": ["wxid_xxx"]}'

踢人:
  1-2 同上
  3. juhe-cli wx room del_member '{"room_username": "xxx@chatroom", "username_list": ["wxid_xxx"]}'

改群名:
  1. juhe-cli db room list → 找到群
  2. juhe-cli wx room modify_name '{"room_username": "xxx@chatroom", "name": "新群名"}'
```

## 关键字段映射速查

### db contact search 返回 → 各命令输入

| 返回字段 | 用途 |
|----------|------|
| `username` | 个微所有命令的 to_username/username/room_username 参数 |
| `user_id` | 企微命令的 conversation_id 参数 |
| `nickname` | 显示名称，用于确认是否是目标联系人 |
| `remark` | 备注名，可用于搜索匹配 |

### wx cloud upload 返回 → 各发送命令输入

| 返回字段 | 用途 |
|----------|------|
| `file_id` | send_image/send_video/send_file 的 file_id |
| `aes_key` | send_image/send_video/send_file 的 aes_key |
| `file_size` | send_image/send_video/send_file 的 file_size |
| `file_md5` | send_image/send_video/send_file 的 file_md5 |
