---
name: juhecli-wx-app
description: 个微应用授权 - a8key/JS登录/OAuth授权/小程序短链操作
---

# juhecli-wx-app

微信（个微）的应用授权和小程序相关操作。

## 可用命令

### A8Key 授权

#### 获取 a8key

```bash
juhe-cli wx app get_a8key '{"req_url": "https://example.com", "scene": 1, "client_version": 0, "device_type": ""}'
```

参数：
- `req_url` (string, 必填): 请求 URL `[用户提供]`
- `scene` (int, 可选): 场景值，默认 1
- `client_version` (int, 可选): 客户端版本
- `device_type` (string, 可选): 设备类型

#### 公众号获取 a8key

```bash
juhe-cli wx app mp_get_a8key '{"req_url": "https://example.com", "scene": 1, "client_version": 0, "device_type": ""}'
```

### JS 操作

#### JS 登录

```bash
juhe-cli wx app js_login '{"appid": "wx1234567890"}'
```

参数：
- `appid` (string, 必填): 应用 appid `[用户提供]`

#### JS 操作微信数据

```bash
juhe-cli wx app js_operate_wxdata '{"appid": "wx123", "data": "{}", "grant_scope": ""}'
```

参数：
- `appid` (string, 必填): 应用 appid `[用户提供]`
- `data` (string, 必填): 操作数据 JSON `[用户提供]`
- `grant_scope` (string, 可选): 授权范围

#### JS 操作微信数据（VIP）

```bash
juhe-cli wx app js_operate_wxdata_vip '{"appid": "wx123", "data": "{}", "grant_scope": ""}'
```

### OAuth 授权

#### OAuth 授权

```bash
juhe-cli wx app oauth_authorize '{"url": "https://example.com", "username": "wxid_xxx", "scene": 7}'
```

参数：
- `url` (string, 必填): 授权 URL `[用户提供]`
- `username` (string, 可选): 用户 username
- `scene` (int, 可选): 场景值，默认 7

#### OAuth 确认授权

```bash
juhe-cli wx app oauth_authorize_confirm '{"url": "https://example.com", "scope": ["snsapi_userinfo"], "avatar_id": 0, "opt": 1}'
```

参数：
- `url` (string, 必填): 授权 URL `[用户提供]`
- `scope` (array, 可选): 授权范围列表
- `avatar_id` (int, 可选): 头像 ID
- `opt` (int, 可选): 操作类型，默认 1

### 扫码授权

#### 扫码授权

```bash
juhe-cli wx app qrconnect_authorize '{"url": "https://example.com", "username": "wxid_xxx", "scene": 7}'
```

#### 扫码确认授权

```bash
juhe-cli wx app qrconnect_authorize_confirm '{"url": "https://example.com", "scope": ["snsapi_login"], "avatar_id": 0, "opt": 1}'
```

### 小程序链接

#### 创建小程序短链

```bash
juhe-cli wx app create_wxa_short_link '{"appid": "wx123", "page_path": "pages/index", "page_title": "首页"}'
```

参数：
- `appid` (string, 必填): 小程序 appid `[用户提供]`
- `page_path` (string, 必填): 页面路径 `[用户提供]`
- `page_title` (string, 可选): 页面标题 `[用户提供]`

#### 解析小程序短链

```bash
juhe-cli wx app resolve_wxa_short_link '{"short_link": "https://wxaurl.cn/xxx"}'
```

#### 解析 App 短链

```bash
juhe-cli wx app resolve_wxa_app_short_link '{"short_link": "https://wxaurl.cn/xxx"}'
```

## 典型工作流

1. **网页授权**：`wx app get_a8key` → 获取授权凭证
2. **OAuth 流程**：`wx app oauth_authorize` → `wx app oauth_authorize_confirm`
3. **小程序链接**：`wx app create_wxa_short_link` 创建 → `wx app resolve_wxa_short_link` 解析

## 错误处理

- appid 无效：返回应用不存在
- URL 格式错误：返回参数错误
- 授权超时：重新发起授权
