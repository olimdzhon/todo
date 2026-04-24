# GitHub Actions SSH Setup Guide

## 🔐 Настройка автоматического деплоя через SSH

Эта инструкция поможет настроить автоматический деплой на ваш сервер через GitHub Actions.

---

## 📋 Что нужно:

- ✅ GitHub репозиторий: https://github.com/olimdzhon/todo
- ✅ Сервер: 77.237.244.209
- ✅ SSH доступ к серверу
- ✅ Docker и Docker Compose на сервере

---

## 🔑 Шаг 1: Создание SSH ключа

### На вашем компьютере:

```bash
# Создайте новый SSH ключ специально для GitHub Actions
ssh-keygen -t ed25519 -C "github-actions@todo-app" -f ~/.ssh/github_actions_todo

# Это создаст два файла:
# ~/.ssh/github_actions_todo (приватный ключ)
# ~/.ssh/github_actions_todo.pub (публичный ключ)
```

**Важно:** Не используйте пароль для этого ключа (просто нажмите Enter)

---

## 🔑 Шаг 2: Добавление публичного ключа на сервер

### Скопируйте публичный ключ на сервер:

```bash
# Вариант 1: Автоматически
ssh-copy-id -i ~/.ssh/github_actions_todo.pub root@77.237.244.209

# Вариант 2: Вручную
cat ~/.ssh/github_actions_todo.pub
# Скопируйте вывод
```

### Если копируете вручную:

```bash
# Подключитесь к серверу
ssh root@77.237.244.209

# Добавьте ключ в authorized_keys
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
# Вставьте скопированный публичный ключ на новую строку
# Сохраните: Ctrl+O, Enter, Ctrl+X

# Установите правильные права
chmod 600 ~/.ssh/authorized_keys
```

### Проверьте подключение:

```bash
# На вашем компьютере
ssh -i ~/.ssh/github_actions_todo root@77.237.244.209 "echo 'SSH connection successful!'"
```

Если видите "SSH connection successful!" - всё работает!

---

## 🔐 Шаг 3: Добавление приватного ключа в GitHub Secrets

### 1. Скопируйте приватный ключ:

```bash
cat ~/.ssh/github_actions_todo
```

Скопируйте **весь** вывод, включая строки:
```
-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----
```

### 2. Добавьте в GitHub Secrets:

1. Откройте: https://github.com/olimdzhon/todo/settings/secrets/actions
2. Нажмите **New repository secret**
3. Name: `SSH_PRIVATE_KEY`
4. Value: Вставьте скопированный приватный ключ
5. Нажмите **Add secret**

---

## 🚀 Шаг 4: Настройка Git на сервере (опционально)

Если хотите использовать `git pull` в workflow:

```bash
ssh root@77.237.244.209

cd /root/todo-app

# Инициализируйте git если ещё не сделано
git init
git remote add origin https://github.com/olimdzhon/todo.git
git fetch
git checkout main  # или gh-pages

# Настройте git
git config --global user.email "github-actions@todo-app"
git config --global user.name "GitHub Actions"
```

---

## 🔄 Шаг 5: Создание ветки main

Сейчас у вас есть только ветка `gh-pages`. Создайте `main`:

```bash
cd /Users/olimdzonsadykov/Desktop/Todo

# Создайте ветку main из gh-pages
git checkout -b main

# Запушьте в GitHub
git push -u origin main
```

Или используйте `gh-pages` в workflow (уже настроено в `deploy-rsync.yml`).

---

## ✅ Шаг 6: Активация workflow

### Вариант 1: Автоматический деплой при push

Workflow уже настроен! Просто запушьте изменения:

```bash
git add .
git commit -m "Setup GitHub Actions auto-deploy"
git push origin main  # или gh-pages
```

### Вариант 2: Ручной запуск

1. Откройте: https://github.com/olimdzhon/todo/actions
2. Выберите "Deploy to Production Server (rsync)"
3. Нажмите **Run workflow**
4. Выберите ветку
5. Нажмите **Run workflow**

---

## 📊 Шаг 7: Проверка деплоя

### Мониторинг в GitHub:

1. Откройте: https://github.com/olimdzhon/todo/actions
2. Кликните на последний workflow run
3. Смотрите логи в реальном времени

### Проверка на сервере:

```bash
ssh root@77.237.244.209 "cd /root/todo-app && docker-compose ps"
```

### Проверка приложения:

- Frontend: http://77.237.244.209
- API: http://77.237.244.209/api
- Health: http://77.237.244.209/health

---

## 🔧 Доступные workflows:

### 1. `deploy.yml` - Основной деплой
- Триггер: push в `main`
- Использует git pull на сервере
- Требует настроенный git на сервере

### 2. `deploy-rsync.yml` - Деплой через rsync (рекомендуется)
- Триггер: push в `main` или `gh-pages`
- Синхронизирует файлы через rsync
- Не требует git на сервере
- Более надёжный

### 3. `deploy-from-main.yml` - GitHub Pages
- Триггер: push в `main`
- Деплоит на GitHub Pages
- Для статической версии

---

## 🎯 Какой workflow использовать?

### Для production сервера (77.237.244.209):
Используйте **`deploy-rsync.yml`** - он более надёжный

### Для GitHub Pages:
Используйте **`deploy-from-main.yml`**

### Чтобы отключить ненужные workflows:

```bash
cd /Users/olimdzonsadykov/Desktop/Todo/.github/workflows

# Переименуйте ненужные
mv deploy.yml deploy.yml.disabled
mv deploy-from-main.yml deploy-from-main.yml.disabled

# Оставьте только deploy-rsync.yml активным
```

---

## 🔍 Troubleshooting:

### Ошибка: "Permission denied (publickey)"

**Решение:**
```bash
# Проверьте что ключ добавлен на сервер
ssh root@77.237.244.209 "cat ~/.ssh/authorized_keys"

# Проверьте права
ssh root@77.237.244.209 "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
```

### Ошибка: "Host key verification failed"

**Решение:** Workflow автоматически добавляет сервер в known_hosts

### Ошибка: "docker-compose: command not found"

**Решение:**
```bash
ssh root@77.237.244.209

# Установите docker-compose
apt update
apt install docker-compose-plugin
```

### Workflow не запускается

**Проверьте:**
1. Секрет `SSH_PRIVATE_KEY` добавлен в GitHub
2. Ветка в workflow совпадает с вашей веткой
3. Workflow файл имеет расширение `.yml`

---

## 🔐 Безопасность:

### ✅ Хорошие практики:

- ✅ Используйте отдельный SSH ключ для GitHub Actions
- ✅ Не используйте пароль для ключа
- ✅ Храните приватный ключ только в GitHub Secrets
- ✅ Регулярно ротируйте ключи

### ⚠️ Важно:

- **Никогда** не коммитьте приватный ключ в репозиторий
- **Никогда** не публикуйте приватный ключ
- Используйте GitHub Secrets для всех чувствительных данных

---

## 📝 Пример полного процесса:

```bash
# 1. Создайте SSH ключ
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_actions_todo

# 2. Добавьте на сервер
ssh-copy-id -i ~/.ssh/github_actions_todo.pub root@77.237.244.209

# 3. Скопируйте приватный ключ
cat ~/.ssh/github_actions_todo
# Добавьте в GitHub Secrets как SSH_PRIVATE_KEY

# 4. Создайте ветку main
cd /Users/olimdzonsadykov/Desktop/Todo
git checkout -b main
git push -u origin main

# 5. Запушьте workflow
git add .github/workflows/
git commit -m "Add auto-deploy workflow"
git push origin main

# 6. Проверьте деплой
# https://github.com/olimdzhon/todo/actions
```

---

## 🎉 Готово!

После настройки каждый push в ветку `main` (или `gh-pages`) будет автоматически деплоить приложение на сервер!

**Проверить деплой:**
- GitHub Actions: https://github.com/olimdzhon/todo/actions
- Приложение: http://77.237.244.209

---

## 📞 Полезные команды:

```bash
# Проверить SSH подключение
ssh -i ~/.ssh/github_actions_todo root@77.237.244.209 "echo OK"

# Проверить статус на сервере
ssh root@77.237.244.209 "cd /root/todo-app && docker-compose ps"

# Посмотреть логи
ssh root@77.237.244.209 "cd /root/todo-app && docker-compose logs -f"

# Ручной деплой
./deploy-production.sh

# Проверить health
curl http://77.237.244.209/health
```

---

**Последнее обновление:** 24 апреля 2026