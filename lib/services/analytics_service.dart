import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static Map<String, dynamic> _analytics = {};
  static const String _analyticsKey = 'room_analytics';

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_analyticsKey);
    if (data != null) {
      _analytics = json.decode(data);
    }
  }

  static Future<void> trackRoomJoin(String roomId, String userId) async {
    final key = 'room_$roomId';
    _analytics[key] ??= {'joins': 0, 'unique_users': <String>{}, 'peak_times': {}};
    _analytics[key]['joins']++;
    _analytics[key]['unique_users'].add(userId);
    
    final hour = DateTime.now().hour;
    _analytics[key]['peak_times'][hour.toString()] = 
        (_analytics[key]['peak_times'][hour.toString()] ?? 0) + 1;
    
    await _save();
  }

  static Future<void> trackSpeakingTime(String roomId, String userId, int minutes) async {
    final key = 'room_$roomId';
    _analytics[key] ??= {'speaking_time': {}, 'total_speaking': 0};
    _analytics[key]['speaking_time'][userId] = 
        (_analytics[key]['speaking_time'][userId] ?? 0) + minutes;
    _analytics[key]['total_speaking'] += minutes;
    
    await _save();
  }

  static RoomAnalytics getRoomAnalytics(String roomId) {
    final data = _analytics['room_$roomId'] ?? {};
    return RoomAnalytics(
      totalJoins: data['joins'] ?? 0,
      uniqueUsers: (data['unique_users'] as Set<String>?)?.length ?? 0,
      totalSpeakingTime: data['total_speaking'] ?? 0,
      peakHours: Map<int, int>.from(data['peak_times'] ?? {}),
      topSpeakers: _getTopSpeakers(data['speaking_time'] ?? {}),
    );
  }

  static List<String> _getTopSpeakers(Map<String, dynamic> speakingData) {
    final speakers = speakingData.entries.toList()
      ..sort((a, b) => (b.value as int).compareTo(a.value as int));
    return speakers.take(5).map((e) => e.key).toList();
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_analyticsKey, json.encode(_analytics));
  }
}

class RoomAnalytics {
  final int totalJoins;
  final int uniqueUsers;
  final int totalSpeakingTime;
  final Map<int, int> peakHours;
  final List<String> topSpeakers;

  RoomAnalytics({
    required this.totalJoins,
    required this.uniqueUsers,
    required this.totalSpeakingTime,
    required this.peakHours,
    required this.topSpeakers,
  });
}