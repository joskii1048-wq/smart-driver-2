import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/camera.dart';

class CameraService extends ChangeNotifier {
  List<Camera> _cameras = [];
  Camera? _nearestCamera;
  double _distanceToNearest = 0.0;

  List<Camera> get cameras => _cameras;
  Camera? get nearestCamera => _nearestCamera;
  double get distanceToNearest => _distanceToNearest;

  CameraService() {
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    try {
      // Загружаем из assets/cameras.json
      final String response = await rootBundle.loadString('assets/cameras.json');
      final List<dynamic> data = json.decode(response);
      _cameras = data.map((json) => Camera.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка загрузки камер: $e');
      // Загружаем тестовые камеры
      _loadTestCameras();
    }
  }

  void _loadTestCameras() {
    // Тестовые камеры на маршруте Тутаев → Москва
    _cameras = [
      Camera(
        id: 1,
        lat: 57.8724,
        lon: 39.5339,
        speedLimit: 60,
        type: 'speed',
        direction: 'south',
      ),
      Camera(
        id: 2,
        lat: 57.6264,
        lon: 39.8939,
        speedLimit: 90,
        type: 'speed',
        direction: 'south',
      ),
      Camera(
        id: 3,
        lat: 57.1867,
        lon: 39.4108,
        speedLimit: 90,
        type: 'speed',
        direction: 'south',
      ),
    ];
    notifyListeners();
  }

  void updateNearestCamera(double currentLat, double currentLon) {
    if (_cameras.isEmpty) return;

    Camera? nearest;
    double minDistance = double.infinity;

    for (var camera in _cameras) {
      final distance = camera.distanceTo(currentLat, currentLon);
      if (distance < minDistance && distance < 5000) { // в радиусе 5 км
        minDistance = distance;
        nearest = camera;
      }
    }

    if (nearest != _nearestCamera || minDistance != _distanceToNearest) {
      _nearestCamera = nearest;
      _distanceToNearest = minDistance;
      notifyListeners();
    }
  }

  // Для демо-режима (добавление тестовых камер)
  void addTestCamera(Camera camera) {
    _cameras.add(camera);
    notifyListeners();
  }
}
