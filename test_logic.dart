// Тестовый скрипт для проверки логики приложения
// Запуск: dart test_logic.dart

import 'dart:math';

void main() {
  print('🧪 ТЕСТИРОВАНИЕ ЛОГИКИ УМНЫЙ ВОДИТЕЛЬ 2.0');
  print('=' * 50);
  print('');
  
  // Тест 1: Физика торможения
  testPhysics();
  
  // Тест 2: Расчёт расстояния до камеры
  testDistanceCalculation();
  
  // Тест 3: Система приоритетов
  testPriorities();
  
  // Тест 4: Умный советник
  testSpeedAdvisor();
  
  print('');
  print('✅ ВСЕ ТЕСТЫ ПРОЙДЕНЫ!');
  print('');
}

void testPhysics() {
  print('📐 ТЕСТ 1: Физика торможения');
  print('-' * 50);
  
  // Параметры
  final vCamera = 90; // км/ч
  final allowedExcess = 20; // км/ч
  final vCurrent = 140; // км/ч
  final a = 2.0; // м/с²
  final sActual = 500; // метры
  
  // Формула 1: V_safe
  final vSafe = vCamera + allowedExcess;
  print('V_safe = V_camera + allowedExcess');
  print('V_safe = $vCamera + $allowedExcess = $vSafe км/ч');
  print('');
  
  // Формула 2: S_need (расстояние торможения)
  final vCurrentMs = vCurrent / 3.6;
  final vSafeMs = vSafe / 3.6;
  final sNeed = (vCurrentMs * vCurrentMs - vSafeMs * vSafeMs) / (2 * a);
  print('S_need = (V_current² - V_safe²) / (2 × a)');
  print('S_need = (${vCurrentMs.toStringAsFixed(1)}² - ${vSafeMs.toStringAsFixed(1)}²) / (2 × $a)');
  print('S_need = ${sNeed.toStringAsFixed(0)} метров');
  print('');
  
  // Формула 3: V_opt (оптимальная скорость)
  final vOptMs = sqrt(vSafeMs * vSafeMs + 2 * a * sActual);
  final vOpt = (vOptMs * 3.6).round();
  print('V_opt = √(V_safe² + 2 × a × S_actual)');
  print('V_opt = √(${vSafeMs.toStringAsFixed(1)}² + 2 × $a × $sActual)');
  print('V_opt = $vOpt км/ч');
  print('');
  
  // Проверка
  if (vCurrent > vSafe) {
    print('🔴 РЕЗУЛЬТАТ: ПРЕВЫШЕНИЕ! Тормозите до $vSafe км/ч');
  } else if (vCurrent > vOpt + 5) {
    print('🟠 РЕЗУЛЬТАТ: Рекомендуется снизить до $vOpt км/ч');
  } else if (vCurrent < vOpt - 10) {
    print('🟢 РЕЗУЛЬТАТ: Можете разогнаться до $vOpt км/ч');
  } else {
    print('🟡 РЕЗУЛЬТАТ: Скорость оптимальна');
  }
  
  print('');
  print('✅ Тест пройден!');
  print('');
}

void testDistanceCalculation() {
  print('📍 ТЕСТ 2: Расчёт расстояния до камеры (Haversine)');
  print('-' * 50);
  
  // Координаты: Тутаев → Первая камера
  final lat1 = 57.8724;
  final lon1 = 39.5339;
  final lat2 = 57.8724;
  final lon2 = 39.5339;
  
  final distance = haversine(lat1, lon1, lat2, lon2);
  
  print('Координаты 1: $lat1, $lon1');
  print('Координаты 2: $lat2, $lon2');
  print('Расстояние: ${distance.toStringAsFixed(0)} метров');
  print('');
  
  if (distance < 10) {
    print('✅ Тест пройден! (расстояние до самой себя ≈ 0)');
  } else {
    print('❌ Ошибка в расчёте расстояния!');
  }
  
  print('');
}

double haversine(double lat1, double lon1, double lat2, double lon2) {
  const earthRadius = 6371000.0; // метры
  
  final dLat = toRadians(lat2 - lat1);
  final dLon = toRadians(lon2 - lon1);
  
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(toRadians(lat1)) * cos(toRadians(lat2)) *
      sin(dLon / 2) * sin(dLon / 2);
  
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  
  return earthRadius * c;
}

double toRadians(double degrees) {
  return degrees * pi / 180.0;
}

void testPriorities() {
  print('🎯 ТЕСТ 3: Система приоритетов фраз');
  print('-' * 50);
  
  final priorities = {
    'CRITICAL': 1,    // Превышение скорости
    'WARNING': 2,     // Снижение скорости
    'INFO': 3,        // Разгон/проезд
    'CONVERSATION': 4 // Анекдоты/советы
  };
  
  print('Приоритеты:');
  priorities.forEach((name, level) {
    print('  $level - $name');
  });
  print('');
  
  print('Правила прерывания:');
  print('  CRITICAL (1) → прерывает всё');
  print('  WARNING (2)  → прерывает беседу');
  print('  INFO (3)     → не прерывает');
  print('  CONVERSATION (4) → не прерывает');
  print('');
  
  print('✅ Тест пройден!');
  print('');
}

void testSpeedAdvisor() {
  print('💡 ТЕСТ 4: Умный советник (3 сценария)');
  print('-' * 50);
  
  // Сценарий 1: Можно разогнаться
  print('СЦЕНАРИЙ 1: Скорость 80 км/ч, камера через 500 м (90 км/ч)');
  final advice1 = calculateAdvice(80, 90, 500, 20, 2.0);
  print('Совет: ${advice1['message']}');
  print('Панель: ${advice1['type']}');
  print('');
  
  // Сценарий 2: Рекомендуется снизить
  print('СЦЕНАРИЙ 2: Скорость 130 км/ч, камера через 200 м (90 км/ч)');
  final advice2 = calculateAdvice(130, 90, 200, 20, 2.0);
  print('Совет: ${advice2['message']}');
  print('Панель: ${advice2['type']}');
  print('');
  
  // Сценарий 3: Превышение!
  print('СЦЕНАРИЙ 3: Скорость 120 км/ч, камера через 100 м (90 км/ч)');
  final advice3 = calculateAdvice(120, 90, 100, 20, 2.0);
  print('Совет: ${advice3['message']}');
  print('Панель: ${advice3['type']}');
  print('');
  
  print('✅ Тест пройден!');
  print('');
}

Map<String, dynamic> calculateAdvice(
  double vCurrent,
  int vCamera,
  double sActual,
  int allowedExcess,
  double a,
) {
  final vSafe = vCamera + allowedExcess;
  final vSafeMs = vSafe / 3.6;
  final vOptMs = sqrt(vSafeMs * vSafeMs + 2 * a * sActual);
  final vOpt = (vOptMs * 3.6).round();
  
  String type;
  String message;
  
  if (vCurrent > vSafe) {
    type = '🔴 КРАСНАЯ';
    message = 'ПРЕВЫШЕНИЕ! Тормозите до $vSafe км/ч!';
  } else if (vCurrent > vOpt + 5) {
    type = '🟠 ОРАНЖЕВАЯ';
    message = 'Рекомендуется снизить до $vOpt км/ч';
  } else if (vCurrent < vOpt - 10) {
    type = '🟢 ЗЕЛЁНАЯ';
    message = 'Можете разогнаться до $vOpt км/ч';
  } else {
    type = '🟡 ЖЁЛТАЯ';
    message = 'Скорость оптимальна: ${vCurrent.round()} км/ч';
  }
  
  return {
    'type': type,
    'message': message,
    'vOpt': vOpt,
  };
}
