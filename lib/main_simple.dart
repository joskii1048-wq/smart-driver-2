import 'package:flutter/material.dart';

void main() {
  runApp(const SmartDriverApp());
}

class SmartDriverApp extends StatelessWidget {
  const SmartDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Умный Водитель 2.0',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _speed = 0;
  bool _companionEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Умный Водитель 2.0'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ДЕМО ВЕРСИЯ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Text(
              '$_speed',
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            const Text(
              'км/ч',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _speed = (_speed + 10) % 150;
                });
              },
              child: const Text('+ 10 км/ч'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _companionEnabled = !_companionEnabled;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_companionEnabled 
                      ? '🗣️ Собеседник включен!' 
                      : 'Собеседник выключен'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _companionEnabled ? Colors.green : Colors.grey,
              ),
              child: const Text('🗣️ Собеседник'),
            ),
            const SizedBox(height: 40),
            const Text(
              'Для полной версии используйте Codemagic:\nhttps://codemagic.io',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
