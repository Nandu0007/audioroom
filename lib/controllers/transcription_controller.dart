import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum TranscriptionLanguage {
  english,
  spanish,
  french,
  german,
  italian,
  portuguese,
  russian,
  chinese,
  japanese,
  korean,
  arabic,
  hindi,
}

class TranscriptionMessage {
  final String id;
  final String text;
  final String speaker;
  final TranscriptionLanguage originalLanguage;
  final DateTime timestamp;
  final double confidence;
  final bool isFinal;
  final Map<TranscriptionLanguage, String> translations;

  TranscriptionMessage({
    required this.id,
    required this.text,
    required this.speaker,
    required this.originalLanguage,
    required this.timestamp,
    required this.confidence,
    this.isFinal = false,
    this.translations = const {},
  });

  TranscriptionMessage copyWith({
    String? text,
    bool? isFinal,
    double? confidence,
    Map<TranscriptionLanguage, String>? translations,
  }) {
    return TranscriptionMessage(
      id: this.id,
      text: text ?? this.text,
      speaker: this.speaker,
      originalLanguage: this.originalLanguage,
      timestamp: this.timestamp,
      confidence: confidence ?? this.confidence,
      isFinal: isFinal ?? this.isFinal,
      translations: translations ?? this.translations,
    );
  }
}

class TranscriptionController extends GetxController {
  var isTranscriptionEnabled = false.obs;
  var isTranslationEnabled = false.obs;
  var currentLanguage = TranscriptionLanguage.english.obs;
  var targetLanguage = TranscriptionLanguage.spanish.obs;
  var isListening = false.obs;
  var transcriptionMessages = <TranscriptionMessage>[].obs;
  var isAutoScrollEnabled = true.obs;
  var showTimestamps = true.obs;
  var showConfidenceScores = false.obs;
  var minConfidenceThreshold = 0.7.obs;

  // Statistics
  var totalWordsTranscribed = 0.obs;
  var averageConfidence = 0.0.obs;
  var sessionDuration = Duration.zero.obs;
  var languageDetectionAccuracy = 0.95.obs;

  void toggleTranscription() {
    isTranscriptionEnabled.value = !isTranscriptionEnabled.value;
    
    if (isTranscriptionEnabled.value) {
      startListening();
    } else {
      stopListening();
    }
  }

  void toggleTranslation() {
    isTranslationEnabled.value = !isTranslationEnabled.value;
    
    if (isTranslationEnabled.value && transcriptionMessages.isNotEmpty) {
      _translateExistingMessages();
    }
  }

  void startListening() {
    isListening.value = true;
    
    // Simulate real-time transcription
    _simulateTranscription();
    
    Get.snackbar(
      'Transcription Started',
      'Listening for speech in ${getLanguageDisplayName(currentLanguage.value)}',
      backgroundColor: Color(0xFF03DAC6),
      colorText: Colors.black,
    );
  }

  void stopListening() {
    isListening.value = false;
    
    Get.snackbar(
      'Transcription Stopped',
      'Speech recognition has been paused',
      backgroundColor: Color(0xFF1976D2),
      colorText: Colors.white,
    );
  }

  void setTranscriptionLanguage(TranscriptionLanguage language) {
    currentLanguage.value = language;
    
    if (isListening.value) {
      // Restart with new language
      stopListening();
      Future.delayed(Duration(milliseconds: 500), () {
        startListening();
      });
    }
  }

  void setTargetLanguage(TranscriptionLanguage language) {
    targetLanguage.value = language;
    
    if (isTranslationEnabled.value) {
      _translateExistingMessages();
    }
  }

  void clearTranscriptions() {
    transcriptionMessages.clear();
    totalWordsTranscribed.value = 0;
    averageConfidence.value = 0.0;
  }

  void exportTranscription() {
    if (transcriptionMessages.isEmpty) {
      Get.snackbar(
        'No Content',
        'No transcription to export',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Simulate export
    final exportText = _generateExportText();
    
    Get.defaultDialog(
      title: 'Export Transcription',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Export ${transcriptionMessages.length} messages?'),
          SizedBox(height: 16),
          Text(
            'Total words: ${totalWordsTranscribed.value}',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      textConfirm: 'Export',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'Exported',
          'Transcription exported successfully',
          backgroundColor: Color(0xFF03DAC6),
          colorText: Colors.black,
        );
      },
    );
  }

  void _simulateTranscription() {
    if (!isListening.value) return;

    final sampleTexts = [
      'Hello everyone, welcome to our meeting today.',
      'Can everyone hear me clearly?',
      'Let me share my screen to show the presentation.',
      'That sounds like a great idea for our project.',
      'I agree with the previous speaker.',
      'Could you please repeat that last point?',
      'Thank you for your attention.',
      'Any questions before we proceed?',
    ];

    final speakers = ['Alice', 'Bob', 'Charlie', 'Diana', 'You'];

    Future.delayed(Duration(seconds: 2), () {
      if (isListening.value) {
        final randomText = sampleTexts[DateTime.now().millisecond % sampleTexts.length];
        final randomSpeaker = speakers[DateTime.now().millisecond % speakers.length];
        
        _addTranscriptionMessage(randomText, randomSpeaker);
        
        // Continue simulation
        _simulateTranscription();
      }
    });
  }

  void _addTranscriptionMessage(String text, String speaker) {
    final confidence = 0.7 + (DateTime.now().millisecond % 30) / 100;
    
    final message = TranscriptionMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      speaker: speaker,
      originalLanguage: currentLanguage.value,
      timestamp: DateTime.now(),
      confidence: confidence,
      isFinal: true,
    );

    transcriptionMessages.add(message);
    
    // Update statistics
    totalWordsTranscribed.value += text.split(' ').length;
    _updateAverageConfidence();

    // Auto-translate if enabled
    if (isTranslationEnabled.value) {
      _translateMessage(message);
    }
  }

  void _translateMessage(TranscriptionMessage message) {
    // Simulate translation
    final translations = <TranscriptionLanguage, String>{};
    
    final sampleTranslations = {
      'Hello everyone, welcome to our meeting today.': {
        TranscriptionLanguage.spanish: 'Hola a todos, bienvenidos a nuestra reunión de hoy.',
        TranscriptionLanguage.french: 'Bonjour tout le monde, bienvenue à notre réunion d\'aujourd\'hui.',
        TranscriptionLanguage.german: 'Hallo alle zusammen, willkommen zu unserem heutigen Meeting.',
      },
      'Can everyone hear me clearly?': {
        TranscriptionLanguage.spanish: '¿Pueden todos escucharme claramente?',
        TranscriptionLanguage.french: 'Est-ce que tout le monde m\'entend clairement?',
        TranscriptionLanguage.german: 'Können mich alle klar hören?',
      },
    };

    if (sampleTranslations.containsKey(message.text)) {
      final messageTranslations = sampleTranslations[message.text]!;
      if (messageTranslations.containsKey(targetLanguage.value)) {
        translations[targetLanguage.value] = messageTranslations[targetLanguage.value]!;
      }
    } else {
      // Generic translation for demo
      translations[targetLanguage.value] = '[${getLanguageDisplayName(targetLanguage.value)}] ${message.text}';
    }

    final updatedMessage = message.copyWith(translations: translations);
    final index = transcriptionMessages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      transcriptionMessages[index] = updatedMessage;
    }
  }

  void _translateExistingMessages() {
    for (final message in transcriptionMessages) {
      _translateMessage(message);
    }
  }

  void _updateAverageConfidence() {
    if (transcriptionMessages.isEmpty) return;
    
    final totalConfidence = transcriptionMessages
        .map((m) => m.confidence)
        .reduce((a, b) => a + b);
    
    averageConfidence.value = totalConfidence / transcriptionMessages.length;
  }

  String _generateExportText() {
    final buffer = StringBuffer();
    buffer.writeln('AudioRoom Transcription Export');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Language: ${getLanguageDisplayName(currentLanguage.value)}');
    buffer.writeln('Total Messages: ${transcriptionMessages.length}');
    buffer.writeln('Total Words: ${totalWordsTranscribed.value}');
    buffer.writeln('Average Confidence: ${(averageConfidence.value * 100).toStringAsFixed(1)}%');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (final message in transcriptionMessages) {
      buffer.writeln('[${_formatTimestamp(message.timestamp)}] ${message.speaker}:');
      buffer.writeln('${message.text}');
      
      if (isTranslationEnabled.value && message.translations.containsKey(targetLanguage.value)) {
        buffer.writeln('Translation (${getLanguageDisplayName(targetLanguage.value)}): ${message.translations[targetLanguage.value]}');
      }
      
      if (showConfidenceScores.value) {
        buffer.writeln('Confidence: ${(message.confidence * 100).toStringAsFixed(1)}%');
      }
      
      buffer.writeln();
    }

    return buffer.toString();
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }

  String getLanguageDisplayName(TranscriptionLanguage language) {
    switch (language) {
      case TranscriptionLanguage.english:
        return 'English';
      case TranscriptionLanguage.spanish:
        return 'Spanish';
      case TranscriptionLanguage.french:
        return 'French';
      case TranscriptionLanguage.german:
        return 'German';
      case TranscriptionLanguage.italian:
        return 'Italian';
      case TranscriptionLanguage.portuguese:
        return 'Portuguese';
      case TranscriptionLanguage.russian:
        return 'Russian';
      case TranscriptionLanguage.chinese:
        return 'Chinese';
      case TranscriptionLanguage.japanese:
        return 'Japanese';
      case TranscriptionLanguage.korean:
        return 'Korean';
      case TranscriptionLanguage.arabic:
        return 'Arabic';
      case TranscriptionLanguage.hindi:
        return 'Hindi';
    }
  }

  String getLanguageFlag(TranscriptionLanguage language) {
    switch (language) {
      case TranscriptionLanguage.english:
        return '🇺🇸';
      case TranscriptionLanguage.spanish:
        return '🇪🇸';
      case TranscriptionLanguage.french:
        return '🇫🇷';
      case TranscriptionLanguage.german:
        return '🇩🇪';
      case TranscriptionLanguage.italian:
        return '🇮🇹';
      case TranscriptionLanguage.portuguese:
        return '🇵🇹';
      case TranscriptionLanguage.russian:
        return '🇷🇺';
      case TranscriptionLanguage.chinese:
        return '🇨🇳';
      case TranscriptionLanguage.japanese:
        return '🇯🇵';
      case TranscriptionLanguage.korean:
        return '🇰🇷';
      case TranscriptionLanguage.arabic:
        return '🇸🇦';
      case TranscriptionLanguage.hindi:
        return '🇮🇳';
    }
  }

  List<TranscriptionMessage> getFilteredMessages() {
    return transcriptionMessages
        .where((message) => message.confidence >= minConfidenceThreshold.value)
        .toList();
  }
}