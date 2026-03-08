#!/bin/bash

echo "🍎 Умный Водитель 2.0 - Сборка iOS"
echo "=================================="
echo ""

# Проверка Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter SDK не найден!"
    exit 1
fi

# Проверка macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Сборка iOS возможна только на macOS!"
    exit 1
fi

echo "✅ Flutter SDK найден: $(flutter --version | head -n 1)"
echo ""

# Очистка
echo "🧹 Очистка предыдущих сборок..."
flutter clean
echo ""

# Зависимости
echo "📦 Установка зависимостей..."
flutter pub get
echo ""

# Pod install (iOS зависимости)
echo "📦 Установка CocoaPods зависимостей..."
cd ios
pod install
cd ..
echo ""

# Сборка iOS
echo "🔨 Сборка iOS (релиз)..."
flutter build ios --release --no-codesign
echo ""

if [ $? -eq 0 ]; then
    echo "✅ iOS успешно собран!"
    echo ""
    echo "📱 Для установки на устройство:"
    echo "1. Откройте ios/Runner.xcworkspace в Xcode"
    echo "2. Подключите iPhone"
    echo "3. Выберите устройство и нажмите Run"
else
    echo "❌ Ошибка сборки iOS!"
    exit 1
fi
