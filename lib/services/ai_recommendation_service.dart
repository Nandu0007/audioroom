import 'dart:math';
import 'package:audioroom/models/enhanced_room.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIRecommendationService {
  static const String _userPrefsKey = 'user_preferences';
  static const String _roomHistoryKey = 'room_history';
  static const String _interactionScoreKey = 'interaction_scores';

  // User interest categories with weights
  static Map<RoomCategory, double> _userInterestWeights = {};
  static List<String> _joinedRoomsHistory = [];
  static Map<String, double> _roomInteractionScores = {};

  /// Initialize the recommendation system
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load user preferences
    final prefsString = prefs.getString(_userPrefsKey);
    if (prefsString != null) {
      // Parse and load saved preferences
      _loadUserPreferences(prefsString);
    } else {
      // Initialize with default preferences
      _initializeDefaultPreferences();
    }
    
    // Load room history
    _joinedRoomsHistory = prefs.getStringList(_roomHistoryKey) ?? [];
    
    // Load interaction scores
    final scoresString = prefs.getString(_interactionScoreKey);
    if (scoresString != null) {
      _loadInteractionScores(scoresString);
    }
  }

  /// Track when user joins a room
  static Future<void> trackRoomJoin(EnhancedRoom room) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Add to history
    _joinedRoomsHistory.add(room.id);
    if (_joinedRoomsHistory.length > 50) {
      _joinedRoomsHistory.removeAt(0); // Keep only last 50
    }
    
    // Update category interest
    _userInterestWeights[room.category] = 
        (_userInterestWeights[room.category] ?? 0.0) + 0.1;
    
    // Update room interaction score
    _roomInteractionScores[room.id] = 
        (_roomInteractionScores[room.id] ?? 0.0) + 1.0;
    
    // Save preferences
    await _saveUserPreferences(prefs);
    await prefs.setStringList(_roomHistoryKey, _joinedRoomsHistory);
  }

  /// Track user engagement in room
  static Future<void> trackEngagement(String roomId, double engagementScore) async {
    final prefs = await SharedPreferences.getInstance();
    
    _roomInteractionScores[roomId] = 
        (_roomInteractionScores[roomId] ?? 0.0) + engagementScore;
    
    await _saveUserPreferences(prefs);
  }

  /// Get personalized room recommendations
  static List<EnhancedRoom> getRecommendations(
    List<EnhancedRoom> allRooms, 
    {int maxRecommendations = 10}
  ) {
    List<RoomRecommendation> scored = [];
    
    for (final room in allRooms) {
      double score = _calculateRoomScore(room);
      scored.add(RoomRecommendation(room, score));
    }
    
    // Sort by score and return top recommendations
    scored.sort((a, b) => b.score.compareTo(a.score));
    
    return scored
        .take(maxRecommendations)
        .map((r) => r.room)
        .toList();
  }

  /// Calculate recommendation score for a room
  static double _calculateRoomScore(EnhancedRoom room) {
    double score = 0.0;
    
    // Category interest weight (40% of score)
    double categoryWeight = _userInterestWeights[room.category] ?? 0.0;
    score += categoryWeight * 0.4;
    
    // Activity level (30% of score)
    double activityScore = _calculateActivityScore(room);
    score += activityScore * 0.3;
    
    // Novelty factor (20% of score)
    double noveltyScore = _calculateNoveltyScore(room);
    score += noveltyScore * 0.2;
    
    // Time-based factors (10% of score)
    double timeScore = _calculateTimeScore(room);
    score += timeScore * 0.1;
    
    return score;
  }

  /// Calculate activity-based score
  static double _calculateActivityScore(EnhancedRoom room) {
    // Higher score for moderately active rooms
    if (room.totalParticipants == 0) return 0.0;
    if (room.totalParticipants <= 5) return 0.3;
    if (room.totalParticipants <= 15) return 1.0;
    if (room.totalParticipants <= 30) return 0.8;
    return 0.5; // Very crowded rooms get lower score
  }

  /// Calculate novelty score (prefer new experiences)
  static double _calculateNoveltyScore(EnhancedRoom room) {
    if (_joinedRoomsHistory.contains(room.id)) {
      // Previously joined room
      double interactionScore = _roomInteractionScores[room.id] ?? 0.0;
      return interactionScore > 5.0 ? 0.8 : 0.3; // High interaction = still interesting
    }
    return 1.0; // New room = high novelty
  }

  /// Calculate time-based score
  static double _calculateTimeScore(EnhancedRoom room) {
    final now = DateTime.now();
    final hourOfDay = now.hour;
    
    // Boost certain categories at specific times
    switch (room.category) {
      case RoomCategory.music:
        return (hourOfDay >= 18 && hourOfDay <= 23) ? 1.0 : 0.5; // Evening boost
      case RoomCategory.education:
        return (hourOfDay >= 9 && hourOfDay <= 17) ? 1.0 : 0.3; // Daytime boost
      case RoomCategory.entertainment:
        return (hourOfDay >= 19 && hourOfDay <= 24) ? 1.0 : 0.6; // Night boost
      default:
        return 0.7;
    }
  }

  /// Get trending rooms based on recent activity
  static List<EnhancedRoom> getTrendingRooms(List<EnhancedRoom> allRooms) {
    return allRooms.where((room) => 
        room.isActive && 
        room.totalParticipants > 3 &&
        DateTime.now().difference(room.lastActiveAt).inHours < 2
      ).toList()..sort((a, b) => b.totalParticipants.compareTo(a.totalParticipants));
  }

  /// Get rooms similar to a given room
  static List<EnhancedRoom> getSimilarRooms(
    EnhancedRoom targetRoom, 
    List<EnhancedRoom> allRooms
  ) {
    return allRooms.where((room) => 
        room.id != targetRoom.id &&
        (room.category == targetRoom.category ||
         room.tags.any((tag) => targetRoom.tags.contains(tag)))
      ).toList();
  }

  // Helper methods
  static void _initializeDefaultPreferences() {
    for (final category in RoomCategory.values) {
      _userInterestWeights[category] = 0.5; // Neutral starting point
    }
  }

  static void _loadUserPreferences(String prefsString) {
    // Implementation for loading preferences from string
    // This would parse the saved JSON data
  }

  static void _loadInteractionScores(String scoresString) {
    // Implementation for loading interaction scores
  }

  static Future<void> _saveUserPreferences(SharedPreferences prefs) async {
    // Implementation for saving preferences as JSON
    final prefsData = _userInterestWeights.map(
      (key, value) => MapEntry(key.toString(), value)
    );
    // Save as JSON string
  }
}

class RoomRecommendation {
  final EnhancedRoom room;
  final double score;

  RoomRecommendation(this.room, this.score);
}

/// Smart search suggestions based on user behavior
class SmartSearchSuggestions {
  static List<String> getSearchSuggestions() {
    List<String> suggestions = [];
    
    // Add category-based suggestions
    final topCategories = AIRecommendationService._userInterestWeights.entries
        .where((entry) => entry.value > 0.7)
        .map((entry) => entry.key.toString().split('.').last)
        .toList();
    
    suggestions.addAll(topCategories);
    
    // Add trending topics
    suggestions.addAll([
      'trending now',
      'music discussion',
      'tech talk',
      'study group',
      'gaming chat',
      'language practice',
    ]);
    
    return suggestions.take(8).toList();
  }
}