# 🚀 Quick Setup: GitHub Actions Auto-Deploy

## Автоматический деплой на сервер 77.237.244.209

---

## ⚡ Быстрая настройка (5 минут):

### 1️⃣ Создайте SSH ключ

```bash
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_actions_todo
# Нажмите Enter 3 раза (без пароля)
```

### 2️⃣ Добавьте ключ на сервер

```bash
ssh-copy-id -i ~/.ssh/github_actions_todo.pub root@77.237.244.209
```

### 3️⃣ Добавьте приватный ключ в GitHub

```bash
# Скопируйте приватный ключ
cat ~/.ssh/github_actions_todo
```

Затем:
1. Откройте: https://github.com/olimdzhon/todo/settings/secrets/actions
2. **New repository secret**
3. Name: `SSH_PRIVATE_KEY`
4. Value: Вставьте скопированный ключ (весь, включая BEGIN/END)
5. **Add secret**

### 4️⃣ Готово! 🎉

Теперь при каждом push в `gh-pages` приложение автоматически обновится на сервере!

---

## 🔄 Как это работает:

```
Push в GitHub
    ↓
GitHub Actions запускается
    ↓
Синхронизирует файлы через rsync
    ↓
Подключается к серверу по SSH
    ↓
Останавливает контейнеры
    ↓
Пересобирает образы
    ↓
Запускает контейнеры
    ↓
Проверяет health check
    ↓
✅ Деплой завершен!
```

---

## 📊 Мониторинг деплоя:

**GitHub Actions:** https://github.com/olimdzhon/todo/actions

Там вы увидите:
- ✅ Успешные деплои (зелёная галочка)
- ❌ Ошибки (красный крестик)
- 🟡 В процессе (жёлтый кружок)

---

## 🧪 Тестирование:

### Проверьте что SSH работает:

```bash
ssh -i ~/.ssh/github_actions_todo root@77.237.244.209 "echo 'Connection OK'"
```

Должно вывести: `Connection OK`

### Запустите деплой вручную:

1. https://github.com/olimdzhon/todo/actions
2. **Deploy to Production Server (rsync)**
3. **Run workflow** → выберите `gh-pages` → **Run workflow**

---

## 📝 Обновление приложения:

### Автоматически:

```bash
cd /Users/olimdzonsadykov/Desktop/Todo

# Внесите изменения в код
nano frontend/index.html

# Закоммитьте и запушьте
git add .
git commit -m "Update app"
git push origin gh-pages

# GitHub Actions автоматически задеплоит за 2-3 минуты
```

### Вручную (старый способ):

```bash
./deploy-production.sh
```

---

## 🎯 Что деплоится:

- ✅ Frontend (HTML/CSS/JS)
- ✅ Backend (FastAPI)
- ✅ Docker конфигурация
- ✅ Nginx конфигурация
- ❌ .git, .github (исключены)
- ❌ node_modules (исключены)
- ❌ *.md файлы (исключены)

---

## 🔍 Проверка после деплоя:

```bash
# Health check
curl http://77.237.244.209/health

# API
curl http://77.237.244.209/api/

# Frontend
curl -I http://77.237.244.209/
```

Или откройте в браузере: http://77.237.244.209

---

## ⚠️ Troubleshooting:

### Ошибка: "Permission denied (publickey)"

```bash
# Проверьте что ключ добавлен
ssh root@77.237.244.209 "cat ~/.ssh/authorized_keys | grep github-actions"

# Если пусто, добавьте снова
ssh-copy-id -i ~/.ssh/github_actions_todo.pub root@77.237.244.209
```

### Workflow не запускается

Проверьте:
1. Секрет `SSH_PRIVATE_KEY` добавлен в GitHub
2. Пушите в ветку `gh-pages` (или `main`)
3. Workflow файл существует: `.github/workflows/deploy-rsync.yml`

### Деплой падает на сервере

```bash
# Подключитесь к серверу
ssh root@77.237.244.209

# Проверьте логи
cd /root/todo-app
docker-compose logs

# Перезапустите вручную
docker-compose down
docker-compose up -d --build
```

---

## 📚 Подробная документация:

- **Полная инструкция:** `GITHUB_ACTIONS_SSH_SETUP.md`
- **Production деплой:** `PRODUCTION_DEPLOY.md`
- **Статус деплоя:** `DEPLOYMENT_SUCCESS.md`

---

## 🎉 Готово!

После настройки вы можете просто пушить код в GitHub, и он автоматически появится на сервере!

**Ваше приложение:** http://77.237.244.209
**GitHub Actions:** https://github.com/olimdzhon/todo/actions

---

**Время настройки:** ~5 минут  
**Время деплоя:** ~2-3 минуты  
**Автоматизация:** 100% 🚀