#!/bin/bash

echo "🚀 Умный Водитель 2.0 - Сборка APK"
echo "================================="
echo ""

# Проверка Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter SDK не найден!"
    echo ""
    echo "Установите Flutter:"
    echo "https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter SDK найден: $(flutter --version | head -n 1)"
echo ""

# Очистка предыдущих сборок
echo "🧹 Очистка предыдущих сборок..."
flutter clean
echo ""

# Получение зависимостей
echo "📦 Установка зависимостей..."
flutter pub get
echo ""

# Анализ кода
echo "🔍 Анализ кода..."
flutter analyze
if [ $? -ne 0 ]; then
    echo "⚠️  Найдены предупреждения в коде (продолжаем сборку)"
fi
echo ""

# Сборка APK
echo "🔨 Сборка APK (релиз)..."
flutter build apk --release
echo ""

# Проверка результата
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ APK успешно собран!"
    echo ""
    echo "📱 Файл: build/app/outputs/flutter-apk/app-release.apk"
    echo "📊 Размер: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"
    echo ""
    echo "🎉 Готово! Установите APK на Android устройство."
else
    echo "❌ Ошибка сборки APK!"
    exit 1
fi
