import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/speed_advice.dart';

enum PhrasePriority {
  critical,      // 1 - Превышение (прерывает всё)
  warning,       // 2 - Снижение скорости (прерывает беседу)
  info,          // 3 - Разгон/проезд (не прерывает)
  conversation,  // 4 - Анекдоты/советы (только когда тихо)
}

class ConversationPhrase {
  final String text;
  final PhrasePriority priority;
  final String category; // 'navigation', 'joke', 'story', 'tip', 'greeting', 'encouragement'

  ConversationPhrase({
    required this.text,
    required this.priority,
    required this.category,
  });
}

class ConversationService extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();
  List<ConversationPhrase> _phrasePool = [];
  bool _isInitialized = false;
  bool _isSpeaking = false;
  Timer? _conversationTimer;
  DateTime? _lastConversationTime;
  int _drivingMinutes = 0;
  Timer? _fatigueTimer;

  bool get isInitialized => _isInitialized;
  bool get isSpeaking => _isSpeaking;
  int get drivingMinutes => _drivingMinutes;

  ConversationService() {
    _initializeTTS();
    _loadPhrases();
    _startFatigueTimer();
  }

  Future<void> _initializeTTS() async {
    await _tts.setLanguage('ru-RU');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      _isSpeaking = true;
      notifyListeners();
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      notifyListeners();
    });

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadPhrases() async {
    try {
      // Загружаем из assets/jokes.json
      final String response = await rootBundle.loadString('assets/jokes.json');
      final Map<String, dynamic> data = json.decode(response);

      // Приветствия
      for (var text in (data['greetings'] as List<dynamic>)) {
        _phrasePool.add(ConversationPhrase(
          text: text as String,
          priority: PhrasePriority.conversation,
          category: 'greeting',
        ));
      }

      // Анекдоты
      for (var text in (data['jokes'] as List<dynamic>)) {
        _phrasePool.add(ConversationPhrase(
          text: text as String,
          priority: PhrasePriority.conversation,
          category: 'joke',
        ));
      }

      // Истории
      for (var text in (data['stories'] as List<dynamic>)) {
        _phrasePool.add(ConversationPhrase(
          text: text as String,
          priority: PhrasePriority.conversation,
          category: 'story',
        ));
      }

      // Советы
      for (var text in (data['tips'] as List<dynamic>)) {
        _phrasePool.add(ConversationPhrase(
          text: text as String,
          priority: PhrasePriority.conversation,
          category: 'tip',
        ));
      }

      // Подбадривание
      for (var text in (data['encouragements'] as List<dynamic>)) {
        _phrasePool.add(ConversationPhrase(
          text: text as String,
          priority: PhrasePriority.conversation,
          category: 'encouragement',
        ));
      }

      debugPrint('Загружено фраз: ${_phrasePool.length}');
    } catch (e) {
      debugPrint('Ошибка загрузки фраз: $e');
      _loadFallbackPhrases();
    }
  }

  void _loadFallbackPhrases() {
    // Резервные фразы на случай ошибки
    _phrasePool = [
      ConversationPhrase(
        text: 'Привет, я твой умный собеседник!',
        priority: PhrasePriority.conversation,
        category: 'greeting',
      ),
      ConversationPhrase(
        text: 'Держи дистанцию и будь внимателен!',
        priority: PhrasePriority.conversation,
        category: 'tip',
      ),
    ];
  }

  void _startFatigueTimer() {
    _fatigueTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _drivingMinutes++;
      notifyListeners();
    });
  }

  Future<void> speak(String text, {PhrasePriority priority = PhrasePriority.info}) async {
    if (!_isInitialized) return;

    // Если критический приоритет — прерываем текущую речь
    if (priority == PhrasePriority.critical && _isSpeaking) {
      await _tts.stop();
    }

    // Если обычная беседа — не прерываем навигационные фразы
    if (priority == PhrasePriority.conversation && _isSpeaking) {
      return;
    }

    await _tts.speak(text);
  }

  Future<void> speakAdvice(AdviceType type, String message) async {
    PhrasePriority priority;
    switch (type) {
      case AdviceType.critical:
        priority = PhrasePriority.critical;
        break;
      case AdviceType.slowDown:
        priority = PhrasePriority.warning;
        break;
      case AdviceType.speedUp:
        priority = PhrasePriority.info;
        break;
    }

    await speak(message, priority: priority);
  }

  void startConversation(int frequencyMinutes) {
    _conversationTimer?.cancel();
    _conversationTimer = Timer.periodic(
      Duration(minutes: frequencyMinutes),
      (timer) => _speakRandomPhrase(),
    );
  }

  void stopConversation() {
    _conversationTimer?.cancel();
  }

  Future<void> _speakRandomPhrase() async {
    if (_isSpeaking) return;

    // Проверка усталости (каждые 2 часа)
    if (_drivingMinutes > 0 && _drivingMinutes % 120 == 0) {
      await speak(
        'Давно ты за рулём? Я тут посчитал – уже ${_drivingMinutes ~/ 60} часа в пути. Может, остановишься передохнуть?',
        priority: PhrasePriority.conversation,
      );
      return;
    }

    // Выбираем случайную фразу категории conversation
    final conversationPhrases = _phrasePool
        .where((p) => p.priority == PhrasePriority.conversation)
        .toList();

    if (conversationPhrases.isEmpty) return;

    final random = Random();
    final phrase = conversationPhrases[random.nextInt(conversationPhrases.length)];

    await speak(phrase.text, priority: PhrasePriority.conversation);
  }

  Future<void> speakGreeting() async {
    final greetings = _phrasePool
        .where((p) => p.category == 'greeting')
        .toList();

    if (greetings.isNotEmpty) {
      final random = Random();
      final greeting = greetings[random.nextInt(greetings.length)];
      await speak(greeting.text, priority: PhrasePriority.conversation);
    }
  }

  @override
  void dispose() {
    _conversationTimer?.cancel();
    _fatigueTimer?.cancel();
    _tts.stop();
    super.dispose();
  }
}
