#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SERVER="root@77.237.244.209"
REMOTE_DIR="/opt/todo-app"

echo -e "${GREEN}🚀 Начинаем деплой TODO приложения...${NC}"

# Проверка SSH соединения
echo -e "${YELLOW}Проверка соединения с сервером...${NC}"
ssh -o ConnectTimeout=5 $SERVER "echo 'Соединение установлено'" || {
    echo -e "${RED}❌ Не удалось подключиться к серверу${NC}"
    exit 1
}

# Создание директории на сервере
echo -e "${YELLOW}Создание директории на сервере...${NC}"
ssh $SERVER "mkdir -p $REMOTE_DIR"

# Копирование файлов
echo -e "${YELLOW}Копирование файлов на сервер...${NC}"
scp -r docker backend frontend $SERVER:$REMOTE_DIR/

# Установка Docker на сервере (если не установлен)
echo -e "${YELLOW}Проверка и установка Docker...${NC}"
ssh $SERVER << 'ENDSSH'
if ! command -v docker &> /dev/null; then
    echo "Установка Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Установка Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi
ENDSSH

# Запуск приложения
echo -e "${YELLOW}Запуск приложения...${NC}"
ssh $SERVER << ENDSSH
cd $REMOTE_DIR
docker-compose -f docker/docker-compose.yml down
docker-compose -f docker/docker-compose.yml up -d --build
echo "Ожидание запуска сервисов..."
sleep 10
docker-compose -f docker/docker-compose.yml ps
ENDSSH

echo -e "${GREEN}✅ Деплой завершён!${NC}"
echo -e "${GREEN}Приложение доступно по адресу: http://77.237.244.209${NC}"
echo -e "${GREEN}API доступен по адресу: http://77.237.244.209:8000${NC}"
