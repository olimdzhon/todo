#!/bin/bash

# Production Deployment Script for TODO App
# Server: 77.237.244.209

set -e

echo "🚀 Starting deployment to production server..."

# Configuration
SERVER="root@77.237.244.209"
REMOTE_DIR="/root/todo-app"
LOCAL_DIR="."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if rsync is installed
if ! command -v rsync &> /dev/null; then
    echo -e "${RED}❌ rsync is not installed. Please install it first.${NC}"
    exit 1
fi

# Step 1: Sync files to server
echo -e "${BLUE}📦 Syncing files to server...${NC}"
rsync -avz --progress \
    --exclude '.git' \
    --exclude '.github' \
    --exclude 'node_modules' \
    --exclude '__pycache__' \
    --exclude '*.pyc' \
    --exclude '.env.local' \
    --exclude '.DS_Store' \
    --exclude '*.md' \
    --exclude 'deploy_github_pages.sh' \
    ${LOCAL_DIR}/ ${SERVER}:${REMOTE_DIR}/

echo -e "${GREEN}✅ Files synced successfully${NC}"

# Step 2: Deploy on server
echo -e "${BLUE}🐳 Deploying with Docker Compose...${NC}"
ssh ${SERVER} << 'ENDSSH'
cd /root/todo-app

# Stop existing containers
echo "Stopping existing containers..."
docker-compose down 2>/dev/null || true

# Remove old images
echo "Cleaning up old images..."
docker system prune -f

# Build and start containers
echo "Building and starting containers..."
docker-compose up -d --build

# Wait for services to be healthy
echo "Waiting for services to start..."
sleep 10

# Check container status
echo "Container status:"
docker-compose ps

# Check logs
echo "Recent logs:"
docker-compose logs --tail=20

echo "✅ Deployment completed!"
echo ""
echo "🌐 Your application is now running at:"
echo "   Frontend: http://77.237.244.209"
echo "   Backend API: http://77.237.244.209/api"
echo "   API Docs: http://77.237.244.209/api/docs"
echo ""
echo "📊 To view logs: docker-compose logs -f"
echo "🔄 To restart: docker-compose restart"
echo "🛑 To stop: docker-compose down"
ENDSSH

echo -e "${GREEN}🎉 Deployment successful!${NC}"
echo ""
echo -e "${BLUE}Access your application:${NC}"
echo "  Frontend: http://77.237.244.209"
echo "  Backend API: http://77.237.244.209/api"
echo "  API Docs: http://77.237.244.209/api/docs"
