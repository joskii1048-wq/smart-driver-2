import 'package:flutter/material.dart';

enum AdviceType {
  speedUp,    // Зелёная панель - можно разогнаться
  slowDown,   // Оранжевая панель - рекомендуется снизить
  critical,   // Красная панель - превышение!
}

class SpeedAdvice {
  final AdviceType type;
  final String message;
  final int recommendedSpeed;
  final int currentSpeed;
  final int cameraSpeedLimit;
  final double distanceToCamera;

  SpeedAdvice({
    required this.type,
    required this.message,
    required this.recommendedSpeed,
    required this.currentSpeed,
    required this.cameraSpeedLimit,
    required this.distanceToCamera,
  });

  Color get panelColor {
    switch (type) {
      case AdviceType.speedUp:
        return Colors.green.shade600;
      case AdviceType.slowDown:
        return Colors.orange.shade600;
      case AdviceType.critical:
        return Colors.red.shade600;
    }
  }

  IconData get icon {
    switch (type) {
      case AdviceType.speedUp:
        return Icons.arrow_upward;
      case AdviceType.slowDown:
        return Icons.arrow_downward;
      case AdviceType.critical:
        return Icons.warning;
    }
  }
}
