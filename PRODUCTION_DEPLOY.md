# 🚀 Production Deployment Guide

## Сервер: 77.237.244.209

---

## ✅ Что готово:

- ✅ Docker Compose конфигурация
- ✅ Nginx reverse proxy
- ✅ PostgreSQL база данных
- ✅ FastAPI backend
- ✅ Static frontend
- ✅ Скрипт автоматического деплоя

---

## 📦 Структура деплоя:

```
Todo/
├── docker-compose.yml          # Оркестрация контейнеров
├── nginx-proxy.conf            # Nginx reverse proxy
├── nginx.conf                  # Nginx для frontend
├── .env.example                # Пример переменных окружения
├── deploy-production.sh        # Скрипт деплоя
├── backend/
│   ├── Dockerfile
│   ├── main.py
│   └── requirements.txt
├── frontend/
│   ├── index.html
│   ├── app.js                  # API URL: /api
│   └── styles.css
└── docker/
    └── init.sql                # Инициализация БД
```

---

## 🎯 Деплой за 3 шага:

### Шаг 1: Подготовка (локально)

```bash
cd /Users/olimdzonsadykov/Desktop/Todo

# Убедитесь что .env файл существует
cp .env.example .env

# Сделайте скрипт исполняемым
chmod +x deploy-production.sh
```

### Шаг 2: Деплой на сервер

```bash
./deploy-production.sh
```

Скрипт автоматически:
- Синхронизирует файлы через rsync
- Останавливает старые контейнеры
- Собирает новые образы
- Запускает все сервисы
- Проверяет статус

### Шаг 3: Проверка

Откройте в браузере:
- **Frontend**: http://77.237.244.209
- **Backend API**: http://77.237.244.209/api
- **API Docs**: http://77.237.244.209/api/docs

---

## 🐳 Архитектура Docker:

```
┌─────────────────────────────────────┐
│         Nginx Proxy (Port 80)       │
│                                     │
│  / → Frontend                       │
│  /api → Backend                     │
└─────────────────────────────────────┘
           ↓              ↓
    ┌──────────┐   ┌──────────┐
    │ Frontend │   │ Backend  │
    │  Nginx   │   │ FastAPI  │
    │  :80     │   │  :8000   │
    └──────────┘   └──────────┘
                        ↓
                   ┌──────────┐
                   │PostgreSQL│
                   │  :5432   │
                   └──────────┘
```

---

## 🔧 Ручной деплой (альтернатива):

### 1. Загрузка файлов на сервер

```bash
rsync -avz --progress \
    --exclude '.git' \
    --exclude 'node_modules' \
    --exclude '__pycache__' \
    . root@77.237.244.209:/root/todo-app/
```

### 2. Подключение к серверу

```bash
ssh root@77.237.244.209
cd /root/todo-app
```

### 3. Запуск контейнеров

```bash
# Остановить старые контейнеры
docker-compose down

# Собрать и запустить
docker-compose up -d --build

# Проверить статус
docker-compose ps

# Посмотреть логи
docker-compose logs -f
```

---

## 📊 Управление на сервере:

### Просмотр логов

```bash
# Все сервисы
docker-compose logs -f

# Конкретный сервис
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f postgres
```

### Перезапуск сервисов

```bash
# Все сервисы
docker-compose restart

# Конкретный сервис
docker-compose restart backend
```

### Остановка

```bash
docker-compose down
```

### Полная очистка (с удалением данных)

```bash
docker-compose down -v
docker system prune -af
```

---

## 🗄️ Работа с базой данных:

### Подключение к PostgreSQL

```bash
docker exec -it todo-postgres psql -U todouser -d todos_db
```

### Полезные SQL команды

```sql
-- Посмотреть все задачи
SELECT * FROM todos;

-- Количество задач
SELECT COUNT(*) FROM todos;

-- Очистить таблицу
TRUNCATE TABLE todos RESTART IDENTITY;

-- Выход
\q
```

### Бэкап базы данных

```bash
docker exec todo-postgres pg_dump -U todouser todos_db > backup.sql
```

### Восстановление из бэкапа

```bash
cat backup.sql | docker exec -i todo-postgres psql -U todouser -d todos_db
```

---

## 🔒 Безопасность:

### Изменить пароли в production

Отредактируйте `.env` на сервере:

```bash
ssh root@77.237.244.209
cd /root/todo-app
nano .env
```

Измените:
```env
POSTGRES_PASSWORD=ваш_сильный_пароль
DB_PASSWORD=ваш_сильный_пароль
```

Перезапустите:
```bash
docker-compose down -v
docker-compose up -d
```

### Настройка firewall (опционально)

```bash
# Разрешить только HTTP
ufw allow 80/tcp
ufw allow 22/tcp
ufw enable
```

---

## 🚨 Troubleshooting:

### Проблема: Контейнеры не запускаются

```bash
# Проверить логи
docker-compose logs

# Проверить статус
docker-compose ps

# Пересобрать образы
docker-compose build --no-cache
docker-compose up -d
```

### Проблема: Backend не подключается к БД

```bash
# Проверить что PostgreSQL запущен
docker-compose ps postgres

# Проверить логи PostgreSQL
docker-compose logs postgres

# Проверить переменные окружения
docker-compose config
```

### Проблема: Порт 80 занят

```bash
# Найти процесс на порту 80
sudo lsof -i :80

# Остановить nginx если установлен
sudo systemctl stop nginx
```

### Проблема: Нет места на диске

```bash
# Очистить неиспользуемые образы
docker system prune -a

# Проверить место
df -h
```

---

## 📈 Мониторинг:

### Проверка здоровья сервисов

```bash
# Health check endpoint
curl http://77.237.244.209/health

# Backend API
curl http://77.237.244.209/api/

# Получить задачи
curl http://77.237.244.209/api/todos
```

### Использование ресурсов

```bash
# Статистика контейнеров
docker stats

# Использование диска
docker system df
```

---

## 🔄 Обновление приложения:

### Быстрое обновление

```bash
# Локально
./deploy-production.sh
```

### Обновление только backend

```bash
ssh root@77.237.244.209
cd /root/todo-app
docker-compose up -d --build backend
```

### Обновление только frontend

```bash
# Локально синхронизировать файлы
rsync -avz frontend/ root@77.237.244.209:/root/todo-app/frontend/

# На сервере перезапустить
ssh root@77.237.244.209 "cd /root/todo-app && docker-compose restart frontend"
```

---

## 🌐 Настройка домена (опционально):

### 1. Добавить A-запись

В настройках вашего домена:
```
A    @    77.237.244.209
A    www  77.237.244.209
```

### 2. Установить SSL (Let's Encrypt)

```bash
ssh root@77.237.244.209

# Установить certbot
apt update
apt install certbot python3-certbot-nginx

# Получить сертификат
certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

---

## ✅ Checklist после деплоя:

- [ ] Приложение доступно по http://77.237.244.209
- [ ] API отвечает на http://77.237.244.209/api
- [ ] Можно создавать задачи
- [ ] Можно редактировать задачи
- [ ] Можно удалять задачи
- [ ] Фильтры работают
- [ ] База данных сохраняет данные после перезапуска
- [ ] Логи не показывают ошибок

---

## 📞 Полезные команды:

```bash
# Быстрый деплой
./deploy-production.sh

# Подключиться к серверу
ssh root@77.237.244.209

# Посмотреть логи
ssh root@77.237.244.209 "cd /root/todo-app && docker-compose logs -f"

# Перезапустить
ssh root@77.237.244.209 "cd /root/todo-app && docker-compose restart"

# Остановить
ssh root@77.237.244.209 "cd /root/todo-app && docker-compose down"
```

---

## 🎉 Готово!

Ваше приложение развернуто и работает на production сервере!

**URL**: http://77.237.244.209