import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/speed_advice.dart';
import '../models/camera.dart';

class SpeedAdvisorService extends ChangeNotifier {
  SpeedAdvice? _currentAdvice;

  SpeedAdvice? get currentAdvice => _currentAdvice;

  /// Расчёт оптимальной скорости на основе физики торможения
  /// 
  /// Формулы:
  /// - V_safe = V_camera + allowedExcess (нештрафуемый порог)
  /// - S_need = (V_current² - V_safe²) / (2 * a) — требуемое расстояние торможения
  /// - V_opt = √(V_safe² + 2 * a * S_actual) — оптимальная скорость
  SpeedAdvice? calculateAdvice({
    required double currentSpeedKmh,
    required Camera? nearestCamera,
    required double distanceToCamera,
    required int allowedExcess,
    required double deceleration,
    required bool mode100,
  }) {
    // Режим "100 км/ч"
    if (mode100) {
      if (currentSpeedKmh > 100) {
        _currentAdvice = SpeedAdvice(
          type: AdviceType.critical,
          message: 'ПРЕВЫШЕНИЕ! Снизьте скорость до 100 км/ч',
          recommendedSpeed: 100,
          currentSpeed: currentSpeedKmh.round(),
          cameraSpeedLimit: 100,
          distanceToCamera: 0,
        );
      } else if (currentSpeedKmh < 90) {
        _currentAdvice = SpeedAdvice(
          type: AdviceType.speedUp,
          message: 'Можете разогнаться до 100 км/ч',
          recommendedSpeed: 100,
          currentSpeed: currentSpeedKmh.round(),
          cameraSpeedLimit: 100,
          distanceToCamera: 0,
        );
      } else {
        _currentAdvice = SpeedAdvice(
          type: AdviceType.slowDown,
          message: 'Скорость в норме: ${currentSpeedKmh.round()} км/ч',
          recommendedSpeed: 100,
          currentSpeed: currentSpeedKmh.round(),
          cameraSpeedLimit: 100,
          distanceToCamera: 0,
        );
      }
      notifyListeners();
      return _currentAdvice;
    }

    // Обычный режим (с камерами)
    if (nearestCamera == null || distanceToCamera > 5000) {
      _currentAdvice = null;
      notifyListeners();
      return null;
    }

    final vCamera = nearestCamera.speedLimit;
    final vSafe = vCamera + allowedExcess;
    final vCurrent = currentSpeedKmh;
    final a = deceleration;
    final s = distanceToCamera;

    // Конвертируем км/ч в м/с для расчётов
    final vSafeMs = vSafe / 3.6;
    final vCurrentMs = vCurrent / 3.6;

    // Требуемое расстояние торможения (метры)
    final sNeed = (vCurrentMs * vCurrentMs - vSafeMs * vSafeMs) / (2 * a);

    // Оптимальная скорость (м/с)
    final vOptMs = sqrt(vSafeMs * vSafeMs + 2 * a * s);
    final vOpt = (vOptMs * 3.6).round();

    // Определяем тип совета
    AdviceType type;
    String message;
    int recommendedSpeed;

    if (vCurrent > vSafe) {
      // КРИТИЧЕСКОЕ превышение
      type = AdviceType.critical;
      message = 'ПРЕВЫШЕНИЕ! Тормозите до $vSafe км/ч!';
      recommendedSpeed = vSafe;
    } else if (vCurrent > vOpt + 5) {
      // Рекомендуется снизить скорость
      type = AdviceType.slowDown;
      message = 'Рекомендуется снизить до $vOpt км/ч';
      recommendedSpeed = vOpt;
    } else if (vCurrent < vOpt - 10) {
      // Можно разогнаться
      type = AdviceType.speedUp;
      message = 'Можете разогнаться до $vOpt км/ч';
      recommendedSpeed = vOpt;
    } else {
      // Скорость в норме
      type = AdviceType.slowDown;
      message = 'Скорость оптимальна: ${vCurrent.round()} км/ч';
      recommendedSpeed = vOpt;
    }

    _currentAdvice = SpeedAdvice(
      type: type,
      message: message,
      recommendedSpeed: recommendedSpeed,
      currentSpeed: vCurrent.round(),
      cameraSpeedLimit: vCamera,
      distanceToCamera: distanceToCamera,
    );

    notifyListeners();
    return _currentAdvice;
  }
}
