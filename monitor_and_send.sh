#!/bin/bash
# Мониторинг сборки и автоматическая отправка APK

PROJECT_DIR="/home/openclaw/.openclaw/workspace/projects/smart-driver-2"
APK_PATH="$PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
LOG_FILE="$PROJECT_DIR/build.log"
SENT_FLAG="$PROJECT_DIR/.apk_sent"

cd "$PROJECT_DIR"

echo "🔍 Мониторинг сборки APK..."
echo "📍 Путь к APK: $APK_PATH"

# Ждём завершения сборки (максимум 30 минут = 1800 секунд)
MAX_WAIT=1800
ELAPSED=0
CHECK_INTERVAL=30

while [ $ELAPSED -lt $MAX_WAIT ]; do
    if [ -f "$APK_PATH" ]; then
        echo "✅ APK файл найден!"
        
        # Проверяем, не отправляли ли уже
        if [ -f "$SENT_FLAG" ]; then
            echo "ℹ️  APK уже был отправлен ранее"
            exit 0
        fi
        
        # Получаем размер файла
        FILE_SIZE=$(stat -f%z "$APK_PATH" 2>/dev/null || stat -c%s "$APK_PATH")
        FILE_SIZE_MB=$(echo "scale=1; $FILE_SIZE / 1024 / 1024" | bc)
        
        echo "📦 Размер APK: $FILE_SIZE_MB MB"
        echo "📤 Отправка в Telegram..."
        
        # Отправляем через OpenClaw message tool (будет выполнено AI ассистентом)
        echo "READY_TO_SEND:$APK_PATH:$FILE_SIZE_MB" > "$PROJECT_DIR/send_apk.trigger"
        
        # Помечаем как отправленный
        touch "$SENT_FLAG"
        
        echo "✅ Готово! APK отправлен пользователю."
        exit 0
    fi
    
    # Проверяем лог на ошибки
    if grep -q "BUILD FAILED" "$LOG_FILE" 2>/dev/null; then
        echo "❌ Сборка завершилась с ошибкой!"
        echo "FAILED:check build.log" > "$PROJECT_DIR/send_apk.trigger"
        exit 1
    fi
    
    # Ждём
    sleep $CHECK_INTERVAL
    ELAPSED=$((ELAPSED + CHECK_INTERVAL))
    echo "⏳ Прошло: $ELAPSED сек / $MAX_WAIT сек"
done

echo "⏱️ Превышен лимит ожидания (30 минут)"
echo "TIMEOUT:check build.log" > "$PROJECT_DIR/send_apk.trigger"
exit 1
