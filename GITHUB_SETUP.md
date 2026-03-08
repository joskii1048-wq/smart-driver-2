# 🚀 Быстрая публикация на GitHub с автосборкой APK

## Шаг 1: Создать репозиторий на GitHub (2 минуты)

1. **Перейти:** https://github.com/new

2. **Заполнить форму:**
   - **Repository name:** `smart-driver-2`
   - **Description:** "Умный Водитель 2.0 - Flutter приложение для безопасного вождения с физикой торможения"
   - **Visibility:** Public (или Private)
   - **НЕ ставить галочки:** "Add a README", "Add .gitignore", "Choose a license"

3. **Нажать:** "Create repository"

---

## Шаг 2: Загрузить проект (30 секунд)

После создания репозитория GitHub покажет инструкции. Выполните на сервере:

```bash
cd /home/openclaw/.openclaw/workspace/projects/smart-driver-2

# Добавить удалённый репозиторий (замените YOUR_USERNAME на ваш GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/smart-driver-2.git

# Отправить код
git branch -M main
git push -u origin main
```

**Или через GitHub CLI (если установлен):**
```bash
cd /home/openclaw/.openclaw/workspace/projects/smart-driver-2
gh repo create smart-driver-2 --public --source=. --push
```

---

## Шаг 3: Автоматическая сборка APK (происходит сама!)

После `git push` GitHub Actions автоматически:

1. ✅ Установит Flutter SDK
2. ✅ Соберёт проект
3. ✅ Создаст APK файл
4. ✅ Загрузит его как артефакт

**Где найти APK:**
- Перейти: https://github.com/YOUR_USERNAME/smart-driver-2/actions
- Выбрать последний успешный запуск (зелёная галочка ✅)
- Внизу страницы: **Artifacts** → **smart-driver-2-release.apk**
- Скачать ZIP → внутри будет готовый APK!

**Время сборки:** ~5-7 минут

---

## Альтернатива: Я могу сделать всё сам

Если дадите мне GitHub токен, я:
1. Создам репозиторий от вашего имени
2. Загружу весь код
3. Запущу сборку
4. Дам вам ссылку на готовый APK

**Как получить токен (1 минута):**

1. Перейти: https://github.com/settings/tokens/new
2. **Note:** "OpenClaw Smart Driver Deploy"
3. **Expiration:** 7 days
4. **Permissions:** Поставить галочку `repo` (Full control)
5. **Generate token** → Скопировать токен
6. Прислать мне токен

---

## 📧 Email для альтернативных сервисов

Ваш email: `joskii1048@gmail.com`

**Codemagic** (если GitHub Actions не подходит):
1. https://codemagic.io/signup
2. Регистрация через email: `joskii1048@gmail.com`
3. Подключить репозиторий GitHub
4. Автосборка настроится автоматически

---

## 🎯 Что проще?

### Вариант А: Вы сами (5 минут)
1. Создать репозиторий на GitHub
2. `git push` (3 команды)
3. Подождать 5-7 минут
4. Скачать APK

### Вариант Б: Я сделаю (30 секунд после токена)
1. Дать мне GitHub токен
2. Я всё сделаю
3. Дам ссылку на APK

**Выбирайте!** Если Вариант Б → пришлите токен.
