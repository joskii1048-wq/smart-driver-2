#!/bin/bash

echo "🐳 Умный Водитель 2.0 - Сборка APK через Docker"
echo "================================================"
echo ""

if ! command -v docker &> /dev/null; then
    echo "❌ Docker не найден!"
    exit 1
fi

echo "✅ Docker найден"
echo ""

# Создаём папку для вывода
mkdir -p output

echo "🔨 Сборка Docker образа..."
docker build -f Dockerfile.build -t smart-driver-2-builder .

if [ $? -ne 0 ]; then
    echo "❌ Ошибка сборки образа!"
    exit 1
fi

echo ""
echo "📦 Извлечение APK..."
docker run --rm -v $(pwd)/output:/output smart-driver-2-builder

if [ -f "output/smart-driver-2.apk" ]; then
    echo ""
    echo "✅ APK успешно собран!"
    echo ""
    echo "📱 Файл: output/smart-driver-2.apk"
    echo "📊 Размер: $(du -h output/smart-driver-2.apk | cut -f1)"
    echo ""
    echo "🎉 Готово! Установите APK на Android устройство."
else
    echo "❌ Ошибка извлечения APK!"
    exit 1
fi
