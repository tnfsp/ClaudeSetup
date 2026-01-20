#!/bin/bash
# ClaudeSetup - Mac Install Script
# 用法: ./scripts/install.sh [--skip-apps] [--skip-env]

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 參數解析
SKIP_APPS=false
SKIP_ENV=false

for arg in "$@"; do
    case $arg in
        --skip-apps) SKIP_APPS=true ;;
        --skip-env) SKIP_ENV=true ;;
    esac
done

# 取得腳本所在目錄
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIGS_DIR="$REPO_ROOT/configs"
APPS_DIR="$REPO_ROOT/apps"
BACKUP_DIR="$REPO_ROOT/backups/$(date +%Y%m%d-%H%M%S)"

echo -e "${CYAN}========================================"
echo "  ClaudeSetup - Mac Installation"
echo -e "========================================${NC}"
echo ""

# ==========================================
# 1. 安裝 Homebrew (如果還沒安裝)
# ==========================================
echo -e "${YELLOW}Checking Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    # Check network connectivity first
    if ! curl -s --head --connect-timeout 5 https://raw.githubusercontent.com > /dev/null; then
        echo -e "${RED}  Error: Cannot reach GitHub. Please check your internet connection.${NC}"
        echo -e "${YELLOW}  You can install Homebrew manually: https://brew.sh${NC}"
        exit 1
    fi

    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        echo -e "${RED}  Error: Homebrew installation failed.${NC}"
        echo -e "${YELLOW}  Please try installing manually: https://brew.sh${NC}"
        exit 1
    fi

    # 加入 PATH (Apple Silicon)
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}Homebrew is already installed.${NC}"
fi
echo ""

# ==========================================
# 2. 安裝 APP (如果沒有跳過)
# ==========================================
if [ "$SKIP_APPS" = false ] && [ -f "$APPS_DIR/mac.txt" ]; then
    echo -e "${YELLOW}Installing applications from mac.txt...${NC}"

    # CLI 工具
    echo "Installing CLI tools..."
    brew install node python git gh 2>/dev/null || true

    # GUI 應用程式
    echo "Installing GUI applications..."
    while IFS= read -r line; do
        # 跳過註解和空行
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue

        app=$(echo "$line" | xargs)  # 去除空白
        if [ -n "$app" ]; then
            echo "  Installing: $app"
            brew install --cask "$app" 2>/dev/null || echo "    (skipped or already installed)"
        fi
    done < "$APPS_DIR/mac.txt"
    echo ""
fi

# ==========================================
# 3. Claude Code 設定
# ==========================================
echo -e "${YELLOW}Installing Claude Code settings...${NC}"

CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/skills"

# 備份現有設定
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    mkdir -p "$BACKUP_DIR"
    cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/"
    echo "  Backed up existing settings.json"
fi

# 複製設定檔（展開 ~/Project 為實際路徑）
if [ -f "$CONFIGS_DIR/claude/settings.json" ]; then
    # Replace ~/Project with actual $HOME/Project path
    sed "s|~/Project|$HOME/Project|g" "$CONFIGS_DIR/claude/settings.json" > "$CLAUDE_DIR/settings.json"
    echo -e "${GREEN}  Installed: ~/.claude/settings.json${NC}"
    echo "  (Paths updated for this machine)"
fi

# 複製 commands
if [ -d "$CONFIGS_DIR/claude/commands" ]; then
    cp -r "$CONFIGS_DIR/claude/commands/"* "$CLAUDE_DIR/commands/" 2>/dev/null || true
    echo -e "${GREEN}  Installed: ~/.claude/commands/${NC}"
fi

# 複製 skills
if [ -d "$CONFIGS_DIR/claude/skills" ]; then
    cp -r "$CONFIGS_DIR/claude/skills/"* "$CLAUDE_DIR/skills/" 2>/dev/null || true
    echo -e "${GREEN}  Installed: ~/.claude/skills/${NC}"
fi
echo ""

# ==========================================
# 4. 環境變數設定
# ==========================================
if [ "$SKIP_ENV" = false ]; then
    echo -e "${YELLOW}Setting up environment variables...${NC}"

    ENV_MASTER="$REPO_ROOT/.env.master"
    ZSHRC="$HOME/.zshrc"

    if [ -f "$ENV_MASTER" ]; then
        # 檢查是否已經加入
        if ! grep -q "source.*\.env\.master" "$ZSHRC" 2>/dev/null; then
            echo "" >> "$ZSHRC"
            echo "# ClaudeSetup - Load environment variables" >> "$ZSHRC"
            echo "# Note: Only specific variables are exported to avoid leaking sensitive data" >> "$ZSHRC"
            echo "if [ -f \"$ENV_MASTER\" ]; then" >> "$ZSHRC"
            echo "    export ANTHROPIC_API_KEY=\$(grep '^ANTHROPIC_API_KEY=' \"$ENV_MASTER\" | cut -d'=' -f2-)" >> "$ZSHRC"
            echo "    export GITHUB_TOKEN=\$(grep '^GITHUB_TOKEN=' \"$ENV_MASTER\" | cut -d'=' -f2-)" >> "$ZSHRC"
            echo "    export OPENAI_API_KEY=\$(grep '^OPENAI_API_KEY=' \"$ENV_MASTER\" | cut -d'=' -f2-)" >> "$ZSHRC"
            echo "    export SUPABASE_URL=\$(grep '^SUPABASE_URL=' \"$ENV_MASTER\" | cut -d'=' -f2-)" >> "$ZSHRC"
            echo "    export SUPABASE_KEY=\$(grep '^SUPABASE_KEY=' \"$ENV_MASTER\" | cut -d'=' -f2-)" >> "$ZSHRC"
            echo "fi" >> "$ZSHRC"
            echo -e "${GREEN}  Added .env.master to ~/.zshrc (explicit exports only)${NC}"
        else
            echo "  .env.master already configured in ~/.zshrc"
        fi
    else
        echo -e "${YELLOW}  .env.master not found. Create it and run again, or set up manually.${NC}"
    fi
    echo ""
fi

# ==========================================
# 5. Clone 必要專案 (nous MCP)
# ==========================================
echo -e "${YELLOW}Setting up required projects...${NC}"

PROJECT_DIR="$HOME/Project"
mkdir -p "$PROJECT_DIR"

# Clone nous (數位分身 MCP server)
if [ ! -d "$PROJECT_DIR/nous" ]; then
    echo "  Cloning nous (personal knowledge base MCP)..."
    if git clone https://github.com/tnfsp/nous.git "$PROJECT_DIR/nous" 2>/dev/null; then
        echo -e "${GREEN}  Cloned: ~/Project/nous${NC}"

        # Install nous dependencies
        echo "  Installing nous dependencies..."
        cd "$PROJECT_DIR/nous"
        if [ -f "requirements.txt" ]; then
            pip install -r requirements.txt 2>/dev/null || pip3 install -r requirements.txt 2>/dev/null || true
        fi
        if [ -f "pyproject.toml" ]; then
            pip install -e . 2>/dev/null || pip3 install -e . 2>/dev/null || true
        fi
        cd "$REPO_ROOT"
        echo -e "${GREEN}  nous installed${NC}"
    else
        echo -e "${YELLOW}  Could not clone nous (may need GitHub auth or repo doesn't exist)${NC}"
        echo "  You can clone manually: git clone https://github.com/tnfsp/nous.git ~/Project/nous"
    fi
else
    echo -e "${GREEN}  nous already exists at ~/Project/nous${NC}"
fi
echo ""

# ==========================================
# 6. 完成
# ==========================================
echo -e "${CYAN}========================================"
echo -e "${GREEN}  Installation Complete!"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo "  2. Setup MCP Servers:"
echo ""
echo -e "${CYAN}     # Heptabase MCP${NC}"
echo "     claude mcp add --transport http heptabase-mcp https://api.heptabase.com/mcp"
echo ""
echo -e "${CYAN}     # GitHub MCP${NC}"
echo "     claude mcp add -e GITHUB_TOKEN=\$GITHUB_TOKEN github -- npx -y @modelcontextprotocol/server-github"
echo ""
echo "  3. Verify: claude mcp list"
echo ""
echo -e "${YELLOW}Manual Downloads:${NC}"
echo "  - Typeless (AI 語音轉文字): https://www.typeless.com"
echo "  - Ivanti Secure Access (VPN): 從公司 IT 下載"
echo ""
