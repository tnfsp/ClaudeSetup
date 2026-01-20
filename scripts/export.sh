#!/bin/bash
# ClaudeSetup - Mac Export Script
# 用法: ./scripts/export.sh

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 取得腳本所在目錄
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIGS_DIR="$REPO_ROOT/configs"

echo -e "${CYAN}========================================"
echo "  ClaudeSetup - Mac Export"
echo -e "========================================${NC}"
echo ""

# ==========================================
# 1. Claude Code 設定
# ==========================================
CLAUDE_DIR="$HOME/.claude"

echo -e "${YELLOW}Exporting Claude Code settings...${NC}"

# settings.json
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    mkdir -p "$CONFIGS_DIR/claude"
    cp "$CLAUDE_DIR/settings.json" "$CONFIGS_DIR/claude/"
    echo -e "${GREEN}  Exported: settings.json${NC}"
else
    echo -e "${RED}  Not found: ~/.claude/settings.json${NC}"
fi

# commands
if [ -d "$CLAUDE_DIR/commands" ] && [ "$(ls -A $CLAUDE_DIR/commands 2>/dev/null)" ]; then
    mkdir -p "$CONFIGS_DIR/claude/commands"
    cp -r "$CLAUDE_DIR/commands/"* "$CONFIGS_DIR/claude/commands/"
    echo -e "${GREEN}  Exported: commands/ ($(ls -1 $CLAUDE_DIR/commands | wc -l | xargs) files)${NC}"
else
    echo "  No commands found."
fi

# skills
if [ -d "$CLAUDE_DIR/skills" ] && [ "$(ls -A $CLAUDE_DIR/skills 2>/dev/null)" ]; then
    mkdir -p "$CONFIGS_DIR/claude/skills"
    cp -r "$CLAUDE_DIR/skills/"* "$CONFIGS_DIR/claude/skills/"
    echo -e "${GREEN}  Exported: skills/ ($(ls -1 $CLAUDE_DIR/skills | wc -l | xargs) items)${NC}"
else
    echo "  No skills found."
fi
echo ""

# ==========================================
# 2. 匯出已安裝的 Homebrew APP
# ==========================================
echo -e "${YELLOW}Exporting installed Homebrew apps...${NC}"

mkdir -p "$REPO_ROOT/apps"

# Cask (GUI apps)
if command -v brew &> /dev/null; then
    brew list --cask > "$REPO_ROOT/apps/mac-installed-casks.txt" 2>/dev/null || true
    echo -e "${GREEN}  Exported: apps/mac-installed-casks.txt${NC}"

    # Formulae (CLI tools)
    brew list --formula > "$REPO_ROOT/apps/mac-installed-formulae.txt" 2>/dev/null || true
    echo -e "${GREEN}  Exported: apps/mac-installed-formulae.txt${NC}"
else
    echo -e "${RED}  Homebrew not installed, skipped.${NC}"
fi
echo ""

# ==========================================
# 3. 完成
# ==========================================
echo -e "${CYAN}========================================"
echo -e "${GREEN}  Export Complete!"
echo -e "${CYAN}========================================${NC}"
echo ""
echo "Exported files are in:"
echo "  - configs/claude/     (Claude Code settings)"
echo "  - apps/               (Installed app lists)"
echo ""
echo "Remember to commit and push:"
echo "  git add -A && git commit -m 'Update settings from Mac' && git push"
echo ""
