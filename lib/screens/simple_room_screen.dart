import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'audio_effects_screen.dart';
import 'screen_sharing_screen.dart';
import 'soundboard_screen.dart';

class SimpleRoomScreen extends StatefulWidget {
  final String roomName;
  final String roomDescription;

  const SimpleRoomScreen({
    Key? key,
    required this.roomName,
    required this.roomDescription,
  }) : super(key: key);

  @override
  State<SimpleRoomScreen> createState() => _SimpleRoomScreenState();
}

class _SimpleRoomScreenState extends State<SimpleRoomScreen> {
  bool _isMicOn = false;
  bool _isConnected = true;
  
  // Demo participants
  List<Map<String, dynamic>> participants = [
    {"name": "You", "isMicOn": false, "isHost": true},
    {"name": "Alice", "isMicOn": true, "isHost": false},
    {"name": "Bob", "isMicOn": false, "isHost": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Audio Room",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1976D2),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AudioEffectsScreen());
            },
            icon: Icon(Icons.graphic_eq, color: Colors.white),
            tooltip: 'Audio Effects',
          ),
          IconButton(
            onPressed: () {
              Get.to(() => ScreenSharingScreen());
            },
            icon: Icon(Icons.screen_share, color: Colors.white),
            tooltip: 'Screen Sharing',
          ),
          IconButton(
            onPressed: () {
              Get.to(() => SoundboardScreen());
            },
            icon: Icon(Icons.music_note, color: Colors.white),
            tooltip: 'Soundboard',
          ),
          IconButton(
            onPressed: () {
              _showLeaveRoomDialog();
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isMicOn = !_isMicOn;
            // Update your mic status in participants list
            participants[0]["isMicOn"] = _isMicOn;
          });
          
          Get.snackbar(
            _isMicOn ? "Mic On" : "Mic Off",
            _isMicOn ? "You are now speaking" : "You are now muted",
            backgroundColor: _isMicOn ? Colors.green : Colors.red,
            colorText: Colors.white,
          );
        },
        backgroundColor: (_isMicOn) ? Color(0xFF03DAC6) : Color(0xFF1976D2),
        child: Icon(
          (_isMicOn) ? Icons.mic : Icons.mic_off_rounded,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Room Info
            Text(
              widget.roomName,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              widget.roomDescription,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            
            // Connection Status
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isConnected ? Color(0xFF03DAC6) : Colors.grey.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isConnected ? "🔗 Connected" : "❌ Disconnected",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            
            SizedBox(height: 30),
            
            // Participants Section
            Text(
              "Participants (${participants.length})",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            
            // Participants List
            Expanded(
              child: ListView.builder(
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final participant = participants[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: participant["isHost"] 
                            ? Color(0xFF03DAC6) 
                            : Color(0xFF1976D2),
                        child: Icon(
                          participant["isHost"] 
                              ? Icons.admin_panel_settings 
                              : Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        participant["name"],
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        participant["isHost"] ? "Host" : "Participant",
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Icon(
                        participant["isMicOn"] ? Icons.mic : Icons.mic_off,
                        color: participant["isMicOn"] ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 80), // Space for floating action button
          ],
        ),
      ),
    );
  }
  
  void _showLeaveRoomDialog() {
    Get.defaultDialog(
      title: "Leave Room",
      middleText: "Are you sure you want to leave this room?",
      textConfirm: "Leave",
      textCancel: "Stay",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(); // Go back to home screen
        Get.snackbar(
          "Left Room",
          "Left room successfully",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }
}