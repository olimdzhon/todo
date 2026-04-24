# GitHub Actions Setup Guide

## 🤖 Автоматический деплой на GitHub Pages

Ваш проект настроен для автоматического деплоя через GitHub Actions.

---

## 📋 Что уже готово:

✅ Workflow файлы созданы в `.github/workflows/`  
✅ `deploy.yml` - деплой из ветки `gh-pages`  
✅ `deploy-from-main.yml` - деплой из ветки `main`  

---

## 🚀 Настройка (один раз)

### 1. Запушьте код на GitHub

```bash
cd /Users/olimdzonsadykov/Desktop/Todo
git add .github/
git commit -m "Add GitHub Actions workflows"
git push origin gh-pages
```

### 2. Включите GitHub Pages через Actions

1. Откройте репозиторий на GitHub
2. **Settings** → **Pages**
3. В разделе **Source** выберите: **GitHub Actions**
4. Сохраните

### 3. Готово!

При каждом пуше в ветку `gh-pages` сайт будет автоматически деплоиться.

---

## 📂 Два варианта деплоя:

### Вариант 1: Из ветки gh-pages (текущий)
- Файл: `.github/workflows/deploy.yml`
- Триггер: push в `gh-pages`
- Деплоит все файлы из корня

### Вариант 2: Из ветки main
- Файл: `.github/workflows/deploy-from-main.yml`
- Триггер: push в `main`
- Автоматически копирует файлы из `frontend/` в корень

**Чтобы использовать вариант 2:**
1. Переименуйте `deploy.yml` → `deploy.yml.disabled`
2. Переименуйте `deploy-from-main.yml` → `deploy.yml`
3. Создайте ветку `main` и запушьте туда код

---

## 🔄 Как это работает:

1. Вы делаете изменения в коде
2. Коммитите и пушите: `git push origin gh-pages`
3. GitHub Actions автоматически:
   - Проверяет код
   - Настраивает Pages
   - Загружает файлы
   - Деплоит сайт
4. Сайт обновляется через 30-60 секунд

---

## 📊 Мониторинг деплоя

### Проверить статус:
1. Откройте репозиторий на GitHub
2. Вкладка **Actions**
3. Увидите список всех деплоев

### Если деплой упал:
- Кликните на упавший workflow
- Посмотрите логи
- Исправьте ошибку и запушьте снова

---

## 🎯 Быстрый деплой

```bash
# Внесите изменения в файлы
git add .
git commit -m "Update site"
git push origin gh-pages

# GitHub Actions автоматически задеплоит
```

Или используйте скрипт:
```bash
./deploy_github_pages.sh
```

---

## ⚙️ Ручной запуск деплоя

Workflow настроен с `workflow_dispatch`, поэтому можно запустить вручную:

1. GitHub → **Actions**
2. Выберите "Deploy to GitHub Pages"
3. **Run workflow** → выберите ветку → **Run workflow**

---

## 🔐 Permissions

Workflow использует встроенный `GITHUB_TOKEN` - дополнительная настройка не нужна.

Необходимые права (уже настроены):
- `contents: read` - чтение кода
- `pages: write` - запись на Pages
- `id-token: write` - аутентификация

---

## 🌐 URL вашего сайта

После первого успешного деплоя:
```
https://ВАШ_USERNAME.github.io/ВАШ_РЕПОЗИТОРИЙ/
```

---

## ❓ FAQ

**Q: Сколько времени занимает деплой?**  
A: 30-60 секунд после пуша

**Q: Можно ли откатить деплой?**  
A: Да, сделайте `git revert` и запушьте

**Q: Workflow не запускается?**  
A: Проверьте Settings → Actions → разрешены ли workflows

**Q: Нужно ли удалять ветку gh-pages?**  
A: Нет, она используется для хранения кода

---

## 📝 Дополнительная настройка

### Добавить кастомный домен:

1. Settings → Pages → Custom domain
2. Введите домен (например, `todo.example.com`)
3. Добавьте CNAME запись у регистратора домена

### Включить HTTPS:
- Автоматически включается GitHub Pages
- Для кастомного домена может занять до 24 часов

---

## 🎉 Готово!

Теперь ваш сайт деплоится автоматически при каждом пуше.