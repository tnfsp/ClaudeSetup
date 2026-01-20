#!/bin/bash
# ClaudeSetup - Clone All Projects
# 用法: ./scripts/clone-all.sh

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_DIR="$HOME/Project"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo -e "${CYAN}========================================${NC}"
echo "  Cloning All Projects"
echo -e "${CYAN}========================================${NC}"
echo ""

# 檢查 GitHub 認證
if ! gh auth status &> /dev/null; then
    echo -e "${RED}GitHub CLI not authenticated!${NC}"
    echo "Please run: gh auth login"
    exit 1
fi

clone_repo() {
    local repo=$1
    local name=$(basename "$repo" .git)

    if [ -d "$PROJECT_DIR/$name" ]; then
        echo -e "${GREEN}  ✓ $name (already exists)${NC}"
    else
        if git clone "$repo" 2>/dev/null; then
            echo -e "${GREEN}  ✓ $name${NC}"
        else
            echo -e "${RED}  ✗ $name (failed)${NC}"
        fi
    fi
}

# ==========================================
# 研究專案 (tnfsp-research)
# ==========================================
echo -e "${YELLOW}Research Projects (tnfsp-research)${NC}"
clone_repo "https://github.com/tnfsp-research/research-technical-transeptal-lvad-centrimag.git"
clone_repo "https://github.com/tnfsp-research/research-bentall-pseudoaneurysm.git"
clone_repo "https://github.com/tnfsp-research/research-ecpr-pci.git"
clone_repo "https://github.com/tnfsp-research/thesis-supervisor-phd.git"
clone_repo "https://github.com/tnfsp-research/research-tavi-explant.git"
clone_repo "https://github.com/tnfsp-research/research-tavi-dapt-vs-noac.git"
clone_repo "https://github.com/tnfsp-research/research-case-lv-pseudoaneurysm.git"
clone_repo "https://github.com/tnfsp-research/research-case-mac.git"
clone_repo "https://github.com/tnfsp-research/research-case-venovo.git"
clone_repo "https://github.com/tnfsp-research/research-case-lad-fistula-pa.git"
clone_repo "https://github.com/tnfsp-research/research-metaanalysis-refractory.git"
echo ""

# ==========================================
# 核心工具
# ==========================================
echo -e "${YELLOW}Core Tools${NC}"
clone_repo "https://github.com/tnfsp/ClaudeSetup.git"
clone_repo "https://github.com/tnfsp/nous.git"
clone_repo "https://github.com/tnfsp/tool-optimize-dev-workflow.git"
echo ""

# ==========================================
# 日常工具
# ==========================================
echo -e "${YELLOW}Daily Tools${NC}"
clone_repo "https://github.com/tnfsp/telegram-bot.git"
clone_repo "https://github.com/tnfsp/readwise_bot.git"
clone_repo "https://github.com/tnfsp/BroadcastChannel.git"
clone_repo "https://github.com/tnfsp/screenshot-to-knowledge.git"
clone_repo "https://github.com/tnfsp/heptabase-tools.git"
clone_repo "https://github.com/tnfsp/project-github-sync.git"
echo ""

# ==========================================
# 網站/品牌
# ==========================================
echo -e "${YELLOW}Website & Brand${NC}"
clone_repo "https://github.com/tnfsp/new_website.git"
clone_repo "https://github.com/tnfsp/brand.git"
echo ""

# ==========================================
# 學習
# ==========================================
echo -e "${YELLOW}Learning${NC}"
clone_repo "https://github.com/tnfsp/coding-learning.git"
clone_repo "https://github.com/tnfsp/learning-dj.git"
clone_repo "https://github.com/tnfsp/cardiac-surgery-learning.git"
echo ""

# ==========================================
# 醫療應用
# ==========================================
echo -e "${YELLOW}Medical Applications${NC}"
clone_repo "https://github.com/tnfsp/cardiac-echo.git"
clone_repo "https://github.com/tnfsp/claude-icu-simulator.git"
clone_repo "https://github.com/tnfsp/ICU-stimulator.git"
clone_repo "https://github.com/tnfsp/chatgpt-export-viewer.git"
clone_repo "https://github.com/tnfsp/presentation_HM3.git"
clone_repo "https://github.com/tnfsp/wealth-coach.git"
echo ""

# ==========================================
# 想法/草稿
# ==========================================
echo -e "${YELLOW}Ideas & Archive${NC}"
clone_repo "https://github.com/tnfsp/idea-archive.git"
clone_repo "https://github.com/tnfsp/database-archive.git"
clone_repo "https://github.com/tnfsp/annual-op-statistics.git"
echo ""

# ==========================================
# 完成
# ==========================================
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  All projects cloned!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo "Note: Some projects may need additional setup:"
echo "  - npm install (Node.js projects)"
echo "  - pip install -r requirements.txt (Python projects)"
echo ""
