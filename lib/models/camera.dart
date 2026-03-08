class Camera {
  final int id;
  final double lat;
  final double lon;
  final int speedLimit;
  final String type; // 'speed', 'redlight', 'average', 'mobile'
  final String? direction;

  Camera({
    required this.id,
    required this.lat,
    required this.lon,
    required this.speedLimit,
    required this.type,
    this.direction,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      id: json['id'] as int,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      speedLimit: json['speed_limit'] as int,
      type: json['type'] as String,
      direction: json['direction'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lon': lon,
      'speed_limit': speedLimit,
      'type': type,
      'direction': direction,
    };
  }

  // Расстояние до камеры в метрах
  double distanceTo(double currentLat, double currentLon) {
    const double earthRadius = 6371000; // метры
    
    final dLat = _toRadians(lat - currentLat);
    final dLon = _toRadians(lon - currentLon);
    
    final a = 
        (dLat / 2).sin * (dLat / 2).sin +
        _toRadians(currentLat).cos * _toRadians(lat).cos *
        (dLon / 2).sin * (dLon / 2).sin;
    
    final c = 2 * (a.sqrt.atan2((1 - a).sqrt));
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * 3.14159265359 / 180.0;
  }
}
