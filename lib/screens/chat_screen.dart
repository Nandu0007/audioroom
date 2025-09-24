import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math' as math;

class ChatMessage {
  final String id;
  final String message;
  final String sender;
  final String senderAvatar;
  final DateTime timestamp;
  final bool isCurrentUser;
  final MessageType type;
  final List<String> reactions;

  ChatMessage({
    required this.id,
    required this.message,
    required this.sender,
    required this.senderAvatar,
    required this.timestamp,
    required this.isCurrentUser,
    this.type = MessageType.text,
    this.reactions = const [],
  });
}

enum MessageType { text, image, audio, system }

class ChatScreen extends StatefulWidget {
  final String roomName;
  
  ChatScreen({required this.roomName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];
  List<String> typingUsers = [];
  bool isEmojiPanelOpen = false;
  Timer? _typingTimer;
  
  final List<String> emojiList = [
    '😀', '😃', '😄', '😁', '😅', '😂', '🤣', '😊', '😇', '🙂',
    '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚', '😋',
    '😛', '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🤩', '🥳',
    '👍', '👎', '👌', '🤌', '🤏', '✌️', '🤞', '🤟', '🤘', '🤙',
    '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔',
    '🔥', '💯', '💸', '💰', '🎉', '🎊', '✨', '🌟', '⭐', '🏆',
  ];

  @override
  void initState() {
    super.initState();
    _loadSampleMessages();
    _simulateTypingUsers();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _loadSampleMessages() {
    final sampleMessages = [
      ChatMessage(
        id: '1',
        message: 'Welcome to ${widget.roomName}! 🎉',
        sender: 'System',
        senderAvatar: 'system',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isCurrentUser: false,
        type: MessageType.system,
      ),
      ChatMessage(
        id: '2',
        message: 'Hey everyone! Great to be here 👋',
        sender: 'Alex Johnson',
        senderAvatar: 'avatar1',
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
        isCurrentUser: false,
        reactions: ['👍', '❤️'],
      ),
      ChatMessage(
        id: '3',
        message: 'This room has amazing audio quality!',
        sender: 'You',
        senderAvatar: 'current_user',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isCurrentUser: true,
        reactions: ['🔥', '💯'],
      ),
      ChatMessage(
        id: '4',
        message: 'Can we discuss the new project updates?',
        sender: 'Sarah Wilson',
        senderAvatar: 'avatar2',
        timestamp: DateTime.now().subtract(Duration(minutes: 45)),
        isCurrentUser: false,
      ),
      ChatMessage(
        id: '5',
        message: 'Absolutely! I have some insights to share 📊',
        sender: 'Mike Davis',
        senderAvatar: 'avatar3',
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        isCurrentUser: false,
        reactions: ['👀', '📈'],
      ),
    ];

    setState(() {
      messages = sampleMessages;
    });
  }

  void _simulateTypingUsers() {
    Timer.periodic(Duration(seconds: math.Random().nextInt(10) + 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      final users = ['Alex Johnson', 'Sarah Wilson', 'Mike Davis'];
      final randomUser = users[math.Random().nextInt(users.length)];
      
      setState(() {
        if (typingUsers.contains(randomUser)) {
          typingUsers.remove(randomUser);
        } else if (typingUsers.length < 2) {
          typingUsers.add(randomUser);
        }
      });

      // Remove typing user after a few seconds
      if (typingUsers.contains(randomUser)) {
        Timer(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              typingUsers.remove(randomUser);
            });
          }
        });
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: _messageController.text.trim(),
      sender: 'You',
      senderAvatar: 'current_user',
      timestamp: DateTime.now(),
      isCurrentUser: true,
    );

    setState(() {
      messages.add(newMessage);
      _messageController.clear();
      isEmojiPanelOpen = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addReaction(String messageId, String emoji) {
    setState(() {
      final messageIndex = messages.indexWhere((msg) => msg.id == messageId);
      if (messageIndex != -1) {
        final message = messages[messageIndex];
        final updatedReactions = List<String>.from(message.reactions);
        
        if (updatedReactions.contains(emoji)) {
          updatedReactions.remove(emoji);
        } else {
          updatedReactions.add(emoji);
        }

        messages[messageIndex] = ChatMessage(
          id: message.id,
          message: message.message,
          sender: message.sender,
          senderAvatar: message.senderAvatar,
          timestamp: message.timestamp,
          isCurrentUser: message.isCurrentUser,
          type: message.type,
          reactions: updatedReactions,
        );
      }
    });
  }

  void _showReactionPicker(String messageId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 200,
          child: Column(
            children: [
              Text(
                'Add Reaction',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 24,
                  itemBuilder: (context, index) {
                    final emoji = emojiList[index];
                    return GestureDetector(
                      onTap: () {
                        _addReaction(messageId, emoji);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF334155),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            emoji,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.roomName,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              '${messages.length - 1} messages • ${typingUsers.length > 0 ? '${typingUsers.length} typing...' : 'Active now'}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              Get.snackbar(
                'Video Call',
                'Starting video call...',
                backgroundColor: Color(0xFF03DAC6),
                colorText: Colors.black,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length + (typingUsers.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && typingUsers.isNotEmpty) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          
          // Emoji Panel
          if (isEmojiPanelOpen) _buildEmojiPanel(),
          
          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.type == MessageType.system) {
      return _buildSystemMessage(message);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isCurrentUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF1976D2),
              child: Icon(
                Icons.person,
                size: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
          ],
          
          Flexible(
            child: GestureDetector(
              onLongPress: () => _showReactionPicker(message.id),
              child: Column(
                crossAxisAlignment: message.isCurrentUser 
                    ? CrossAxisAlignment.end 
                    : CrossAxisAlignment.start,
                children: [
                  if (!message.isCurrentUser)
                    Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 4),
                      child: Text(
                        message.sender,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF03DAC6),
                        ),
                      ),
                    ),
                  
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: message.isCurrentUser 
                          ? Color(0xFF1976D2) 
                          : Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(18).copyWith(
                        bottomLeft: Radius.circular(message.isCurrentUser ? 18 : 4),
                        bottomRight: Radius.circular(message.isCurrentUser ? 4 : 18),
                      ),
                    ),
                    child: Text(
                      message.message,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  // Reactions
                  if (message.reactions.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 4,
                        children: message.reactions.map((reaction) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFF334155),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              reaction,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  
                  // Timestamp
                  Padding(
                    padding: EdgeInsets.only(
                      left: message.isCurrentUser ? 0 : 12,
                      right: message.isCurrentUser ? 12 : 0,
                      top: 4,
                    ),
                    child: Text(
                      _formatTimestamp(message.timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (message.isCurrentUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF03DAC6),
              child: Icon(
                Icons.person,
                size: 20,
                color: Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSystemMessage(ChatMessage message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.message,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF334155),
            child: Icon(
              Icons.more_horiz,
              size: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Text(
                '${typingUsers.join(", ")} ${typingUsers.length == 1 ? "is" : "are"} typing...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPanel() {
    return Container(
      height: 200,
      color: Color(0xFF1E293B),
      padding: EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: emojiList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _messageController.text += emojiList[index];
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  emojiList[index],
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          // Emoji Button
          IconButton(
            icon: Icon(
              isEmojiPanelOpen ? Icons.keyboard : Icons.emoji_emotions,
              color: Color(0xFF03DAC6),
            ),
            onPressed: () {
              setState(() {
                isEmojiPanelOpen = !isEmojiPanelOpen;
              });
            },
          ),
          
          // Text Input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: GoogleFonts.inter(color: Colors.white60),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
                onChanged: (text) {
                  // Handle typing indicator
                },
              ),
            ),
          ),
          
          SizedBox(width: 8),
          
          // Send Button
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1976D2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}