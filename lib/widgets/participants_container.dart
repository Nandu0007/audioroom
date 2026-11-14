import 'package:audioroom/widgets/participant_block.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/participant.dart';

class ParticipantsContainer extends StatelessWidget {
  ParticipantsContainer(this.roomName);

  final String roomName;
  final SupabaseClient _db = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _db.from('rooms').select('id').eq('title', roomName).limit(1).maybeSingle(),
      builder: (context, roomSnapshot) {
        if (roomSnapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final room = roomSnapshot.data;
        if (room == null) return const Center(child: Text('Room not found'));
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: _db.from('room_members')
              .stream(primaryKey: ['room_id', 'user_id'])
              .eq('room_id', room['id']),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Could not load participants'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final members = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.5 / 3,
              ),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return FutureBuilder<Map<String, dynamic>?>(
                  future: _db.from('profiles')
                      .select('display_name,avatar_url')
                      .eq('id', member['user_id'])
                      .maybeSingle(),
                  builder: (context, profileSnapshot) {
                    final profile = profileSnapshot.data ?? {};
                    final role = member['role'] as String? ?? 'member';
                    final userId = member['user_id'] as String;
                    final displayName = profile['display_name'] as String?;
                    final avatarUrl = profile['avatar_url'] as String?;
                    final participant = Participant(
                      email: userId,
                      name: displayName != null && displayName.isNotEmpty
                          ? displayName
                          : 'User ${userId.substring(0, 6)}',
                      dpUrl: avatarUrl ??
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                      isAdmin: role == 'owner' || role == 'admin',
                      isMicOn: false,
                      isModerator: role == 'admin',
                      isSpeaker: true,
                      isSpeaking: false,
                    );
                    return ParticipantBlock(participant: participant);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
