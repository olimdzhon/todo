#!/bin/bash

# GitHub Pages Deploy Script for TODO App
# This script automates the deployment process

set -e

echo "🚀 Starting GitHub Pages deployment..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if git is initialized
if [ ! -d .git ]; then
    echo -e "${RED}❌ Git repository not initialized${NC}"
    exit 1
fi

# Check if on gh-pages branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "gh-pages" ]; then
    echo -e "${BLUE}📌 Switching to gh-pages branch...${NC}"
    git checkout gh-pages || {
        echo -e "${RED}❌ Failed to switch to gh-pages branch${NC}"
        exit 1
    }
fi

# Copy frontend files to root if they don't exist or are outdated
echo -e "${BLUE}📁 Copying frontend files to root...${NC}"
cp -f frontend/index.html index.html
cp -f frontend/app.js app.js
cp -f frontend/styles.css styles.css

# Add changes
echo -e "${BLUE}➕ Adding changes...${NC}"
git add index.html app.js styles.css GITHUB_PAGES_DEPLOY.md

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo -e "${GREEN}✅ No changes to commit${NC}"
else
    # Commit changes
    echo -e "${BLUE}💾 Committing changes...${NC}"
    git commit -m "Update GitHub Pages - $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Check if remote exists
if ! git remote | grep -q origin; then
    echo -e "${RED}❌ No remote 'origin' found${NC}"
    echo -e "${BLUE}Please add remote first:${NC}"
    echo "git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    exit 1
fi

# Push to GitHub
echo -e "${BLUE}🌐 Pushing to GitHub...${NC}"
git push origin gh-pages || {
    echo -e "${RED}❌ Failed to push to GitHub${NC}"
    echo -e "${BLUE}If this is your first push, try:${NC}"
    echo "git push -u origin gh-pages"
    exit 1
}

echo -e "${GREEN}✅ Successfully deployed to GitHub Pages!${NC}"
echo ""
echo -e "${GREEN}Your site will be available at:${NC}"
echo -e "${BLUE}https://YOUR_USERNAME.github.io/YOUR_REPO/${NC}"
echo ""
echo -e "${BLUE}Note: It may take 1-3 minutes for changes to appear${NC}"
echo -e "${BLUE}Check deployment status at: https://github.com/YOUR_USERNAME/YOUR_REPO/actions${NC}"
