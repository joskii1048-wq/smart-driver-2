import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          _buildGeneralSection(context),
          const Divider(),
          _buildConversationSection(context),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settings, _) {
        return ExpansionTile(
          title: const Text('⚙️ Общие настройки'),
          initiallyExpanded: true,
          children: [
            // Допустимое превышение
            ListTile(
              title: const Text('Допустимое превышение'),
              subtitle: Text('${settings.allowedExcess} км/ч'),
              trailing: SizedBox(
                width: 200,
                child: Slider(
                  value: settings.allowedExcess.toDouble(),
                  min: 0,
                  max: 30,
                  divisions: 6,
                  label: '${settings.allowedExcess} км/ч',
                  onChanged: (value) {
                    settings.setAllowedExcess(value.round());
                  },
                ),
              ),
            ),

            // Комфортное замедление
            ListTile(
              title: const Text('Комфортное замедление'),
              subtitle: Text('${settings.comfortableDeceleration.toStringAsFixed(1)} м/с²'),
              trailing: SizedBox(
                width: 200,
                child: Slider(
                  value: settings.comfortableDeceleration,
                  min: 1.0,
                  max: 4.0,
                  divisions: 6,
                  label: '${settings.comfortableDeceleration.toStringAsFixed(1)} м/с²',
                  onChanged: (value) {
                    settings.setComfortableDeceleration(value);
                  },
                ),
              ),
            ),

            // Голосовые подсказки
            SwitchListTile(
              title: const Text('Голосовые подсказки'),
              value: settings.voiceEnabled,
              onChanged: (value) {
                settings.setVoiceEnabled(value);
              },
            ),

            // Вибрация
            SwitchListTile(
              title: const Text('Вибрация'),
              value: settings.vibrationEnabled,
              onChanged: (value) {
                settings.setVibrationEnabled(value);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildConversationSection(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settings, _) {
        return ExpansionTile(
          title: const Text('💬 Умный собеседник'),
          initiallyExpanded: true,
          children: [
            // Включить собеседника
            SwitchListTile(
              title: const Text('Умный собеседник'),
              subtitle: const Text('Разговорные фразы и анекдоты'),
              value: settings.companionEnabled,
              onChanged: (value) {
                settings.setCompanionEnabled(value);
              },
            ),

            // Частота подсказок
            ListTile(
              title: const Text('Частота подсказок'),
              subtitle: Text(_getFrequencyLabel(settings.companionFrequencyMinutes)),
              trailing: DropdownButton<int>(
                value: settings.companionFrequencyMinutes,
                items: const [
                  DropdownMenuItem(value: 2, child: Text('Часто (2 мин)')),
                  DropdownMenuItem(value: 3, child: Text('Средне (3 мин)')),
                  DropdownMenuItem(value: 5, child: Text('Редко (5 мин)')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    settings.setCompanionFrequency(value);
                  }
                },
              ),
            ),

            // Анекдоты и истории
            SwitchListTile(
              title: const Text('Анекдоты и истории'),
              value: settings.jokesEnabled,
              onChanged: (value) {
                settings.setJokesEnabled(value);
              },
            ),
          ],
        );
      },
    );
  }

  String _getFrequencyLabel(int minutes) {
    switch (minutes) {
      case 2:
        return 'Часто (каждые 2 минуты)';
      case 3:
        return 'Средне (каждые 3 минуты)';
      case 5:
        return 'Редко (каждые 5 минут)';
      default:
        return '$minutes минут';
    }
  }
}
