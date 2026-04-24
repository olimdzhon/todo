# 🚀 Quick Start: GitHub Pages Deployment

## Ваш проект готов к деплою!

### Что уже сделано:
✅ Git репозиторий инициализирован  
✅ Ветка `gh-pages` создана  
✅ Файлы фронтенда (index.html, app.js, styles.css) скопированы в корень  
✅ Скрипт автоматического деплоя создан  

---

## 3 простых шага до деплоя:

### 1️⃣ Создайте репозиторий на GitHub
Перейдите на https://github.com/new и создайте новый репозиторий

### 2️⃣ Подключите репозиторий
```bash
cd /Users/olimdzonsadykov/Desktop/Todo
git remote add origin https://github.com/ВАШ_USERNAME/ВАШ_РЕПОЗИТОРИЙ.git
git push -u origin gh-pages
```

### 3️⃣ Включите GitHub Pages
1. Откройте репозиторий на GitHub
2. **Settings** → **Pages**
3. Source: выберите ветку `gh-pages` и папку `/ (root)`
4. Нажмите **Save**

---

## 🎉 Готово!

Ваш сайт будет доступен по адресу:
```
https://ВАШ_USERNAME.github.io/ВАШ_РЕПОЗИТОРИЙ/
```

Деплой занимает 1-3 минуты.

---

## Обновление сайта

### Вариант 1: Автоматический скрипт
```bash
./deploy_github_pages.sh
```

### Вариант 2: Вручную
```bash
git add .
git commit -m "Update site"
git push origin gh-pages
```

---

## ⚠️ Важно

**Backend не работает на GitHub Pages** (только статические файлы).  
Для работы с API задеплойте backend отдельно на:
- Heroku
- Railway
- Render
- DigitalOcean
- Vercel

Затем обновите URL API в файле `app.js`.

---

## Нужна помощь?

Подробные инструкции: `GITHUB_PAGES_DEPLOY.md`
