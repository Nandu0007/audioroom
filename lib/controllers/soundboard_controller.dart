import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum SoundCategory {
  applause,
  reactions,
  ambient,
  music,
  effects,
}

class SoundItem {
  final String id;
  final String name;
  final String description;
  final SoundCategory category;
  final String filePath;
  final Duration duration;
  final String icon;

  SoundItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.filePath,
    required this.duration,
    required this.icon,
  });
}

class SoundboardController extends GetxController {
  var isBackgroundMusicEnabled = false.obs;
  var currentBackgroundMusic = Rxn<SoundItem>();
  var backgroundMusicVolume = 0.3.obs;
  var soundEffectVolume = 0.7.obs;
  var isMuted = false.obs;
  
  // Currently playing sounds
  var currentlyPlaying = <String, bool>{}.obs;
  var soundQueue = <SoundItem>[].obs;

  final List<SoundItem> _applauseSounds = [
    SoundItem(
      id: 'clap_1',
      name: 'Light Applause',
      description: 'Gentle clapping sound',
      category: SoundCategory.applause,
      filePath: 'assets/sounds/light_clap.mp3',
      duration: Duration(seconds: 3),
      icon: '👏',
    ),
    SoundItem(
      id: 'clap_2',
      name: 'Crowd Applause',
      description: 'Large crowd clapping',
      category: SoundCategory.applause,
      filePath: 'assets/sounds/crowd_applause.mp3',
      duration: Duration(seconds: 5),
      icon: '🎉',
    ),
    SoundItem(
      id: 'whistle',
      name: 'Whistle',
      description: 'Appreciation whistle',
      category: SoundCategory.applause,
      filePath: 'assets/sounds/whistle.mp3',
      duration: Duration(seconds: 2),
      icon: '📯',
    ),
  ];

  final List<SoundItem> _reactionSounds = [
    SoundItem(
      id: 'laugh',
      name: 'Laughter',
      description: 'Hearty laugh',
      category: SoundCategory.reactions,
      filePath: 'assets/sounds/laugh.mp3',
      duration: Duration(seconds: 3),
      icon: '😂',
    ),
    SoundItem(
      id: 'wow',
      name: 'Wow',
      description: 'Amazed reaction',
      category: SoundCategory.reactions,
      filePath: 'assets/sounds/wow.mp3',
      duration: Duration(seconds: 2),
      icon: '😮',
    ),
    SoundItem(
      id: 'boo',
      name: 'Boo',
      description: 'Disapproval sound',
      category: SoundCategory.reactions,
      filePath: 'assets/sounds/boo.mp3',
      duration: Duration(seconds: 2),
      icon: '👎',
    ),
    SoundItem(
      id: 'air_horn',
      name: 'Air Horn',
      description: 'Attention grabber',
      category: SoundCategory.reactions,
      filePath: 'assets/sounds/air_horn.mp3',
      duration: Duration(seconds: 3),
      icon: '📯',
    ),
  ];

  final List<SoundItem> _ambientSounds = [
    SoundItem(
      id: 'rain',
      name: 'Rain',
      description: 'Gentle rain sounds',
      category: SoundCategory.ambient,
      filePath: 'assets/sounds/rain.mp3',
      duration: Duration(minutes: 10),
      icon: '🌧️',
    ),
    SoundItem(
      id: 'forest',
      name: 'Forest',
      description: 'Birds and nature sounds',
      category: SoundCategory.ambient,
      filePath: 'assets/sounds/forest.mp3',
      duration: Duration(minutes: 15),
      icon: '🌲',
    ),
    SoundItem(
      id: 'ocean',
      name: 'Ocean Waves',
      description: 'Calming wave sounds',
      category: SoundCategory.ambient,
      filePath: 'assets/sounds/ocean.mp3',
      duration: Duration(minutes: 12),
      icon: '🌊',
    ),
    SoundItem(
      id: 'cafe',
      name: 'Cafe Ambience',
      description: 'Coffee shop atmosphere',
      category: SoundCategory.ambient,
      filePath: 'assets/sounds/cafe.mp3',
      duration: Duration(minutes: 20),
      icon: '☕',
    ),
  ];

  final List<SoundItem> _musicSounds = [
    SoundItem(
      id: 'piano_1',
      name: 'Soft Piano',
      description: 'Gentle piano melody',
      category: SoundCategory.music,
      filePath: 'assets/sounds/soft_piano.mp3',
      duration: Duration(minutes: 8),
      icon: '🎹',
    ),
    SoundItem(
      id: 'jazz',
      name: 'Jazz Lounge',
      description: 'Smooth jazz background',
      category: SoundCategory.music,
      filePath: 'assets/sounds/jazz.mp3',
      duration: Duration(minutes: 12),
      icon: '🎷',
    ),
    SoundItem(
      id: 'acoustic',
      name: 'Acoustic Guitar',
      description: 'Peaceful guitar strums',
      category: SoundCategory.music,
      filePath: 'assets/sounds/acoustic.mp3',
      duration: Duration(minutes: 10),
      icon: '🎸',
    ),
  ];

  final List<SoundItem> _effectSounds = [
    SoundItem(
      id: 'drum_roll',
      name: 'Drum Roll',
      description: 'Building suspense',
      category: SoundCategory.effects,
      filePath: 'assets/sounds/drum_roll.mp3',
      duration: Duration(seconds: 5),
      icon: '🥁',
    ),
    SoundItem(
      id: 'bell',
      name: 'Bell',
      description: 'Notification bell',
      category: SoundCategory.effects,
      filePath: 'assets/sounds/bell.mp3',
      duration: Duration(seconds: 2),
      icon: '🔔',
    ),
    SoundItem(
      id: 'tada',
      name: 'Ta-da!',
      description: 'Victory fanfare',
      category: SoundCategory.effects,
      filePath: 'assets/sounds/tada.mp3',
      duration: Duration(seconds: 3),
      icon: '🎺',
    ),
    SoundItem(
      id: 'whoosh',
      name: 'Whoosh',
      description: 'Transition sound',
      category: SoundCategory.effects,
      filePath: 'assets/sounds/whoosh.mp3',
      duration: Duration(seconds: 2),
      icon: '💨',
    ),
  ];

  List<SoundItem> get allSounds => [
        ..._applauseSounds,
        ..._reactionSounds,
        ..._ambientSounds,
        ..._musicSounds,
        ..._effectSounds,
      ];

  List<SoundItem> getSoundsByCategory(SoundCategory category) {
    switch (category) {
      case SoundCategory.applause:
        return _applauseSounds;
      case SoundCategory.reactions:
        return _reactionSounds;
      case SoundCategory.ambient:
        return _ambientSounds;
      case SoundCategory.music:
        return _musicSounds;
      case SoundCategory.effects:
        return _effectSounds;
    }
  }

  String getCategoryDisplayName(SoundCategory category) {
    switch (category) {
      case SoundCategory.applause:
        return 'Applause';
      case SoundCategory.reactions:
        return 'Reactions';
      case SoundCategory.ambient:
        return 'Ambient';
      case SoundCategory.music:
        return 'Music';
      case SoundCategory.effects:
        return 'Effects';
    }
  }

  String getCategoryIcon(SoundCategory category) {
    switch (category) {
      case SoundCategory.applause:
        return '👏';
      case SoundCategory.reactions:
        return '😄';
      case SoundCategory.ambient:
        return '🌿';
      case SoundCategory.music:
        return '🎵';
      case SoundCategory.effects:
        return '✨';
    }
  }

  void playSound(SoundItem sound) {
    if (isMuted.value) return;

    currentlyPlaying[sound.id] = true;
    currentlyPlaying.refresh();

    // Simulate audio playback
    print('Playing sound: ${sound.name}');
    
    // Simulate sound duration
    Future.delayed(sound.duration, () {
      currentlyPlaying[sound.id] = false;
      currentlyPlaying.refresh();
    });

    Get.snackbar(
      'Playing',
      sound.name,
      backgroundColor: Color(0xFF03DAC6),
      colorText: Color(0xFF000000),
      duration: Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void stopSound(String soundId) {
    currentlyPlaying[soundId] = false;
    currentlyPlaying.refresh();
    
    // Here you would integrate with actual audio player to stop the sound
    print('Stopping sound: $soundId');
  }

  void setBackgroundMusic(SoundItem? music) {
    if (currentBackgroundMusic.value != null) {
      stopSound(currentBackgroundMusic.value!.id);
    }

    currentBackgroundMusic.value = music;
    
    if (music != null && isBackgroundMusicEnabled.value) {
      playBackgroundMusic();
    }
  }

  void playBackgroundMusic() {
    if (currentBackgroundMusic.value != null && !isMuted.value) {
      currentlyPlaying[currentBackgroundMusic.value!.id] = true;
      currentlyPlaying.refresh();
      
      print('Playing background music: ${currentBackgroundMusic.value!.name}');
      
      // Loop background music
      _loopBackgroundMusic();
    }
  }

  void _loopBackgroundMusic() {
    if (currentBackgroundMusic.value != null && isBackgroundMusicEnabled.value) {
      Future.delayed(currentBackgroundMusic.value!.duration, () {
        if (currentBackgroundMusic.value != null && isBackgroundMusicEnabled.value) {
          _loopBackgroundMusic();
        }
      });
    }
  }

  void stopBackgroundMusic() {
    if (currentBackgroundMusic.value != null) {
      stopSound(currentBackgroundMusic.value!.id);
    }
  }

  void toggleBackgroundMusic() {
    isBackgroundMusicEnabled.value = !isBackgroundMusicEnabled.value;
    
    if (isBackgroundMusicEnabled.value && currentBackgroundMusic.value != null) {
      playBackgroundMusic();
    } else {
      stopBackgroundMusic();
    }
  }

  void setBackgroundMusicVolume(double volume) {
    backgroundMusicVolume.value = volume.clamp(0.0, 1.0);
    // Here you would adjust the actual audio player volume
    print('Background music volume: ${backgroundMusicVolume.value}');
  }

  void setSoundEffectVolume(double volume) {
    soundEffectVolume.value = volume.clamp(0.0, 1.0);
    // Here you would adjust the actual audio player volume
    print('Sound effect volume: ${soundEffectVolume.value}');
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    
    if (isMuted.value) {
      // Stop all currently playing sounds
      for (String soundId in currentlyPlaying.keys.toList()) {
        if (currentlyPlaying[soundId] == true) {
          stopSound(soundId);
        }
      }
    } else if (isBackgroundMusicEnabled.value && currentBackgroundMusic.value != null) {
      playBackgroundMusic();
    }
  }

  void clearQueue() {
    soundQueue.clear();
  }

  void addToQueue(SoundItem sound) {
    soundQueue.add(sound);
  }

  void playQueue() {
    if (soundQueue.isNotEmpty) {
      final sound = soundQueue.removeAt(0);
      playSound(sound);
      
      // Play next sound after current one finishes
      Future.delayed(sound.duration + Duration(milliseconds: 500), () {
        if (soundQueue.isNotEmpty) {
          playQueue();
        }
      });
    }
  }

  bool isSoundPlaying(String soundId) {
    return currentlyPlaying[soundId] ?? false;
  }

  void quickReaction(String reaction) {
    SoundItem? sound;
    
    switch (reaction.toLowerCase()) {
      case 'applause':
      case 'clap':
        sound = _applauseSounds.first;
        break;
      case 'laugh':
        sound = _reactionSounds.firstWhere((s) => s.id == 'laugh');
        break;
      case 'wow':
        sound = _reactionSounds.firstWhere((s) => s.id == 'wow');
        break;
      case 'horn':
        sound = _reactionSounds.firstWhere((s) => s.id == 'air_horn');
        break;
    }
    
    if (sound != null) {
      playSound(sound);
    }
  }
}