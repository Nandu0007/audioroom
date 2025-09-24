# AudioRoom Ninja API Documentation

## Overview

AudioRoom Ninja provides a comprehensive set of services for building social audio experiences. This documentation covers all available APIs and services.

## Core Services

### 1. Room Service (`RoomService`)

Handles room creation, joining, and management.

```dart
import 'package:audioroom/services/room_service.dart';

// Create a new room
await RoomService.createRoom(
  roomName: 'Tech Discussion',
  description: 'Latest technology trends'
);

// Join an existing room
await RoomService.joinRoom(
  roomName: 'Music Lounge',
  description: 'Share your favorite music'
);

// Leave a room
await RoomService.leaveRoom(roomName: 'Tech Discussion');

// Delete a room (admin only)
await RoomService.deleteRoom(roomName: 'Tech Discussion');
```

### 2. Voice Effects Service (`VoiceEffectsService`)

Real-time voice modulation and sound effects.

```dart
import 'package:audioroom/services/voice_effects_service.dart';

// Initialize the service
await VoiceEffectsService.initialize();

// Set voice effect
VoiceEffectsService.setVoiceEffect(
  VoiceEffect.robot,
  intensity: 0.7  // 0.0 to 1.0
);

// Play sound effect
await VoiceEffectsService.playSoundEffect(SoundEffect.ninja);

// Get available effects
final effects = VoiceEffect.values;
final soundEffects = SoundEffect.values;

// Get effect display names
final effectName = VoiceEffectsService.getVoiceEffectName(VoiceEffect.robot);
final soundName = VoiceEffectsService.getSoundEffectName(SoundEffect.ninja);
```

#### Available Voice Effects

| Effect | Description |
|--------|-------------|
| `none` | No effect applied |
| `robot` | Robotic voice with bit crushing |
| `echo` | Echo effect with 300ms delay |
| `reverb` | Multiple delay reverb |
| `pitchHigh` | Higher pitch (1.5x) |
| `pitchLow` | Lower pitch (0.7x) |
| `whisper` | Whisper-like effect |
| `demon` | Deep demonic voice |
| `chipmunk` | High-pitched chipmunk voice |
| `deepVoice` | Very deep voice |
| `spacey` | Space-like reverb with chorus |
| `vintage` | Warm vintage compression |

#### Available Sound Effects

| Effect | Description |
|--------|-------------|
| `applause` | Applause sound |
| `laugh` | Laughter sound |
| `drumRoll` | Drum roll |
| `airhorn` | Air horn sound |
| `ninja` | Ninja-themed sound |
| `sword` | Sword clash |
| `magic` | Magic spell sound |
| `explosion` | Explosion effect |

### 3. Gamification Service (`GamificationService`)

User progression, badges, and achievements.

```dart
import 'package:audioroom/services/gamification_service.dart';

// Initialize the service
await GamificationService.initialize();

// Track user activities
final rewards = await GamificationService.trackRoomJoined('music');
final speakingRewards = await GamificationService.trackSpeakingTime(15);
final creationRewards = await GamificationService.trackRoomCreated();

// Get user stats
final stats = GamificationService.currentUserStats;
print('Level: ${stats.level}');
print('XP: ${stats.experiencePoints}');
print('Badges: ${stats.earnedBadges.length}');

// Award experience manually
final leveledUp = await GamificationService.awardExperience(50);

// Get leaderboard
final leaderboard = await GamificationService.getLeaderboard();
```

#### User Stats Model

```dart
class UserStats {
  int totalRoomsJoined;
  int totalSpeakingTimeMinutes;
  int totalRoomsCreated;
  int currentStreak;
  int level;
  int experiencePoints;
  Set<String> earnedBadges;
  // ... more fields
}
```

### 4. AI Recommendation Service (`AIRecommendationService`)

Smart room recommendations based on user behavior.

```dart
import 'package:audioroom/services/ai_recommendation_service.dart';

// Initialize the service
await AIRecommendationService.initialize();

// Track room join for learning
await AIRecommendationService.trackRoomJoin(enhancedRoom);

// Track engagement
await AIRecommendationService.trackEngagement(roomId, 0.8);

// Get personalized recommendations
final recommendations = AIRecommendationService.getRecommendations(
  allRooms,
  maxRecommendations: 10
);

// Get trending rooms
final trending = AIRecommendationService.getTrendingRooms(allRooms);

// Get similar rooms
final similar = AIRecommendationService.getSimilarRooms(
  targetRoom,
  allRooms
);
```

### 5. Translation Service (`TranslationService`)

Multi-language support with real-time translation.

```dart
import 'package:audioroom/services/translation_service.dart';

// Initialize the service
await TranslationService.initialize();

// Set user language
await TranslationService.setUserLanguage('es');

// Enable auto-translate
await TranslationService.setAutoTranslate(true);

// Translate text
final translatedText = await TranslationService.translateText(
  'Hello, how are you?',
  'es',  // target language
  sourceLanguage: 'en'  // optional
);

// Detect language
final detectedLang = await TranslationService.detectLanguage(
  'Hola, ¿cómo estás?'
);

// Process chat message with auto-translation
final processedMessage = await TranslationService.processMessage(chatMessage);
```

#### Supported Languages

The service supports 60+ languages including:
- English (`en`), Spanish (`es`), French (`fr`)
- German (`de`), Italian (`it`), Portuguese (`pt`)
- Chinese (`zh`), Japanese (`ja`), Korean (`ko`)
- Arabic (`ar`), Hindi (`hi`), Russian (`ru`)
- And many more...

### 6. Room Environment Service (`RoomEnvironmentService`)

Virtual environments and ambient themes.

```dart
import 'package:audioroom/services/room_environment_service.dart';

// Initialize the service
await RoomEnvironmentService.initialize();

// Set room environment
await RoomEnvironmentService.setEnvironment(RoomEnvironment.forest);

// Get theme for environment
final theme = RoomEnvironmentService.getEnvironmentTheme(RoomEnvironment.ocean);

// Set ambient volume
await RoomEnvironmentService.setAmbientVolume(0.5);

// Get environment info
final name = RoomEnvironmentService.getEnvironmentName(RoomEnvironment.space);
final icon = RoomEnvironmentService.getEnvironmentIcon(RoomEnvironment.cafe);
```

#### Available Environments

| Environment | Description | Theme Colors |
|-------------|-------------|--------------|
| `default_` | Standard theme | Black/White |
| `forest` | Nature sounds | Green/Brown |
| `ocean` | Ocean waves | Blue/Cyan |
| `space` | Cosmic ambience | Purple/Pink |
| `cafe` | Coffee shop | Brown/Orange |
| `cyberpunk` | Futuristic | Cyan/Pink |

### 7. Analytics Service (`AnalyticsService`)

Room engagement and user behavior analytics.

```dart
import 'package:audioroom/services/analytics_service.dart';

// Initialize the service
await AnalyticsService.initialize();

// Track events
await AnalyticsService.trackRoomJoin(roomId, userId);
await AnalyticsService.trackSpeakingTime(roomId, userId, 10);

// Get room analytics
final analytics = AnalyticsService.getRoomAnalytics(roomId);
print('Total joins: ${analytics.totalJoins}');
print('Unique users: ${analytics.uniqueUsers}');
print('Speaking time: ${analytics.totalSpeakingTime} minutes');
```

## Error Handling

All services use consistent error handling:

```dart
try {
  await RoomService.createRoom(roomName: 'Test', description: 'Test room');
} catch (e) {
  print('Error creating room: $e');
  // Handle error appropriately
}
```

## Best Practices

1. **Initialize Services**: Always call `initialize()` before using services
2. **Error Handling**: Wrap service calls in try-catch blocks
3. **Resource Management**: Call `dispose()` methods when appropriate
4. **Performance**: Use caching and avoid unnecessary API calls
5. **User Experience**: Provide loading states and error feedback

## Rate Limits

- **Translation API**: 100 requests per minute
- **Room Creation**: 5 rooms per user per hour
- **Voice Effects**: No limits on switching effects
- **Analytics**: Batched every 30 seconds

## Changelog

See [CHANGELOG.md](../../CHANGELOG.md) for API version changes and updates.