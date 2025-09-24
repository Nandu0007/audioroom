import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/create_enhanced_room_screen.dart';
import '../screens/simple_room_screen.dart';
import '../models/room.dart';

class CreateRoomDialog extends StatelessWidget {
  final Function(Map<String, dynamic>) onRoomCreated;
  
  CreateRoomDialog({required this.onRoomCreated});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.meeting_room,
            size: 60,
            color: Color(0xFF03DAC6),
          ),
          SizedBox(height: 16),
          Text(
            'Create a Room',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Set up your audio room with advanced features',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white60),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Cancel', style: GoogleFonts.inter()),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back(); // Close current dialog
                    final result = await Get.to(() => CreateEnhancedRoomScreen());
                    if (result != null) {
                      // Convert EnhancedRoom to simple room format for backward compatibility
                      final simpleRoom = {
                        "name": result.name,
                        "description": result.description,
                        "total_participants": result.totalParticipants,
                      };
                      onRoomCreated(simpleRoom);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
