import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class TranslationService {
  static const String _apiKey = 'YOUR_GOOGLE_TRANSLATE_API_KEY';
  static const String _baseUrl = 'https://translation.googleapis.com/language/translate/v2';
  static String _userLanguage = 'en';
  static bool _autoTranslate = false;
  static Map<String, String> _languageCache = {};

  static final Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'ja': 'Japanese',
    'ko': 'Korean',
    'zh': 'Chinese',
    'ar': 'Arabic',
    'hi': 'Hindi',
    'tr': 'Turkish',
    'pl': 'Polish',
    'nl': 'Dutch',
    'sv': 'Swedish',
    'da': 'Danish',
    'no': 'Norwegian',
    'fi': 'Finnish',
    'th': 'Thai',
    'vi': 'Vietnamese',
    'id': 'Indonesian',
    'ms': 'Malay',
    'tl': 'Filipino',
    'he': 'Hebrew',
    'cs': 'Czech',
    'sk': 'Slovak',
    'hu': 'Hungarian',
    'ro': 'Romanian',
    'bg': 'Bulgarian',
    'hr': 'Croatian',
    'sl': 'Slovenian',
    'et': 'Estonian',
    'lv': 'Latvian',
    'lt': 'Lithuanian',
    'mt': 'Maltese',
    'cy': 'Welsh',
    'ga': 'Irish',
    'is': 'Icelandic',
    'mk': 'Macedonian',
    'sq': 'Albanian',
    'eu': 'Basque',
    'ca': 'Catalan',
    'gl': 'Galician',
    'af': 'Afrikaans',
    'sw': 'Swahili',
    'am': 'Amharic',
    'bn': 'Bengali',
    'gu': 'Gujarati',
    'kn': 'Kannada',
    'ml': 'Malayalam',
    'mr': 'Marathi',
    'ne': 'Nepali',
    'or': 'Odia',
    'pa': 'Punjabi',
    'si': 'Sinhala',
    'ta': 'Tamil',
    'te': 'Telugu',
    'ur': 'Urdu',
    'my': 'Myanmar',
    'km': 'Khmer',
    'lo': 'Lao',
    'ka': 'Georgian',
    'hy': 'Armenian',
    'az': 'Azerbaijani',
    'be': 'Belarusian',
    'kk': 'Kazakh',
    'ky': 'Kyrgyz',
    'mn': 'Mongolian',
    'tg': 'Tajik',
    'tk': 'Turkmen',
    'uz': 'Uzbek',
    'uk': 'Ukrainian',
  };

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _userLanguage = prefs.getString('user_language') ?? 'en';
    _autoTranslate = prefs.getBool('auto_translate') ?? false;
  }

  static Future<void> setUserLanguage(String languageCode) async {
    _userLanguage = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_language', languageCode);
  }

  static Future<void> setAutoTranslate(bool enabled) async {
    _autoTranslate = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_translate', enabled);
  }

  static String get userLanguage => _userLanguage;
  static bool get autoTranslateEnabled => _autoTranslate;

  /// Translate text to target language
  static Future<String> translateText(String text, String targetLanguage, {String? sourceLanguage}) async {
    if (text.isEmpty) return text;
    
    final cacheKey = '${sourceLanguage ?? 'auto'}_${targetLanguage}_$text';
    if (_languageCache.containsKey(cacheKey)) {
      return _languageCache[cacheKey]!;
    }

    try {
      final url = Uri.parse(_baseUrl);
      final body = {
        'q': text,
        'target': targetLanguage,
        'key': _apiKey,
      };
      
      if (sourceLanguage != null) {
        body['source'] = sourceLanguage;
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translatedText = data['data']['translations'][0]['translatedText'];
        _languageCache[cacheKey] = translatedText;
        return translatedText;
      }
    } catch (e) {
      print('Translation error: $e');
    }
    
    return text; // Return original if translation fails
  }

  /// Detect language of text
  static Future<String?> detectLanguage(String text) async {
    try {
      final url = Uri.parse('https://translation.googleapis.com/language/translate/v2/detect');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'q': text,
          'key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['detections'][0][0]['language'];
      }
    } catch (e) {
      print('Language detection error: $e');
    }
    return null;
  }

  /// Auto-translate message if needed
  static Future<ChatMessage> processMessage(ChatMessage message) async {
    if (!_autoTranslate || message.language == _userLanguage) {
      return message;
    }

    final translatedText = await translateText(
      message.text,
      _userLanguage,
      sourceLanguage: message.language,
    );

    return ChatMessage(
      id: message.id,
      userId: message.userId,
      username: message.username,
      text: translatedText,
      originalText: message.text,
      language: _userLanguage,
      originalLanguage: message.language,
      timestamp: message.timestamp,
      isTranslated: true,
    );
  }

  /// Get language name from code
  static String getLanguageName(String languageCode) {
    return supportedLanguages[languageCode] ?? languageCode.toUpperCase();
  }

  /// Get language flag emoji
  static String getLanguageFlag(String languageCode) {
    const flagMap = {
      'en': '🇺🇸', 'es': '🇪🇸', 'fr': '🇫🇷', 'de': '🇩🇪', 'it': '🇮🇹',
      'pt': '🇵🇹', 'ru': '🇷🇺', 'ja': '🇯🇵', 'ko': '🇰🇷', 'zh': '🇨🇳',
      'ar': '🇸🇦', 'hi': '🇮🇳', 'tr': '🇹🇷', 'pl': '🇵🇱', 'nl': '🇳🇱',
      'sv': '🇸🇪', 'da': '🇩🇰', 'no': '🇳🇴', 'fi': '🇫🇮', 'th': '🇹🇭',
    };
    return flagMap[languageCode] ?? '🌐';
  }

  /// Clear translation cache
  static void clearCache() {
    _languageCache.clear();
  }
}

class ChatMessage {
  final String id;
  final String userId;
  final String username;
  final String text;
  final String? originalText;
  final String language;
  final String? originalLanguage;
  final DateTime timestamp;
  final bool isTranslated;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    this.originalText,
    this.language = 'en',
    this.originalLanguage,
    required this.timestamp,
    this.isTranslated = false,
  });
}