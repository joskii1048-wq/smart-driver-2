# Contributing to Умный Водитель 2.0

Спасибо за интерес к проекту! 🎉

## Как внести вклад

### Сообщить об ошибке

1. Проверьте, не была ли ошибка уже сообщена в [Issues](../../issues)
2. Если нет — создайте новый issue с описанием:
   - Шаги для воспроизведения
   - Ожидаемое поведение
   - Фактическое поведение
   - Версия приложения
   - Устройство (модель, Android/iOS версия)

### Предложить новую функцию

1. Создайте issue с меткой `enhancement`
2. Опишите:
   - Что вы хотите добавить
   - Зачем это нужно
   - Как это должно работать

### Внести код

1. **Fork репозитория**
2. **Создайте ветку** для своей функции:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Следуйте стилю кода:**
   - Используйте `flutter analyze` перед коммитом
   - Добавьте комментарии к сложным местам
   - Следуйте принципам SOLID
4. **Добавьте тесты** (если применимо)
5. **Закоммитьте изменения:**
   ```bash
   git commit -m "feat: добавил amazing-feature"
   ```
6. **Запушьте в ветку:**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Создайте Pull Request**

## Стиль коммитов

Используем [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` — новая функция
- `fix:` — исправление ошибки
- `docs:` — изменения в документации
- `style:` — форматирование кода
- `refactor:` — рефакторинг без изменения функциональности
- `test:` — добавление тестов
- `chore:` — обновление зависимостей, конфигурации

**Примеры:**
```
feat: добавил историю поездок
fix: исправил утечку памяти в GPSService
docs: обновил README с инструкциями по сборке
```

## Структура проекта

```
lib/
├── main.dart              # Точка входа
├── models/                # Модели данных
│   ├── camera.dart
│   └── speed_advice.dart
├── services/              # Бизнес-логика
│   ├── gps_service.dart
│   ├── camera_service.dart
│   ├── speed_advisor_service.dart
│   ├── conversation_service.dart
│   └── settings_service.dart
└── screens/               # UI экраны
    ├── main_screen.dart
    └── settings_screen.dart
```

## Код-стайл

### Dart
- Используйте `const` конструкторы где возможно
- Избегайте `print()` в production коде (используйте `debugPrint()`)
- Максимальная длина строки: 80 символов
- Именование:
  - Классы: `PascalCase`
  - Функции/переменные: `camelCase`
  - Константы: `kConstantName`
  - Приватные: `_privateName`

### Flutter виджеты
- Разделяйте UI на маленькие переиспользуемые виджеты
- Используйте `StatelessWidget` где возможно
- Provider для state management

## Тестирование

```bash
# Запуск всех тестов
flutter test

# Запуск с покрытием
flutter test --coverage

# Анализ кода
flutter analyze
```

## Сборка

```bash
# APK (Android)
flutter build apk --release

# iOS
flutter build ios --release --no-codesign

# Веб (демо)
flutter build web
```

## Зависимости

При добавлении новой зависимости:
1. Добавьте в `pubspec.yaml`
2. Запустите `flutter pub get`
3. Обновите документацию
4. Проверьте лицензию зависимости

## Вопросы?

Пишите в [Telegram: @GURU_707](https://t.me/GURU_707)

---

Спасибо за вклад! 🚀
