#!/bin/bash

# Quick update script for TODO app

echo "🔄 Updating TODO app on server..."

SERVER="root@77.237.244.209"
REMOTE_DIR="/opt/todo-app"

# Copy updated files
echo "📦 Copying files..."
scp -r backend frontend docker $SERVER:$REMOTE_DIR/

# Restart services
echo "🔄 Restarting services..."
ssh $SERVER << 'ENDSSH'
cd /opt/todo-app/docker
docker-compose restart backend frontend
echo "✅ Services restarted!"
docker-compose ps
ENDSSH

echo ""
echo "✅ Update complete!"
echo "Frontend: http://77.237.244.209:3000"
echo "Backend: http://77.237.244.209:8000"
