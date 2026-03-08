import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/gps_service.dart';
import '../services/camera_service.dart';
import '../services/speed_advisor_service.dart';
import '../services/conversation_service.dart';
import '../services/settings_service.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Запускаем GPS при старте
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGPS();
    });
  }

  Future<void> _startGPS() async {
    final gps = Provider.of<GPSService>(context, listen: false);
    final settings = Provider.of<SettingsService>(context, listen: false);

    try {
      if (!settings.demoMode) {
        await gps.startTracking();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка GPS: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Умный Водитель 2.0'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Панель скорости
          _buildSpeedPanel(),
          
          // Панель советника
          Expanded(child: _buildAdvisorPanel()),
          
          // Нижние кнопки
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildSpeedPanel() {
    return Consumer<GPSService>(
      builder: (context, gps, _) {
        final speed = gps.currentSpeed.round();
        return Container(
          padding: const EdgeInsets.all(24),
          color: Colors.blue.shade700,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    '$speed',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'км/ч',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdvisorPanel() {
    return Consumer4<GPSService, CameraService, SpeedAdvisorService, SettingsService>(
      builder: (context, gps, cameras, advisor, settings, _) {
        // Обновляем ближайшую камеру
        cameras.updateNearestCamera(gps.currentLat, gps.currentLon);

        // Рассчитываем совет
        final advice = advisor.calculateAdvice(
          currentSpeedKmh: gps.currentSpeed,
          nearestCamera: cameras.nearestCamera,
          distanceToCamera: cameras.distanceToNearest,
          allowedExcess: settings.allowedExcess,
          deceleration: settings.comfortableDeceleration,
          mode100: settings.mode100,
        );

        if (advice == null) {
          return const Center(
            child: Text(
              'Нет камер поблизости\nЕдьте безопасно!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Container(
          color: advice.panelColor,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                advice.icon,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                advice.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              if (cameras.nearestCamera != null) ...[
                Text(
                  'Камера через ${cameras.distanceToNearest.round()} м',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Ограничение: ${cameras.nearestCamera!.speedLimit} км/ч',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Consumer2<ConversationService, SettingsService>(
      builder: (context, conversation, settings, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Кнопка "Собеседник"
              ElevatedButton.icon(
                onPressed: () async {
                  final newValue = !settings.companionEnabled;
                  await settings.setCompanionEnabled(newValue);
                  
                  if (newValue) {
                    conversation.speakGreeting();
                    conversation.startConversation(settings.companionFrequencyMinutes);
                  } else {
                    conversation.stopConversation();
                  }
                },
                icon: const Icon(Icons.chat),
                label: const Text('Собеседник'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: settings.companionEnabled 
                      ? Colors.green 
                      : Colors.grey,
                ),
              ),

              // Кнопка "100 км/ч"
              ElevatedButton.icon(
                onPressed: () {
                  settings.setMode100(!settings.mode100);
                },
                icon: const Icon(Icons.speed),
                label: const Text('100 км/ч'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: settings.mode100 
                      ? Colors.red 
                      : Colors.grey,
                ),
              ),

              // Кнопка "Демо"
              ElevatedButton.icon(
                onPressed: () {
                  settings.setDemoMode(!settings.demoMode);
                  if (settings.demoMode) {
                    _startDemo();
                  }
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Демо'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: settings.demoMode 
                      ? Colors.orange 
                      : Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _startDemo() {
    // Симуляция движения со скоростью 120 км/ч
    final gps = Provider.of<GPSService>(context, listen: false);
    gps.setDemoSpeed(120);
    gps.setDemoPosition(57.8724, 39.5339); // Тутаев
  }
}
