import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ninja_ui_components.dart';
import '../controllers/advanced_audio_controller.dart';

class AdvancedChatScreen extends StatefulWidget {
  final String roomName;
  
  const AdvancedChatScreen({Key? key, required this.roomName}) : super(key: key);

  @override
  State<AdvancedChatScreen> createState() => _AdvancedChatScreenState();
}

class _AdvancedChatScreenState extends State<AdvancedChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AdvancedAudioController _audioController = Get.put(AdvancedAudioController());
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // Enhanced chat features
  bool isEmojiPickerVisible = false;
  bool isVoiceMessageMode = false;
  String selectedMessageType = 'text';
  
  List<Map<String, dynamic>> messages = [
    {
      'id': '1',
      'sender': 'NinjaUser1',
      'message': 'Welcome to the shadow realm!',
      'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
      'type': 'text',
      'reactions': ['⚡', '🥷'],
      'isOwn': false,
    },
    {
      'id': '2',
      'sender': 'ShadowMaster',
      'message': 'The way of the ninja requires silence and precision.',
      'timestamp': DateTime.now().subtract(Duration(minutes: 25)),
      'type': 'text',
      'reactions': ['🔥', '💯', '🎯'],
      'isOwn': false,
    },
    {
      'id': '3',
      'sender': 'You',
      'message': 'Ready to unleash my ninja skills!',
      'timestamp': DateTime.now().subtract(Duration(minutes: 20)),
      'type': 'text',
      'reactions': ['🥷', '⚔️'],
      'isOwn': true,
    },
  ];

  final List<String> ninjaEmojis = [
    '🥷', '⚔️', '🗡️', '🔥', '💥', '⚡', '🌙', '⭐', 
    '💯', '🎯', '🔮', '💎', '👁️', '🖤', '🤍', '⭕',
    '🔴', '🟡', '🟢', '🔵', '🟣', '⚫', '⚪', '🔹'
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNinjaAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildParticipantsBar(),
            Expanded(
              child: _buildMessagesList(),
            ),
            _buildInputArea(),
            if (isEmojiPickerVisible) _buildEmojiPicker(),
          ],
        ),
      ),
    );
  }

  AppBar _buildNinjaAppBar() {
    return AppBar(
      title: Row(
        children: [
          NinjaPulseEffect(
            child: Icon(Icons.group, color: Colors.white),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.roomName,
                  style: GoogleFonts.orbitron(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '3 Ninjas Online',
                  style: GoogleFonts.rajdhani(
                    fontSize: 12,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _showAudioEffectsPanel(),
          icon: Icon(Icons.tune, color: Colors.white),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.white),
          color: Color(0xFF111111),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'mute',
              child: Row(
                children: [
                  Icon(Icons.volume_off, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Mute Room', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Chat Settings', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Share Room', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleMenuAction(value),
        ),
      ],
    );
  }

  Widget _buildParticipantsBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF111111),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade800, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final participants = ['NinjaUser1', 'ShadowMaster', 'You'];
                final isOnline = [true, true, true];
                
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          NinjaPulseEffect(
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey.shade700,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          if (isOnline[index])
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        participants[index],
                        style: GoogleFonts.rajdhani(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(() => NinjaAudioVisualizer(
            audioLevel: _audioController.getNormalizedAudioLevel(),
            barCount: 10,
            height: 30,
          )),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isOwn = message['isOwn'] as bool;
    
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOwn) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade700,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            flex: 3,
            child: NinjaCard(
              padding: EdgeInsets.all(12),
              onTap: () => _showMessageActions(message),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwn)
                    Text(
                      message['sender'],
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade300,
                        letterSpacing: 0.5,
                      ),
                    ),
                  if (!isOwn) SizedBox(height: 4),
                  Text(
                    message['message'],
                    style: GoogleFonts.rajdhani(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (message['reactions']?.isNotEmpty ?? false)
                        Wrap(
                          spacing: 4,
                          children: (message['reactions'] as List<String>)
                              .map((reaction) => Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      reaction,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ))
                              .toList(),
                        ),
                      Text(
                        _formatTime(message['timestamp']),
                        style: GoogleFonts.rajdhani(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isOwn) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black, size: 16),
            ),
          ],
          SizedBox(width: 60), // Space for alignment
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF111111),
        border: Border(
          top: BorderSide(color: Colors.grey.shade800, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Message type selector
          Row(
            children: [
              _buildMessageTypeButton('text', Icons.message, 'Text'),
              SizedBox(width: 8),
              _buildMessageTypeButton('voice', Icons.mic, 'Voice'),
              SizedBox(width: 8),
              _buildMessageTypeButton('file', Icons.attach_file, 'File'),
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    isEmojiPickerVisible = !isEmojiPickerVisible;
                  });
                },
                icon: Icon(
                  Icons.emoji_emotions,
                  color: isEmojiPickerVisible ? Colors.white : Colors.grey.shade500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Input row
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.shade700, width: 1),
                  ),
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.rajdhani(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your ninja message...',
                      hintStyle: GoogleFonts.rajdhani(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              SizedBox(width: 12),
              NinjaPulseEffect(
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: selectedMessageType == 'voice' ? _toggleVoiceMessage : _sendMessage,
                  child: Obx(() => Icon(
                    selectedMessageType == 'voice'
                        ? (_audioController.isRecording.value ? Icons.stop : Icons.mic)
                        : Icons.send,
                    color: Colors.black,
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTypeButton(String type, IconData icon, String label) {
    final isSelected = selectedMessageType == type;
    return NinjaCard(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: () {
        setState(() {
          selectedMessageType = type;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey.shade500,
            size: 16,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.rajdhani(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return Container(
      height: 200,
      color: Color(0xFF111111),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'NINJA EMOJIS',
              style: GoogleFonts.orbitron(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: ninjaEmojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _messageController.text += ninjaEmojis[index];
                    setState(() {
                      isEmojiPickerVisible = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        ninjaEmojis[index],
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'sender': 'You',
      'message': _messageController.text.trim(),
      'timestamp': DateTime.now(),
      'type': selectedMessageType,
      'reactions': <String>[],
      'isOwn': true,
    };
    
    setState(() {
      messages.add(newMessage);
      _messageController.clear();
    });
    
    // Auto scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    
    Get.snackbar(
      'Message Sent',
      'Your ninja message has been delivered',
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 1),
    );
  }

  void _toggleVoiceMessage() {
    if (_audioController.isRecording.value) {
      _audioController.stopRecording();
    } else {
      _audioController.startRecording();
    }
  }

  void _showAudioEffectsPanel() {
    Get.bottomSheet(
      Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'NINJA AUDIO EFFECTS',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Voice effects grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _audioController.voiceEffects.length,
                    itemBuilder: (context, index) {
                      final effect = _audioController.voiceEffects[index];
                      return Obx(() => NinjaGradientButton(
                        text: effect['name'],
                        icon: effect['icon'],
                        width: double.infinity,
                        height: 50,
                        onPressed: () => _audioController.applyVoiceEffect(effect['key']),
                      ));
                    },
                  ),
                  SizedBox(height: 20),
                  // Audio controls
                  Obx(() => SwitchListTile(
                    title: Text('Noise Suppression', style: GoogleFonts.rajdhani(color: Colors.white)),
                    value: _audioController.noiseSuppressionEnabled.value,
                    onChanged: (_) => _audioController.toggleNoiseSuppression(),
                    activeColor: Colors.white,
                  )),
                  Obx(() => SwitchListTile(
                    title: Text('Echo Cancellation', style: GoogleFonts.rajdhani(color: Colors.white)),
                    value: _audioController.echoCancellationEnabled.value,
                    onChanged: (_) => _audioController.toggleEchoCancellation(),
                    activeColor: Colors.white,
                  )),
                  Obx(() => SwitchListTile(
                    title: Text('Auto Gain Control', style: GoogleFonts.rajdhani(color: Colors.white)),
                    value: _audioController.autoGainControlEnabled.value,
                    onChanged: (_) => _audioController.toggleAutoGainControl(),
                    activeColor: Colors.white,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageActions(Map<String, dynamic> message) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'MESSAGE ACTIONS',
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ninjaEmojis.take(6).map((emoji) {
                return GestureDetector(
                  onTap: () {
                    _addReaction(message, emoji);
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(emoji, style: TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: NinjaGradientButton(
                    text: 'Reply',
                    icon: Icons.reply,
                    onPressed: () {
                      Get.back();
                      _messageController.text = '@${message['sender']} ';
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: NinjaGradientButton(
                    text: 'Copy',
                    icon: Icons.copy,
                    onPressed: () {
                      Get.back();
                      // Copy to clipboard functionality would go here
                      Get.snackbar('Copied', 'Message copied to clipboard');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addReaction(Map<String, dynamic> message, String reaction) {
    setState(() {
      final reactions = message['reactions'] as List<String>;
      if (!reactions.contains(reaction)) {
        reactions.add(reaction);
      }
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'mute':
        Get.snackbar('Muted', 'Room audio muted');
        break;
      case 'settings':
        // Navigate to chat settings
        break;
      case 'share':
        Get.snackbar('Share', 'Room link copied to clipboard');
        break;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) {
      return 'Now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}