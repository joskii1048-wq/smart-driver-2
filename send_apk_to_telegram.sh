#!/bin/bash
# Автоматическая отправка APK в Telegram после успешной сборки

APK_PATH="/home/openclaw/.openclaw/workspace/projects/smart-driver-2/build/app/outputs/flutter-apk/app-release.apk"
TRIGGER_FILE="/home/openclaw/.openclaw/workspace/apk_ready.trigger"

# Ждём появления APK файла
echo "🔍 Ожидание завершения сборки APK..."

MAX_WAIT=1800  # 30 минут
ELAPSED=0

while [ $ELAPSED -lt $MAX_WAIT ]; do
    if [ -f "$APK_PATH" ]; then
        echo "✅ APK найден!"
        
        # Получаем размер
        SIZE=$(stat -c%s "$APK_PATH" 2>/dev/null || stat -f%z "$APK_PATH")
        SIZE_MB=$(echo "scale=1; $SIZE / 1024 / 1024" | bc)
        
        echo "📦 Размер: $SIZE_MB MB"
        echo "📍 Путь: $APK_PATH"
        
        # Создаём trigger для AI ассистента
        echo "READY|$APK_PATH|$SIZE_MB" > "$TRIGGER_FILE"
        
        echo "✅ Trigger создан. AI ассистент отправит APK пользователю."
        exit 0
    fi
    
    sleep 30
    ELAPSED=$((ELAPSED + 30))
    
    if [ $((ELAPSED % 300)) -eq 0 ]; then
        echo "⏳ Прошло $ELAPSED сек..."
    fi
done

echo "❌ Таймаут: APK не был создан за 30 минут"
echo "FAILED|timeout" > "$TRIGGER_FILE"
exit 1
