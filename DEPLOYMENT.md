# 🚀 Deployment Guide — Умный Водитель 2.0

Полное руководство по развёртыванию приложения на всех платформах.

---

## 📱 Android

### Вариант 1: Локальная сборка

**Требования:**
- Flutter SDK ≥ 3.0.0
- Android SDK (через Android Studio)
- JDK 17+

**Шаги:**

```bash
# 1. Клонировать проект
git clone https://github.com/yourusername/smart-driver-2.git
cd smart-driver-2

# 2. Установить зависимости
flutter pub get

# 3. Собрать APK
flutter build apk --release

# 4. APK находится в:
# build/app/outputs/flutter-apk/app-release.apk
```

**Установка на устройство:**

```bash
# Через ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# Или скопировать файл на телефон и установить вручную
```

---

### Вариант 2: Docker

**Требования:**
- Docker

**Шаги:**

```bash
# Сборка через Docker
./build_docker.sh

# APK будет в папке output/
```

---

### Вариант 3: GitHub Actions

**Автоматическая сборка при push:**

1. Загрузите проект на GitHub
2. GitHub Actions автоматически соберёт APK
3. Скачайте APK из Artifacts

**Настройка:**
- Файл workflow уже создан: `.github/workflows/build.yml`
- При каждом push в main/master — автоматическая сборка

---

### Вариант 4: Онлайн-сервисы

#### Codemagic (рекомендуется)

1. Зарегистрируйтесь: https://codemagic.io
2. Подключите GitHub репозиторий
3. Выберите "Flutter App"
4. Нажмите "Start new build"
5. Скачайте APK (бесплатно 500 мин/мес)

#### Alternatives:
- **AppCircle** — https://appcircle.io (25 мин/мес бесплатно)
- **Bitrise** — https://bitrise.io (10 мин/мес бесплатно)

---

## 🍎 iOS

### Требования:
- macOS
- Xcode ≥ 15.0
- Apple Developer Account (для публикации в App Store)

### Шаги:

```bash
# 1. Клонировать проект
git clone https://github.com/yourusername/smart-driver-2.git
cd smart-driver-2

# 2. Установить зависимости
flutter pub get

# 3. Установить CocoaPods зависимости
cd ios
pod install
cd ..

# 4. Собрать iOS (без подписи)
flutter build ios --release --no-codesign
```

### Установка на устройство:

1. Откройте `ios/Runner.xcworkspace` в Xcode
2. Подключите iPhone через USB
3. Выберите устройство в Xcode
4. Нажмите ▶️ Run

---

## 🌐 Web (демо)

**Для тестирования UI без установки APK:**

```bash
# Запуск локального сервера
flutter run -d chrome

# Или
./run_web_demo.sh
```

**Сборка для production:**

```bash
flutter build web --release
```

Результат в `build/web/` — можно разместить на любом хостинге.

---

## 📦 Google Play Store

### Подготовка

1. **Создайте Developer аккаунт** ($25 разово)
   - https://play.google.com/console

2. **Подпишите APK:**

```bash
# Создайте keystore
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Создайте android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<путь к upload-keystore.jks>

# Обновите android/app/build.gradle
# (раскомментируйте секцию signingConfigs)

# Соберите signed APK
flutter build apk --release
```

3. **Подготовьте материалы:**
   - Иконка приложения (512×512 px)
   - Скриншоты (минимум 2, максимум 8)
   - Feature graphic (1024×500 px)
   - Описание (до 4000 символов)
   - Краткое описание (до 80 символов)

4. **Загрузите в Play Console:**
   - Создайте приложение
   - Загрузите APK
   - Заполните описание
   - Опубликуйте

---

## 🍏 Apple App Store

### Подготовка

1. **Создайте Developer аккаунт** ($99/год)
   - https://developer.apple.com

2. **Настройте Bundle ID:**
   - Откройте `ios/Runner.xcodeproj` в Xcode
   - Измените Bundle Identifier на уникальный

3. **Подпишите приложение:**
   - В Xcode: Signing & Capabilities
   - Выберите свой Developer Team

4. **Подготовьте материалы:**
   - Иконка приложения (1024×1024 px)
   - Скриншоты для всех размеров экранов
   - Описание
   - Ключевые слова
   - Privacy Policy URL

5. **Соберите IPA:**

```bash
flutter build ipa --release
```

6. **Загрузите в App Store Connect:**
   - Используйте Xcode → Product → Archive
   - Или Transporter app
   - Заполните метаданные
   - Отправьте на Review

---

## 🔧 Настройка для production

### 1. Обновите версию

В `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

### 2. Оптимизируйте размер APK

```bash
# Сборка с obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Сборка AAB (для Play Store)
flutter build appbundle --release
```

### 3. Настройте аналитику (опционально)

Добавьте Firebase Analytics:

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_analytics: ^10.7.0
```

### 4. Настройте Crash Reporting

```yaml
dependencies:
  firebase_crashlytics: ^3.4.0
```

---

## 🧪 Тестирование перед релизом

### Checklist:

- [ ] Протестировано на Android (минимум 3 устройства)
- [ ] Протестировано на iOS (минимум 2 устройства)
- [ ] GPS работает в реальных условиях
- [ ] TTS работает на обоих платформах
- [ ] Умный собеседник говорит
- [ ] Все настройки сохраняются
- [ ] Приложение работает в фоне
- [ ] Батарея не разряжается слишком быстро
- [ ] Нет утечек памяти
- [ ] Все анимации плавные (60 FPS)

### Инструменты тестирования:

```bash
# Анализ производительности
flutter run --profile

# Проверка размера APK
flutter build apk --analyze-size

# Memory leaks
flutter run --leak-tracking
```

---

## 📊 Мониторинг после релиза

### Google Play Console:
- Отчёты о сбоях
- Статистика установок
- Отзывы пользователей

### App Store Connect:
- Crash reports
- Downloads/Updates
- Reviews

### Firebase:
- Analytics
- Crashlytics
- Performance Monitoring

---

## 🔄 Обновления

### Минорные (1.0.x → 1.1.0):

```bash
# 1. Обновите версию в pubspec.yaml
version: 1.1.0+2

# 2. Соберите новый APK
flutter build apk --release

# 3. Загрузите в Play Store / App Store
```

### Мажорные (1.x.x → 2.0.0):

- Сообщите пользователям о breaking changes
- Обновите документацию
- Подготовьте migration guide

---

## 🆘 Troubleshooting

### Проблема: "Flutter SDK not found"
**Решение:**
```bash
export PATH="$PATH:/opt/flutter/bin"
```

### Проблема: "Gradle build failed"
**Решение:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Проблема: "CocoaPods not installed"
**Решение:**
```bash
sudo gem install cocoapods
```

### Проблема: "APK слишком большой (>50 MB)"
**Решение:**
```bash
# Соберите AAB вместо APK
flutter build appbundle --release

# Или разделите APK по архитектурам
flutter build apk --split-per-abi
```

---

## 📞 Поддержка

Вопросы: [@GURU_707](https://t.me/GURU_707)

---

**Создано:** 2026-03-08  
**Версия:** 1.0.0
