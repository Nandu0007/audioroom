import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:async';

class VoiceRecorderScreen extends StatefulWidget {
  @override
  _VoiceRecorderScreenState createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends State<VoiceRecorderScreen>
    with TickerProviderStateMixin {
  bool isRecording = false;
  bool isPlaying = false;
  bool hasRecording = false;
  Duration recordingDuration = Duration.zero;
  Duration playbackPosition = Duration.zero;
  Timer? _timer;
  
  late AnimationController _waveAnimationController;
  late AnimationController _pulseAnimationController;
  List<double> waveformData = [];
  
  // Simulated audio levels for waveform
  List<double> audioLevels = [];
  int currentWaveIndex = 0;

  @override
  void initState() {
    super.initState();
    _waveAnimationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Generate random waveform data for demo
    _generateWaveformData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  void _generateWaveformData() {
    waveformData = List.generate(200, (index) {
      return (math.sin(index * 0.1) * 50 + 50).abs();
    });
  }

  void _startRecording() {
    setState(() {
      isRecording = true;
      recordingDuration = Duration.zero;
      audioLevels.clear();
    });
    
    _pulseAnimationController.repeat();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        recordingDuration = Duration(milliseconds: timer.tick * 100);
        // Simulate audio levels
        audioLevels.add((math.Random().nextDouble() * 100));
        if (audioLevels.length > 100) {
          audioLevels.removeAt(0);
        }
      });
    });
  }

  void _stopRecording() {
    setState(() {
      isRecording = false;
      hasRecording = true;
    });
    _timer?.cancel();
    _pulseAnimationController.stop();
  }

  void _playRecording() {
    setState(() {
      isPlaying = true;
      playbackPosition = Duration.zero;
    });
    
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        playbackPosition = Duration(milliseconds: timer.tick * 100);
        if (playbackPosition >= recordingDuration) {
          _stopPlayback();
        }
      });
    });
  }

  void _stopPlayback() {
    setState(() {
      isPlaying = false;
    });
    _timer?.cancel();
  }

  void _deleteRecording() {
    setState(() {
      hasRecording = false;
      recordingDuration = Duration.zero;
      playbackPosition = Duration.zero;
      audioLevels.clear();
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1421),
      appBar: AppBar(
        title: Text(
          'Voice Recorder',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1976D2),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Waveform Visualization Area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Recording Status
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isRecording
                          ? Colors.red.withOpacity(0.2)
                          : hasRecording
                              ? Color(0xFF1976D2).withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isRecording
                            ? Colors.red
                            : hasRecording
                                ? Color(0xFF1976D2)
                                : Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isRecording
                                ? Colors.red
                                : hasRecording
                                    ? Colors.green
                                    : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          isRecording
                              ? 'Recording...'
                              : hasRecording
                                  ? 'Ready to Play'
                                  : 'Ready to Record',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Waveform Display
                  Container(
                    height: 120,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: isRecording || hasRecording
                        ? _buildWaveform()
                        : _buildEmptyWaveform(),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Duration Display
                  Text(
                    _formatDuration(isRecording ? recordingDuration : playbackPosition),
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF03DAC6),
                    ),
                  ),
                  
                  if (hasRecording && !isRecording) ...[
                    SizedBox(height: 10),
                    Text(
                      'Total: ${_formatDuration(recordingDuration)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Controls Area
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main Control Button
                  AnimatedBuilder(
                    animation: _pulseAnimationController,
                    builder: (context, child) {
                      return Container(
                        width: 100 + (isRecording ? _pulseAnimationController.value * 20 : 0),
                        height: 100 + (isRecording ? _pulseAnimationController.value * 20 : 0),
                        decoration: BoxDecoration(
                          color: isRecording ? Colors.red : Color(0xFF1976D2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isRecording ? Colors.red : Color(0xFF1976D2))
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: isRecording ? _pulseAnimationController.value * 10 : 5,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: isRecording ? _stopRecording : _startRecording,
                          icon: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Secondary Controls
                  if (hasRecording && !isRecording) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Play/Pause Button
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF03DAC6),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF03DAC6).withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: isPlaying ? _stopPlayback : _playRecording,
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                        
                        // Delete Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: IconButton(
                            onPressed: _deleteRecording,
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ),
                        
                        // Share Button
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1976D2).withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF1976D2), width: 2),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Get.snackbar(
                                'Share Recording',
                                'Recording shared successfully!',
                                backgroundColor: Color(0xFF03DAC6),
                                colorText: Colors.black,
                              );
                            },
                            icon: Icon(
                              Icons.share,
                              color: Color(0xFF1976D2),
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    List<double> displayData = isRecording ? audioLevels : waveformData;
    
    return CustomPaint(
      painter: WaveformPainter(
        data: displayData,
        progress: hasRecording ? (playbackPosition.inMilliseconds / recordingDuration.inMilliseconds) : 1.0,
        isRecording: isRecording,
      ),
      size: Size(double.infinity, 120),
    );
  }

  Widget _buildEmptyWaveform() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.graphic_eq,
              color: Colors.grey.withOpacity(0.5),
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              'Waveform will appear here',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> data;
  final double progress;
  final bool isRecording;

  WaveformPainter({
    required this.data,
    required this.progress,
    required this.isRecording,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final playedPaint = Paint()
      ..color = Color(0xFF03DAC6)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final unplayedPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / data.length;
    final centerY = size.height / 2;

    for (int i = 0; i < data.length; i++) {
      final x = i * barWidth;
      final barHeight = (data[i] / 100) * (size.height * 0.8);
      final startY = centerY - barHeight / 2;
      final endY = centerY + barHeight / 2;

      // Determine color based on progress
      if (isRecording) {
        paint.color = Color(0xFF03DAC6);
      } else {
        paint.color = (i / data.length) <= progress ? Color(0xFF03DAC6) : Colors.grey.withOpacity(0.5);
      }

      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}