import 'package:flutter/material.dart';

enum RoomType {
  public,
  private,
  scheduled,
  moderated,
}

enum UserRole {
  owner,
  admin,
  moderator,
  speaker,
  listener,
}

enum RoomCategory {
  general,
  music,
  education,
  business,
  gaming,
  technology,
  health,
  entertainment,
  news,
  language,
}

class EnhancedRoom {
  final String id;
  final String name;
  final String description;
  final RoomType type;
  final RoomCategory category;
  final String ownerId;
  final List<String> adminIds;
  final List<String> moderatorIds;
  final int maxParticipants;
  final bool isPasswordProtected;
  final String? password;
  final DateTime? scheduledTime;
  final int estimatedDuration; // in minutes
  final List<String> tags;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final int totalParticipants;
  final bool isRecordingEnabled;
  final bool isTranscriptionEnabled;
  final String? backgroundMusic;
  final String? roomImage;
  final Map<String, UserRole> participantRoles;
  final List<String> bannedUserIds;
  final bool allowScreenSharing;
  final bool allowReactions;
  final int speakingTimeLimit; // in minutes, 0 = no limit

  EnhancedRoom({
    required this.id,
    required this.name,
    required this.description,
    this.type = RoomType.public,
    this.category = RoomCategory.general,
    required this.ownerId,
    this.adminIds = const [],
    this.moderatorIds = const [],
    this.maxParticipants = 50,
    this.isPasswordProtected = false,
    this.password,
    this.scheduledTime,
    this.estimatedDuration = 60,
    this.tags = const [],
    this.settings = const {},
    required this.createdAt,
    required this.lastActiveAt,
    this.totalParticipants = 0,
    this.isRecordingEnabled = false,
    this.isTranscriptionEnabled = false,
    this.backgroundMusic,
    this.roomImage,
    this.participantRoles = const {},
    this.bannedUserIds = const [],
    this.allowScreenSharing = true,
    this.allowReactions = true,
    this.speakingTimeLimit = 0,
  });

  bool get isLive => scheduledTime == null || DateTime.now().isAfter(scheduledTime!);
  bool get isScheduled => scheduledTime != null && DateTime.now().isBefore(scheduledTime!);
  bool get isActive => totalParticipants > 0;
  
  String get categoryDisplayName {
    switch (category) {
      case RoomCategory.general:
        return 'General';
      case RoomCategory.music:
        return 'Music';
      case RoomCategory.education:
        return 'Education';
      case RoomCategory.business:
        return 'Business';
      case RoomCategory.gaming:
        return 'Gaming';
      case RoomCategory.technology:
        return 'Technology';
      case RoomCategory.health:
        return 'Health & Wellness';
      case RoomCategory.entertainment:
        return 'Entertainment';
      case RoomCategory.news:
        return 'News & Politics';
      case RoomCategory.language:
        return 'Language Learning';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case RoomCategory.general:
        return Icons.chat;
      case RoomCategory.music:
        return Icons.music_note;
      case RoomCategory.education:
        return Icons.school;
      case RoomCategory.business:
        return Icons.business;
      case RoomCategory.gaming:
        return Icons.sports_esports;
      case RoomCategory.technology:
        return Icons.computer;
      case RoomCategory.health:
        return Icons.favorite;
      case RoomCategory.entertainment:
        return Icons.movie;
      case RoomCategory.news:
        return Icons.newspaper;
      case RoomCategory.language:
        return Icons.translate;
    }
  }

  Color get categoryColor {
    switch (category) {
      case RoomCategory.general:
        return Colors.blue;
      case RoomCategory.music:
        return Colors.purple;
      case RoomCategory.education:
        return Colors.green;
      case RoomCategory.business:
        return Colors.orange;
      case RoomCategory.gaming:
        return Colors.red;
      case RoomCategory.technology:
        return Colors.indigo;
      case RoomCategory.health:
        return Colors.pink;
      case RoomCategory.entertainment:
        return Colors.amber;
      case RoomCategory.news:
        return Colors.teal;
      case RoomCategory.language:
        return Colors.cyan;
    }
  }

  String get typeDisplayName {
    switch (type) {
      case RoomType.public:
        return 'Public';
      case RoomType.private:
        return 'Private';
      case RoomType.scheduled:
        return 'Scheduled';
      case RoomType.moderated:
        return 'Moderated';
    }
  }

  bool canUserJoin(String userId) {
    if (bannedUserIds.contains(userId)) return false;
    if (type == RoomType.private && !_isAuthorized(userId)) return false;
    if (totalParticipants >= maxParticipants) return false;
    return true;
  }

  bool _isAuthorized(String userId) {
    return ownerId == userId || 
           adminIds.contains(userId) || 
           moderatorIds.contains(userId);
  }

  UserRole getUserRole(String userId) {
    if (ownerId == userId) return UserRole.owner;
    if (adminIds.contains(userId)) return UserRole.admin;
    if (moderatorIds.contains(userId)) return UserRole.moderator;
    return participantRoles[userId] ?? UserRole.listener;
  }

  bool canUserModerate(String userId) {
    final role = getUserRole(userId);
    return role == UserRole.owner || 
           role == UserRole.admin || 
           role == UserRole.moderator;
  }

  bool canUserSpeak(String userId) {
    final role = getUserRole(userId);
    return role == UserRole.owner || 
           role == UserRole.admin || 
           role == UserRole.moderator || 
           role == UserRole.speaker;
  }

  EnhancedRoom copyWith({
    String? id,
    String? name,
    String? description,
    RoomType? type,
    RoomCategory? category,
    String? ownerId,
    List<String>? adminIds,
    List<String>? moderatorIds,
    int? maxParticipants,
    bool? isPasswordProtected,
    String? password,
    DateTime? scheduledTime,
    int? estimatedDuration,
    List<String>? tags,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    int? totalParticipants,
    bool? isRecordingEnabled,
    bool? isTranscriptionEnabled,
    String? backgroundMusic,
    String? roomImage,
    Map<String, UserRole>? participantRoles,
    List<String>? bannedUserIds,
    bool? allowScreenSharing,
    bool? allowReactions,
    int? speakingTimeLimit,
  }) {
    return EnhancedRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      ownerId: ownerId ?? this.ownerId,
      adminIds: adminIds ?? this.adminIds,
      moderatorIds: moderatorIds ?? this.moderatorIds,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      isPasswordProtected: isPasswordProtected ?? this.isPasswordProtected,
      password: password ?? this.password,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      tags: tags ?? this.tags,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      isRecordingEnabled: isRecordingEnabled ?? this.isRecordingEnabled,
      isTranscriptionEnabled: isTranscriptionEnabled ?? this.isTranscriptionEnabled,
      backgroundMusic: backgroundMusic ?? this.backgroundMusic,
      roomImage: roomImage ?? this.roomImage,
      participantRoles: participantRoles ?? this.participantRoles,
      bannedUserIds: bannedUserIds ?? this.bannedUserIds,
      allowScreenSharing: allowScreenSharing ?? this.allowScreenSharing,
      allowReactions: allowReactions ?? this.allowReactions,
      speakingTimeLimit: speakingTimeLimit ?? this.speakingTimeLimit,
    );
  }
}