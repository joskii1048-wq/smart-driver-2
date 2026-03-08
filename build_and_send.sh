#!/bin/bash
set -e

echo "🚀 Начинаю сборку Умный Водитель 2.0..."

# Проверяем, установлен ли python-telegram-bot
if ! python3 -c "import telegram" 2>/dev/null; then
    echo "📦 Устанавливаю python-telegram-bot..."
    pip3 install python-telegram-bot --user -q
fi

# Уведомляем пользователя о начале сборки
python3 telegram-deploy-bot.py || echo "⚠️ Не удалось отправить уведомление"

# Проверяем, есть ли уже APK
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    echo "✅ APK уже существует! Отправляю пользователю..."
    python3 telegram-deploy-bot.py
    exit 0
fi

# Сборка в Docker контейнере
echo "📦 Создаю Docker образ для сборки Flutter..."
docker build -f Dockerfile.apk -t smart-driver-builder .

echo "🔨 Запускаю сборку APK (это займёт 15-20 минут)..."
docker run --rm \
    -v "$(pwd):/app" \
    -w /app \
    smart-driver-builder \
    bash -c "flutter pub get && flutter build apk --release"

# Проверяем результат
if [ -f "$APK_PATH" ]; then
    echo "✅ APK успешно собран!"
    
    # Отправляем пользователю
    echo "📤 Отправляю APK в Telegram..."
    python3 telegram-deploy-bot.py
    
    echo ""
    echo "🎉 Готово! APK отправлен пользователю в Telegram"
    echo "📍 Локальный путь: $APK_PATH"
    ls -lh "$APK_PATH"
else
    echo "❌ Ошибка: APK файл не был создан"
    python3 -c "
import asyncio
from telegram_deploy_bot import send_build_status
asyncio.run(send_build_status('error', '❌ Ошибка сборки APK. Проверьте логи.'))
"
    exit 1
fi
