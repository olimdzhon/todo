# GitHub Pages Deployment Instructions

## Статус
✅ Проект готов к деплою на GitHub Pages
✅ Ветка `gh-pages` создана
✅ Файлы фронтенда скопированы в корень

## Шаги для деплоя

### 1. Создайте репозиторий на GitHub
Перейдите на https://github.com/new и создайте новый репозиторий (например, `todo-app`)

### 2. Подключите удалённый репозиторий
```bash
cd /Users/olimdzonsadykov/Desktop/Todo
git remote add origin https://github.com/ВАШ_USERNAME/todo-app.git
```

### 3. Запушьте ветку gh-pages
```bash
git push -u origin gh-pages
```

### 4. Настройте GitHub Pages
1. Откройте ваш репозиторий на GitHub
2. Перейдите в **Settings** → **Pages**
3. В разделе **Source** выберите:
   - Branch: `gh-pages`
   - Folder: `/ (root)`
4. Нажмите **Save**

### 5. Получите URL вашего сайта
После настройки GitHub Pages автоматически задеплоит сайт.
URL будет доступен по адресу:

```
https://ВАШ_USERNAME.github.io/todo-app/
```

Деплой занимает 1-3 минуты. Проверьте статус в разделе **Actions** на GitHub.

## Структура проекта

В ветке `gh-pages` файлы расположены так:
```
/
├── index.html    # Главная страница
├── app.js        # JavaScript логика
├── styles.css    # Стили
├── backend/      # Backend (не используется на GitHub Pages)
└── frontend/     # Исходные файлы фронтенда
```

## Важно

⚠️ **Backend не будет работать на GitHub Pages**, так как это статический хостинг.
Для полноценной работы с API нужно:
- Задеплоить backend отдельно (Heroku, Railway, DigitalOcean и т.д.)
- Обновить URL API в `app.js`

## Обновление сайта

Для обновления сайта после изменений:

```bash
# Внесите изменения в файлы
git add .
git commit -m "Update site"
git push origin gh-pages
```

GitHub Pages автоматически обновит сайт через 1-3 минуты.

## Альтернатива: деплой с main ветки

Если хотите деплоить с main ветки:

```bash
git checkout main
git push origin main
```

Затем в Settings → Pages выберите `main` вместо `gh-pages`.

---

**Готово!** Ваш TODO App будет доступен по адресу `https://ВАШ_USERNAME.github.io/todo-app/`
