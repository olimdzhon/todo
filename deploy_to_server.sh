#!/bin/bash

SERVER="root@77.237.244.209"
REMOTE_DIR="/opt/todo-app"

echo "🚀 Deploying TODO App to server..."

# Copy files to server
echo "📦 Copying files..."
scp -r docker backend frontend .env $SERVER:$REMOTE_DIR/

# Execute deployment on server
echo "🔧 Setting up on server..."
ssh $SERVER << 'ENDSSH'
cd /opt/todo-app

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Stop existing containers
echo "Stopping existing containers..."
cd docker
docker-compose down 2>/dev/null || true

# Build and start services
echo "Starting services..."
docker-compose up -d --build

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 15

# Show status
docker-compose ps

echo ""
echo "✅ Deployment complete!"
echo "Frontend: http://77.237.244.209"
echo "Backend API: http://77.237.244.209:8000"
echo "API Docs: http://77.237.244.209:8000/docs"
ENDSSH

echo ""
echo "✅ Done! Your TODO app is now running on the server."
