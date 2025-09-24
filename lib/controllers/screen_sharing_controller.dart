import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum ScreenShareState {
  idle,
  requesting,
  sharing,
  error,
}

class ScreenSharingController extends GetxController {
  var shareState = ScreenShareState.idle.obs;
  var isViewingSharedScreen = false.obs;
  var sharedScreenTitle = ''.obs;
  var sharerName = ''.obs;
  var shareQuality = ScreenShareQuality.high.obs;
  var isAudioShared = false.obs;
  var viewerCount = 0.obs;
  var errorMessage = ''.obs;

  // Screen share statistics
  var frameRate = 30.obs;
  var bitrate = 0.obs;
  var resolution = '1920x1080'.obs;

  void startScreenShare({
    ScreenShareQuality quality = ScreenShareQuality.high,
    bool shareAudio = false,
  }) async {
    try {
      shareState.value = ScreenShareState.requesting;
      shareQuality.value = quality;
      isAudioShared.value = shareAudio;

      // Request screen capture permission (platform-specific)
      bool hasPermission = await _requestScreenCapturePermission();
      
      if (!hasPermission) {
        shareState.value = ScreenShareState.error;
        errorMessage.value = 'Screen capture permission denied';
        return;
      }

      // Start screen sharing
      await _initializeScreenShare();
      shareState.value = ScreenShareState.sharing;
      
      Get.snackbar(
        'Screen Sharing',
        'Screen sharing started successfully',
        backgroundColor: Color(0xFF03DAC6),
        colorText: Color(0xFF000000),
      );

    } catch (e) {
      shareState.value = ScreenShareState.error;
      errorMessage.value = e.toString();
      
      Get.snackbar(
        'Error',
        'Failed to start screen sharing: ${e.toString()}',
        backgroundColor: Color(0xFFFF5722),
        colorText: Color(0xFFFFFFFF),
      );
    }
  }

  void stopScreenShare() async {
    try {
      await _stopScreenShareSession();
      shareState.value = ScreenShareState.idle;
      viewerCount.value = 0;
      
      Get.snackbar(
        'Screen Sharing',
        'Screen sharing stopped',
        backgroundColor: Color(0xFF1976D2),
        colorText: Color(0xFFFFFFFF),
      );

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to stop screen sharing: ${e.toString()}',
        backgroundColor: Color(0xFFFF5722),
        colorText: Color(0xFFFFFFFF),
      );
    }
  }

  void joinScreenShare(String sharerName, String screenTitle) {
    this.sharerName.value = sharerName;
    this.sharedScreenTitle.value = screenTitle;
    isViewingSharedScreen.value = true;
    
    Get.snackbar(
      'Viewing Screen',
      'Now viewing ${sharerName}\'s screen',
      backgroundColor: Color(0xFF03DAC6),
      colorText: Color(0xFF000000),
    );
  }

  void leaveScreenShare() {
    isViewingSharedScreen.value = false;
    sharerName.value = '';
    sharedScreenTitle.value = '';
    
    Get.snackbar(
      'Left Screen Share',
      'Stopped viewing shared screen',
      backgroundColor: Color(0xFF1976D2),
      colorText: Color(0xFFFFFFFF),
    );
  }

  void changeQuality(ScreenShareQuality quality) {
    if (shareState.value == ScreenShareState.sharing) {
      shareQuality.value = quality;
      _updateShareSettings();
    }
  }

  void toggleAudioShare() {
    if (shareState.value == ScreenShareState.sharing) {
      isAudioShared.value = !isAudioShared.value;
      _updateShareSettings();
    }
  }

  Future<bool> _requestScreenCapturePermission() async {
    // Platform-specific implementation
    // This would integrate with native platform APIs
    // For now, simulate permission request
    await Future.delayed(Duration(milliseconds: 500));
    return true; // Simulate granted permission
  }

  Future<void> _initializeScreenShare() async {
    // Initialize screen capture and streaming
    await Future.delayed(Duration(milliseconds: 1000));
    
    // Set initial stats
    switch (shareQuality.value) {
      case ScreenShareQuality.low:
        frameRate.value = 15;
        bitrate.value = 500;
        resolution.value = '1280x720';
        break;
      case ScreenShareQuality.medium:
        frameRate.value = 24;
        bitrate.value = 1500;
        resolution.value = '1920x1080';
        break;
      case ScreenShareQuality.high:
        frameRate.value = 30;
        bitrate.value = 4500;
        resolution.value = '2560x1440';
        break;
    }
  }

  Future<void> _stopScreenShareSession() async {
    // Stop screen capture and streaming
    await Future.delayed(Duration(milliseconds: 500));
  }

  void _updateShareSettings() {
    // Update screen sharing settings in real-time
    switch (shareQuality.value) {
      case ScreenShareQuality.low:
        frameRate.value = 15;
        bitrate.value = 500;
        resolution.value = '1280x720';
        break;
      case ScreenShareQuality.medium:
        frameRate.value = 24;
        bitrate.value = 1500;
        resolution.value = '1920x1080';
        break;
      case ScreenShareQuality.high:
        frameRate.value = 30;
        bitrate.value = 4500;
        resolution.value = '2560x1440';
        break;
    }
    print('Updated screen share settings: Quality=${shareQuality.value}, Resolution=${resolution.value}, Audio=${isAudioShared.value}');
  }

  String getQualityDisplayName(ScreenShareQuality quality) {
    switch (quality) {
      case ScreenShareQuality.low:
        return 'Low (720p)';
      case ScreenShareQuality.medium:
        return 'Medium (1080p)';
      case ScreenShareQuality.high:
        return 'High (1440p)';
    }
  }

  String getStateDisplayName() {
    switch (shareState.value) {
      case ScreenShareState.idle:
        return 'Ready to Share';
      case ScreenShareState.requesting:
        return 'Requesting Permission...';
      case ScreenShareState.sharing:
        return 'Sharing Screen';
      case ScreenShareState.error:
        return 'Error';
    }
  }

  bool get canStartSharing => shareState.value == ScreenShareState.idle;
  bool get isSharing => shareState.value == ScreenShareState.sharing;
  bool get isRequesting => shareState.value == ScreenShareState.requesting;
}

enum ScreenShareQuality {
  low,
  medium, 
  high,
}