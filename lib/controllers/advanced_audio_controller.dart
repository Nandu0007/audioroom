import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AdvancedAudioController extends GetxController {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  
  // Ninja-themed audio effects
  var isRecording = false.obs;
  var isPlaying = false.obs;
  var audioLevel = 0.0.obs;
  var selectedVoiceEffect = 'normal'.obs;
  var noiseSuppressionEnabled = true.obs;
  var echoCancellationEnabled = true.obs;
  var autoGainControlEnabled = true.obs;
  
  // Voice effects options
  final List<Map<String, dynamic>> voiceEffects = [
    {'name': 'Normal', 'key': 'normal', 'icon': Icons.record_voice_over},
    {'name': 'Ninja Whisper', 'key': 'whisper', 'icon': Icons.visibility_off},
    {'name': 'Shadow Voice', 'key': 'shadow', 'icon': Icons.dark_mode},
    {'name': 'Robot Ninja', 'key': 'robot', 'icon': Icons.smart_toy},
    {'name': 'Deep Shadow', 'key': 'deep', 'icon': Icons.keyboard_arrow_down},
    {'name': 'Crystal Clear', 'key': 'clear', 'icon': Icons.diamond},
    {'name': 'Echo Chamber', 'key': 'echo', 'icon': Icons.waves},
    {'name': 'Stealth Mode', 'key': 'stealth', 'icon': Icons.security},
  ];

  @override
  void onInit() {
    super.onInit();
    initializeAudio();
  }

  Future<void> initializeAudio() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    
    try {
      await _recorder!.openRecorder();
      await _player!.openPlayer();
      
      // Request microphone permission
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        Get.snackbar(
          'Permission Required',
          'Microphone access is needed for ninja voice features',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.mic_off, color: Colors.white),
        );
      }
    } catch (e) {
      print('Audio initialization error: $e');
    }
  }

  Future<void> startRecording() async {
    if (_recorder == null || isRecording.value) return;
    
    try {
      await _recorder!.startRecorder(
        toFile: 'ninja_voice_temp.aac',
        codec: Codec.aacADTS,
      );
      isRecording.value = true;
      
      // Start audio level monitoring
      _recorder!.onProgress!.listen((e) {
        audioLevel.value = e.decibels ?? 0.0;
      });
      
      Get.snackbar(
        'Recording Active',
        'Ninja voice capture initiated',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.fiber_manual_record, color: Colors.red),
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print('Recording error: $e');
    }
  }

  Future<void> stopRecording() async {
    if (_recorder == null || !isRecording.value) return;
    
    try {
      await _recorder!.stopRecorder();
      isRecording.value = false;
      audioLevel.value = 0.0;
      
      Get.snackbar(
        'Recording Complete',
        'Voice captured successfully',
        backgroundColor: Colors.blue.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.stop, color: Colors.white),
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print('Stop recording error: $e');
    }
  }

  Future<void> playRecording() async {
    if (_player == null) return;
    
    try {
      await _player!.startPlayer(
        fromURI: 'ninja_voice_temp.aac',
        codec: Codec.aacADTS,
      );
      isPlaying.value = true;
      
      _player!.onProgress!.listen((e) {
        if (e.position == e.duration) {
          isPlaying.value = false;
        }
      });
    } catch (e) {
      print('Playback error: $e');
    }
  }

  Future<void> stopPlayback() async {
    if (_player == null) return;
    
    try {
      await _player!.stopPlayer();
      isPlaying.value = false;
    } catch (e) {
      print('Stop playback error: $e');
    }
  }

  void applyVoiceEffect(String effectKey) {
    selectedVoiceEffect.value = effectKey;
    
    String effectName = voiceEffects.firstWhere(
      (effect) => effect['key'] == effectKey,
      orElse: () => {'name': 'Unknown'},
    )['name'];
    
    Get.snackbar(
      'Voice Effect Applied',
      '$effectName mode activated',
      backgroundColor: Colors.purple.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(Icons.auto_fix_high, color: Colors.white),
      duration: Duration(seconds: 2),
    );
  }

  void toggleNoiseSuppression() {
    noiseSuppressionEnabled.value = !noiseSuppressionEnabled.value;
    
    Get.snackbar(
      noiseSuppressionEnabled.value ? 'Noise Suppression ON' : 'Noise Suppression OFF',
      noiseSuppressionEnabled.value 
          ? 'Background noise filtered out' 
          : 'Raw audio input enabled',
      backgroundColor: noiseSuppressionEnabled.value 
          ? Colors.green.withOpacity(0.8) 
          : Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(
        noiseSuppressionEnabled.value ? Icons.noise_control_off : Icons.graphic_eq,
        color: Colors.white,
      ),
      duration: Duration(seconds: 2),
    );
  }

  void toggleEchoCancellation() {
    echoCancellationEnabled.value = !echoCancellationEnabled.value;
    
    Get.snackbar(
      echoCancellationEnabled.value ? 'Echo Cancellation ON' : 'Echo Cancellation OFF',
      echoCancellationEnabled.value 
          ? 'Echo effects removed' 
          : 'Natural echo preserved',
      backgroundColor: echoCancellationEnabled.value 
          ? Colors.blue.withOpacity(0.8) 
          : Colors.grey.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(
        echoCancellationEnabled.value ? Icons.cancel : Icons.graphic_eq,
        color: Colors.white,
      ),
      duration: Duration(seconds: 2),
    );
  }

  void toggleAutoGainControl() {
    autoGainControlEnabled.value = !autoGainControlEnabled.value;
    
    Get.snackbar(
      autoGainControlEnabled.value ? 'Auto Gain ON' : 'Auto Gain OFF',
      autoGainControlEnabled.value 
          ? 'Volume automatically adjusted' 
          : 'Manual volume control',
      backgroundColor: autoGainControlEnabled.value 
          ? Colors.teal.withOpacity(0.8) 
          : Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(
        autoGainControlEnabled.value ? Icons.volume_up : Icons.volume_off,
        color: Colors.white,
      ),
      duration: Duration(seconds: 2),
    );
  }

  double getNormalizedAudioLevel() {
    // Normalize audio level to 0-1 range for UI visualization
    return (audioLevel.value + 60) / 60; // Assuming -60 to 0 dB range
  }

  @override
  void onClose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.onClose();
  }
}