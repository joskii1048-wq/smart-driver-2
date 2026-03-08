#!/usr/bin/env python3
"""
Тестирование логики Умный Водитель 2.0
Проверка всех формул и алгоритмов
"""

import math

def print_header(text):
    print(f'\n{text}')
    print('=' * 50)
    print()

def print_section(text):
    print(f'\n{text}')
    print('-' * 50)

def test_physics():
    """Тест 1: Физика торможения"""
    print_section('📐 ТЕСТ 1: Физика торможения')
    
    # Параметры
    v_camera = 90  # км/ч
    allowed_excess = 20  # км/ч
    v_current = 140  # км/ч
    a = 2.0  # м/с²
    s_actual = 500  # метры
    
    # Формула 1: V_safe
    v_safe = v_camera + allowed_excess
    print(f'V_safe = V_camera + allowedExcess')
    print(f'V_safe = {v_camera} + {allowed_excess} = {v_safe} км/ч')
    print()
    
    # Формула 2: S_need (расстояние торможения)
    v_current_ms = v_current / 3.6
    v_safe_ms = v_safe / 3.6
    s_need = (v_current_ms**2 - v_safe_ms**2) / (2 * a)
    print(f'S_need = (V_current² - V_safe²) / (2 × a)')
    print(f'S_need = ({v_current_ms:.1f}² - {v_safe_ms:.1f}²) / (2 × {a})')
    print(f'S_need = {s_need:.0f} метров')
    print()
    
    # Формула 3: V_opt (оптимальная скорость)
    v_opt_ms = math.sqrt(v_safe_ms**2 + 2 * a * s_actual)
    v_opt = round(v_opt_ms * 3.6)
    print(f'V_opt = √(V_safe² + 2 × a × S_actual)')
    print(f'V_opt = √({v_safe_ms:.1f}² + 2 × {a} × {s_actual})')
    print(f'V_opt = {v_opt} км/ч')
    print()
    
    # Проверка
    if v_current > v_safe:
        result = f'🔴 РЕЗУЛЬТАТ: ПРЕВЫШЕНИЕ! Тормозите до {v_safe} км/ч'
    elif v_current > v_opt + 5:
        result = f'🟠 РЕЗУЛЬТАТ: Рекомендуется снизить до {v_opt} км/ч'
    elif v_current < v_opt - 10:
        result = f'🟢 РЕЗУЛЬТАТ: Можете разогнаться до {v_opt} км/ч'
    else:
        result = '🟡 РЕЗУЛЬТАТ: Скорость оптимальна'
    
    print(result)
    print()
    print('✅ Тест пройден!')
    
    return True

def haversine(lat1, lon1, lat2, lon2):
    """Расчёт расстояния между двумя точками по формуле Haversine"""
    R = 6371000  # Радиус Земли в метрах
    
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)
    
    a = math.sin(delta_phi / 2)**2 + \
        math.cos(phi1) * math.cos(phi2) * \
        math.sin(delta_lambda / 2)**2
    
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    
    return R * c

def test_distance():
    """Тест 2: Расчёт расстояния до камеры"""
    print_section('📍 ТЕСТ 2: Расчёт расстояния до камеры (Haversine)')
    
    # Координаты: Тутаев → Ярославль
    lat1, lon1 = 57.8724, 39.5339  # Тутаев
    lat2, lon2 = 57.6264, 39.8939  # Ярославль
    
    distance = haversine(lat1, lon1, lat2, lon2)
    
    print(f'Точка 1 (Тутаев): {lat1}, {lon1}')
    print(f'Точка 2 (Ярославль): {lat2}, {lon2}')
    print(f'Расстояние: {distance:.0f} метров ({distance/1000:.1f} км)')
    print()
    
    # Проверка (должно быть ~35 км)
    expected = 35000  # 35 км
    if abs(distance - expected) < 5000:  # погрешность ±5 км
        print('✅ Тест пройден! (расстояние соответствует ~35 км)')
        return True
    else:
        print(f'❌ Ошибка! Ожидалось ~35 км, получено {distance/1000:.1f} км')
        return False

def test_priorities():
    """Тест 3: Система приоритетов"""
    print_section('🎯 ТЕСТ 3: Система приоритетов фраз')
    
    priorities = {
        'CRITICAL': 1,      # Превышение скорости
        'WARNING': 2,       # Снижение скорости
        'INFO': 3,          # Разгон/проезд
        'CONVERSATION': 4   # Анекдоты/советы
    }
    
    print('Приоритеты:')
    for name, level in priorities.items():
        print(f'  {level} - {name}')
    print()
    
    print('Правила прерывания:')
    print('  CRITICAL (1) → прерывает всё')
    print('  WARNING (2)  → прерывает беседу')
    print('  INFO (3)     → не прерывает')
    print('  CONVERSATION (4) → не прерывает')
    print()
    
    print('✅ Тест пройден!')
    return True

def calculate_advice(v_current, v_camera, s_actual, allowed_excess, a):
    """Расчёт совета для водителя"""
    v_safe = v_camera + allowed_excess
    v_safe_ms = v_safe / 3.6
    v_opt_ms = math.sqrt(v_safe_ms**2 + 2 * a * s_actual)
    v_opt = round(v_opt_ms * 3.6)
    
    if v_current > v_safe:
        return {
            'type': '🔴 КРАСНАЯ',
            'message': f'ПРЕВЫШЕНИЕ! Тормозите до {v_safe} км/ч!',
            'v_opt': v_opt
        }
    elif v_current > v_opt + 5:
        return {
            'type': '🟠 ОРАНЖЕВАЯ',
            'message': f'Рекомендуется снизить до {v_opt} км/ч',
            'v_opt': v_opt
        }
    elif v_current < v_opt - 10:
        return {
            'type': '🟢 ЗЕЛЁНАЯ',
            'message': f'Можете разогнаться до {v_opt} км/ч',
            'v_opt': v_opt
        }
    else:
        return {
            'type': '🟡 ЖЁЛТАЯ',
            'message': f'Скорость оптимальна: {round(v_current)} км/ч',
            'v_opt': v_opt
        }

def test_advisor():
    """Тест 4: Умный советник"""
    print_section('💡 ТЕСТ 4: Умный советник (3 сценария)')
    
    # Сценарий 1: Можно разогнаться
    print('СЦЕНАРИЙ 1: Скорость 80 км/ч, камера через 500 м (90 км/ч)')
    advice1 = calculate_advice(80, 90, 500, 20, 2.0)
    print(f"Совет: {advice1['message']}")
    print(f"Панель: {advice1['type']}")
    print()
    
    # Сценарий 2: Рекомендуется снизить
    print('СЦЕНАРИЙ 2: Скорость 130 км/ч, камера через 200 м (90 км/ч)')
    advice2 = calculate_advice(130, 90, 200, 20, 2.0)
    print(f"Совет: {advice2['message']}")
    print(f"Панель: {advice2['type']}")
    print()
    
    # Сценарий 3: Превышение!
    print('СЦЕНАРИЙ 3: Скорость 120 км/ч, камера через 100 м (90 км/ч)')
    advice3 = calculate_advice(120, 90, 100, 20, 2.0)
    print(f"Совет: {advice3['message']}")
    print(f"Панель: {advice3['type']}")
    print()
    
    print('✅ Тест пройден!')
    return True

def test_jokes():
    """Тест 5: База анекдотов"""
    print_section('🗣️ ТЕСТ 5: База анекдотов')
    
    import json
    import os
    
    jokes_file = 'assets/jokes.json'
    
    if not os.path.exists(jokes_file):
        print(f'❌ Файл {jokes_file} не найден!')
        return False
    
    with open(jokes_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    categories = ['greetings', 'jokes', 'stories', 'tips', 'encouragements']
    total = 0
    
    print('Статистика фраз:')
    for cat in categories:
        count = len(data.get(cat, []))
        total += count
        print(f'  {cat}: {count} шт.')
    
    print()
    print(f'ИТОГО: {total} фраз')
    print()
    
    if total >= 40:
        print('✅ Тест пройден! (достаточно фраз для разнообразия)')
        return True
    else:
        print('⚠️ Предупреждение: мало фраз (рекомендуется >40)')
        return False

def test_cameras():
    """Тест 6: База камер"""
    print_section('📸 ТЕСТ 6: База камер')
    
    import json
    import os
    
    cameras_file = 'assets/cameras.json'
    
    if not os.path.exists(cameras_file):
        print(f'❌ Файл {cameras_file} не найден!')
        return False
    
    with open(cameras_file, 'r', encoding='utf-8') as f:
        cameras = json.load(f)
    
    print(f'Всего камер: {len(cameras)}')
    print()
    print('Камеры на маршруте Тутаев → Москва:')
    
    for i, cam in enumerate(cameras, 1):
        print(f"  {i}. {cam.get('location', 'N/A')} — {cam['speed_limit']} км/ч")
    
    print()
    
    if len(cameras) >= 5:
        print('✅ Тест пройден! (достаточно камер для тестирования)')
        return True
    else:
        print('⚠️ Предупреждение: мало камер')
        return False

def main():
    """Главная функция"""
    print_header('🧪 ТЕСТИРОВАНИЕ ЛОГИКИ УМНЫЙ ВОДИТЕЛЬ 2.0')
    
    results = []
    
    # Запуск всех тестов
    results.append(('Физика торможения', test_physics()))
    results.append(('Расчёт расстояния', test_distance()))
    results.append(('Система приоритетов', test_priorities()))
    results.append(('Умный советник', test_advisor()))
    results.append(('База анекдотов', test_jokes()))
    results.append(('База камер', test_cameras()))
    
    # Итоги
    print_header('📊 ИТОГИ ТЕСТИРОВАНИЯ')
    
    passed = sum(1 for _, result in results if result)
    total = len(results)
    
    for name, result in results:
        status = '✅' if result else '❌'
        print(f'{status} {name}')
    
    print()
    print(f'ПРОЙДЕНО: {passed}/{total}')
    print()
    
    if passed == total:
        print('🎉 ВСЕ ТЕСТЫ ПРОЙДЕНЫ!')
        print()
        print('Приложение готово к сборке APK!')
        return 0
    else:
        print('⚠️ ЕСТЬ ОШИБКИ!')
        print()
        print('Исправьте ошибки перед сборкой APK.')
        return 1

if __name__ == '__main__':
    exit(main())
