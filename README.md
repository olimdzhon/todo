# TODO Application

Полноценное TODO приложение с PostgreSQL, FastAPI и React фронтендом.

## Структура проекта

```
Todo/
├── backend/          # FastAPI приложение
├── frontend/         # React фронтенд
├── docker/           # Docker конфигурации
└── deploy.sh         # Скрипт деплоя
```

## Требования

- Docker и Docker Compose
- Python 3.9+
- Node.js 16+ (для локальной разработки)

## Быстрый старт

### 1. Деплой на сервер

```bash
# Скопируйте файлы на сервер
scp -r . root@77.237.244.209:/root/todo-app

# Подключитесь к серверу
ssh root@77.237.244.209

# Перейдите в директорию
cd /root/todo-app

# Запустите деплой
chmod +x deploy.sh
./deploy.sh
```

### 2. Локальная разработка

#### Backend
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

#### Frontend
```bash
cd frontend
npm install
npm start
```

## API Endpoints

- `GET /todos` - Получить все задачи
- `POST /todos` - Создать новую задачу
- `PUT /todos/{id}` - Обновить задачу
- `DELETE /todos/{id}` - Удалить задачу
- `GET /health` - Проверка здоровья API

## Переменные окружения

Создайте файл `.env` в корне проекта:

```env
POSTGRES_USER=todouser
POSTGRES_PASSWORD=todopass123
POSTGRES_DB=todos_db
DATABASE_URL=postgresql://todouser:todopass123@postgres:5432/todos_db
```

## Доступ к приложению

После деплоя:
- Frontend: http://77.237.244.209:3000
- Backend API: http://77.237.244.209:8000
- API Docs: http://77.237.244.209:8000/docs

## Управление

```bash
# Остановить все сервисы
docker-compose down

# Перезапустить
docker-compose restart

# Посмотреть логи
docker-compose logs -f

# Посмотреть логи конкретного сервиса
docker-compose logs -f backend
```

## База данных

Подключение к PostgreSQL:
```bash
docker exec -it todo-postgres psql -U todouser -d todos_db
```

## Troubleshooting

### Порты заняты
Если порты 3000, 8000 или 5432 заняты, измените их в `docker-compose.yml`

### Проблемы с правами
```bash
chmod +x deploy.sh
chown -R $USER:$USER .
```

### Пересоздать базу данных
```bash
docker-compose down -v
docker-compose up -d
```
