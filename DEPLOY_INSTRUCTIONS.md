# 🚀 Инструкция по деплою TODO приложения

## Что было создано:

### Backend (FastAPI)
- `backend/main.py` - REST API с endpoints для CRUD операций
- `backend/Dockerfile` - Docker образ для бэкенда
- `backend/requirements.txt` - Python зависимости

### Frontend
- `frontend/index.html` - HTML интерфейс
- `frontend/styles.css` - Стили приложения
- `frontend/app.js` - JavaScript логика

### Docker
- `docker/docker-compose.yml` - Оркестрация контейнеров
- `docker/init.sql` - Инициализация БД с таблицей todos

### Конфигурация
- `.env` - Переменные окружения
- `deploy_to_server.sh` - Скрипт автоматического деплоя

## 📋 Endpoints API:

- `GET /todos` - Получить все задачи
- `POST /todos` - Создать задачу
- `PUT /todos/{id}` - Обновить задачу
- `DELETE /todos/{id}` - Удалить задачу

## 🔧 Деплой на сервер:

### Вариант 1: Автоматический деплой
```bash
./deploy_to_server.sh
```

### Вариант 2: Ручной деплой
```bash
# 1. Создать директорию на сервере
ssh root@77.237.244.209 "mkdir -p /opt/todo-app"

# 2. Скопировать файлы
scp -r docker backend frontend .env root@77.237.244.209:/opt/todo-app/

# 3. Подключиться к серверу
ssh root@77.237.244.209

# 4. Перейти в директорию
cd /opt/todo-app/docker

# 5. Запустить приложение
docker-compose up -d --build

# 6. Проверить статус
docker-compose ps
docker-compose logs -f
```

## 🌐 Доступ к приложению:

После деплоя приложение будет доступно по адресам:
- **Frontend**: http://77.237.244.209
- **Backend API**: http://77.237.244.209:8000
- **API Docs**: http://77.237.244.209:8000/docs

## 🔍 Проверка работы:

```bash
# Проверить статус контейнеров
ssh root@77.237.244.209 "cd /opt/todo-app/docker && docker-compose ps"

# Посмотреть логи
ssh root@77.237.244.209 "cd /opt/todo-app/docker && docker-compose logs -f backend"

# Проверить API
curl http://77.237.244.209:8000/todos
```

## 🛠 Управление:

```bash
# Остановить
ssh root@77.237.244.209 "cd /opt/todo-app/docker && docker-compose down"

# Перезапустить
ssh root@77.237.244.209 "cd /opt/todo-app/docker && docker-compose restart"

# Пересобрать и запустить
ssh root@77.237.244.209 "cd /opt/todo-app/docker && docker-compose up -d --build"

# Удалить все (включая данные)
ssh root@77.237.244.209 "cd /opt/todo-app/docker && docker-compose down -v"
```

## 📊 База данных:

Подключение к PostgreSQL:
```bash
ssh root@77.237.244.209
docker exec -it todo-postgres psql -U todouser -d todos_db

# SQL команды:
\dt                    # Показать таблицы
SELECT * FROM todos;   # Показать все задачи
\q                     # Выход
```

## ⚙️ Настройки:

Измените `.env` файл для настройки:
- Пароли БД
- Порты
- CORS origins

## 🐛 Troubleshooting:

### Порты заняты
Измените порты в `docker/docker-compose.yml`

### Проблемы с подключением к БД
Проверьте, что PostgreSQL запущен:
```bash
docker-compose logs postgres
```

### API не отвечает
Проверьте логи бэкенда:
```bash
docker-compose logs backend
```
