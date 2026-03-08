import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class GPSService extends ChangeNotifier {
  double _currentSpeed = 0.0; // м/с
  double _currentLat = 0.0;
  double _currentLon = 0.0;
  bool _isTracking = false;
  StreamSubscription<Position>? _positionStream;

  double get currentSpeed => _currentSpeed * 3.6; // км/ч
  double get currentLat => _currentLat;
  double get currentLon => _currentLon;
  bool get isTracking => _isTracking;

  Future<void> startTracking() async {
    // Проверка разрешений
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('GPS отключён');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Нет разрешения на GPS');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Разрешение GPS заблокировано навсегда');
    }

    // Настройки GPS (высокая точность)
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // метры
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _currentSpeed = position.speed;
      _currentLat = position.latitude;
      _currentLon = position.longitude;
      notifyListeners();
    });

    _isTracking = true;
    notifyListeners();
  }

  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    _isTracking = false;
    _currentSpeed = 0.0;
    notifyListeners();
  }

  // Для демо-режима (симуляция скорости)
  void setDemoSpeed(double speedKmh) {
    _currentSpeed = speedKmh / 3.6; // конвертируем в м/с
    notifyListeners();
  }

  void setDemoPosition(double lat, double lon) {
    _currentLat = lat;
    _currentLon = lon;
    notifyListeners();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
