#!/bin/bash
# gen-skills.sh - 从 CLI 自动生成 SKILL.md 文件
# 用法: bash scripts/gen-skills.sh [cli-binary]

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$ROOT_DIR/skills"

# 自动检测 CLI 二进制
if [ $# -ge 1 ]; then
    CLI="$1"
elif [ -f "$ROOT_DIR/juhe-cli.exe" ]; then
    CLI="$ROOT_DIR/juhe-cli.exe"
elif [ -f "$ROOT_DIR/juhe-cli" ]; then
    CLI="$ROOT_DIR/juhe-cli"
else
    echo "错误: 找不到 juhe-cli 二进制文件，请先 make cli"
    exit 1
fi

# 确保路径包含目录前缀（bash 不从当前目录查找可执行文件）
case "$CLI" in
    /*|./*) ;;  # 绝对路径或相对路径，无需修改
    *) CLI="./$CLI" ;;
esac

echo "使用 CLI: $CLI"
echo "输出目录: $SKILLS_DIR"
echo ""

# 获取子命令列表
get_subcommands() {
    local group="$1"
    # 解析 "Available Commands:" 之后、"Flags:" 之前的行
    "$CLI" "$group" --help 2>/dev/null | sed -n '/Available Commands/,/Flags:/p' | grep -v 'Available Commands' | grep -v 'Flags:' | grep -v 'help for' | grep -v 'completion' | grep -v '^$' | sed 's/^[[:space:]]*//' | cut -d' ' -f1
}

# 获取子命令的 Example 行
get_example() {
    local group="$1"
    local subcmd="$2"
    "$CLI" "$group" "$subcmd" --help 2>/dev/null | sed -n '/Examples:/,/^$/p' | grep 'juhe-cli' | head -1
}

# 获取子命令的 Short 描述
get_short() {
    local group="$1"
    local subcmd="$2"
    # 从父级 help 提取描述
    local line
    line=$("$CLI" "$group" --help 2>/dev/null | grep " $subcmd " || echo "")
    if [ -n "$line" ]; then
        echo "$line" | sed "s/^[[:space:]]*$subcmd[[:space:]]*//"
    fi
}

# 生成单个 SKILL.md
generate_skill() {
    local group="$1"
    local skill_name="$2"
    local description="$3"
    local skill_dir="$SKILLS_DIR/$skill_name"
    local skill_file="$skill_dir/SKILL.md"

    mkdir -p "$skill_dir"

    local subcmds
    subcmds=$(get_subcommands "$group")

    if [ -z "$subcmds" ]; then
        echo "  跳过 $group (无子命令)"
        return
    fi

    # 开始写文件
    cat > "$skill_file" << HEADER
---
name: $skill_name
description: $description
---

# $skill_name

$description。

## 可用命令

HEADER

    # 写每个子命令
    while IFS= read -r subcmd; do
        [ -z "$subcmd" ] && continue

        local example=""
        example=$(get_example "$group" "$subcmd")

        local short=""
        short=$(get_short "$group" "$subcmd")

        echo "### $subcmd" >> "$skill_file"
        echo "" >> "$skill_file"

        if [ -n "$example" ]; then
            echo '```bash' >> "$skill_file"
            echo "$example" >> "$skill_file"
            echo '```' >> "$skill_file"
        else
            echo '```bash' >> "$skill_file"
            echo "juhe-cli $group $subcmd '{\"guid\": \"xxx\"}'" >> "$skill_file"
            echo '```' >> "$skill_file"
        fi

        # 提取参数列表（非 guid 的参数）
        if [ -n "$example" ]; then
            local json_str=""
            json_str=$(echo "$example" | sed "s/.*'//" | sed "s/'.*//" || true)
            if [ -n "$json_str" ] && [ "$json_str" != "$example" ]; then
                local other_params=""
                other_params=$(echo "$json_str" | tr ',' '\n' | sed 's/[{}]//g' | sed 's/"//g' | sed 's/^[[:space:]]*//' | grep -v '^guid' | grep -v '^$' || true)
                if [ -n "$other_params" ]; then
                    echo "" >> "$skill_file"
                    echo "参数：" >> "$skill_file"
                    echo "$other_params" | while IFS= read -r param; do
                        local pname
                        pname=$(echo "$param" | cut -d: -f1 | tr -d '[:space:]')
                        if [ -n "$pname" ]; then
                            echo "- \`$pname\`" >> "$skill_file"
                        fi
                    done
                fi
            fi
        fi

        echo "" >> "$skill_file"

    done <<< "$subcmds"

    # 添加通用参数来源说明
    cat >> "$skill_file" << FOOTER

## 参数来源说明

| 参数 | 类型 | 获取方式 |
|------|------|----------|
| \`guid\` | \`[需查询]\` | \`device list\` 获取 |
| \`conversation_id\` | \`[需查询]\` | 私聊：\`db contact search\` 获取 user_id → 加 \`S:\` 前缀；群聊：\`db room list\` 获取 room_id → 加 \`R:\` 前缀 |
| \`content\` | \`[用户提供]\` | 用户直接提供 |

## 错误处理

所有命令在 API 返回错误时输出错误信息到 stderr。
FOOTER

    echo "  生成: $skill_file"
}

# 主流程
echo "生成 SKILL 文件..."
echo ""

# 企微命令组定义: group_name|skill_name|description
generate_skill "contact" "juhecli-contact" "企微联系人管理 - 增量同步、批量查询、搜索、更新"
generate_skill "msg"     "juhecli-msg"     "企微消息管理 - 发送文本/图片/文件/链接消息，撤回，确认已读"
generate_skill "room"    "juhecli-room"    "企微群组管理 - 获取群列表、群成员、创建群、修改群信息"
generate_skill "login"   "juhecli-login"   "企微登录管理 - 获取登录二维码、检查登录状态"
generate_skill "client"  "juhecli-client"  "企微客户端管理 - 升级、恢复、停止实例，设置通知地址、代理"
generate_skill "user"    "juhecli-user"    "企微用户管理 - 获取帐号信息、公司信息、登出"
generate_skill "sync"    "juhecli-sync"    "企微同步管理 - 同步消息、同步联系人数据"
generate_skill "cdn"     "juhecli-cdn"     "企微CDN文件管理 - 获取云存储文件、CDN信息"

echo ""
echo "完成。"
