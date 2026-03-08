# ⚡ Быстрые команды — Умный Водитель 2.0

Все команды для работы с проектом.

---

## 📦 Установка зависимостей

```bash
flutter pub get
```

---

## 🔨 Сборка

### APK (Android)

```bash
# Скрипт (рекомендуется)
./build_apk.sh

# Вручную
flutter build apk --release

# Результат
build/app/outputs/flutter-apk/app-release.apk
```

### iOS (только macOS)

```bash
# Скрипт
./build_ios.sh

# Вручную
flutter build ios --release --no-codesign
```

### AAB (для Google Play)

```bash
flutter build appbundle --release
```

### Docker

```bash
./build_docker.sh
# Результат: output/smart-driver-2.apk
```

---

## 🧪 Тестирование

### Запуск на эмуляторе

```bash
flutter run
```

### Запуск на устройстве

```bash
# Подключите устройство через USB
flutter devices
flutter run -d <device-id>
```

### Веб-демо

```bash
./run_web_demo.sh
# Или:
flutter run -d chrome
```

---

## 🔍 Анализ кода

```bash
# Линтинг
flutter analyze

# Форматирование
flutter format lib/

# Проверка размера APK
flutter build apk --analyze-size
```

---

## 🧹 Очистка

```bash
# Очистка build кэша
flutter clean

# Переустановка зависимостей
flutter clean && flutter pub get
```

---

## 🧪 Тесты

```bash
# Все тесты
flutter test

# С покрытием
flutter test --coverage

# Конкретный файл
flutter test test/widget_test.dart
```

---

## 📱 Установка на устройство

```bash
# Через ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# Удаление предыдущей версии
adb uninstall com.smartdriver2.app
```

---

## 🐛 Отладка

```bash
# Логи
flutter logs

# Информация о Flutter
flutter doctor

# Информация о подключённых устройствах
flutter devices

# Производительность
flutter run --profile

# Memory leaks
flutter run --leak-tracking
```

---

## 📊 Информация о проекте

```bash
# Размер проекта
du -sh .

# Количество файлов
find . -type f | wc -l

# Количество строк Dart кода
find lib -name "*.dart" | xargs wc -l

# Зависимости
flutter pub deps
```

---

## 🔄 Git

```bash
# Инициализация
git init
git add .
git commit -m "Initial commit"

# Создание репозитория на GitHub
gh repo create smart-driver-2 --public

# Push
git push origin main
```

---

## 🌐 Web сборка

```bash
# Сборка
flutter build web --release

# Результат
build/web/

# Локальный сервер
cd build/web
python3 -m http.server 8000
```

---

## 🐳 Docker

```bash
# Сборка образа
docker build -f Dockerfile.build -t smart-driver-2-builder .

# Запуск контейнера
docker run --rm -v $(pwd)/output:/output smart-driver-2-builder

# Или используйте скрипт
./build_docker.sh
```

---

## 📦 Google Play

```bash
# Создание keystore
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Сборка подписанного APK
flutter build apk --release

# Сборка AAB
flutter build appbundle --release
```

---

## 🍏 App Store

```bash
# Установка CocoaPods зависимостей
cd ios
pod install
cd ..

# Сборка IPA
flutter build ipa --release
```

---

## ⚙️ Конфигурация

```bash
# Изменить package name (Android)
# Редактировать: android/app/build.gradle
# applicationId "com.smartdriver2.app"

# Изменить Bundle ID (iOS)
# Редактировать: ios/Runner.xcodeproj
# Bundle Identifier

# Изменить версию
# Редактировать: pubspec.yaml
# version: 1.0.0+1
```

---

## 🔧 Полезные алиасы

Добавьте в `.bashrc` или `.zshrc`:

```bash
alias frun='flutter run'
alias fbuild='flutter build apk --release'
alias fclean='flutter clean && flutter pub get'
alias ftest='flutter test'
alias fanalyze='flutter analyze'
```

---

## 📞 Помощь

```bash
# Справка Flutter
flutter --help

# Справка по команде
flutter build --help

# Версия Flutter
flutter --version

# Информация о системе
flutter doctor -v
```

---

## 🚀 Быстрый старт (копипаста)

```bash
# 1. Клонирование + зависимости
git clone <repo-url>
cd smart-driver-2
flutter pub get

# 2. Сборка APK
./build_apk.sh

# 3. Установка на устройство
adb install build/app/outputs/flutter-apk/app-release.apk

# Готово! 🎉
```

---

**Дата:** 2026-03-08  
**Версия:** 1.0.0
