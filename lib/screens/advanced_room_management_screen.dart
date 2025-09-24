import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ninja_ui_components.dart';

class AdvancedRoomManagementScreen extends StatefulWidget {
  @override
  State<AdvancedRoomManagementScreen> createState() => _AdvancedRoomManagementScreenState();
}

class _AdvancedRoomManagementScreenState extends State<AdvancedRoomManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomDescriptionController = TextEditingController();
  final TextEditingController _roomPasswordController = TextEditingController();
  
  String selectedCategory = 'General';
  bool isPrivateRoom = false;
  bool requiresPassword = false;
  int maxParticipants = 50;
  bool allowVoiceMessages = true;
  bool allowFileSharing = true;
  bool autoModerationEnabled = true;

  final List<String> roomCategories = [
    'General',
    'Gaming',
    'Music',
    'Study',
    'Business',
    'Tech',
    'Social',
    'Creative',
    'Sports',
    'Learning'
  ];

  final List<Map<String, dynamic>> moderationActions = [
    {
      'title': 'Kick User',
      'icon': Icons.person_remove,
      'action': 'kick',
      'color': Colors.orange,
    },
    {
      'title': 'Ban User',
      'icon': Icons.block,
      'action': 'ban',
      'color': Colors.red,
    },
    {
      'title': 'Mute User',
      'icon': Icons.mic_off,
      'action': 'mute',
      'color': Colors.yellow,
    },
    {
      'title': 'Grant Moderator',
      'icon': Icons.security,
      'action': 'promote',
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNinjaAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCreateRoomTab(),
                _buildManageRoomsTab(),
                _buildModerationTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildNinjaAppBar() {
    return AppBar(
      title: Row(
        children: [
          NinjaPulseEffect(
            child: Icon(Icons.admin_panel_settings, color: Colors.white),
          ),
          SizedBox(width: 8),
          Text(
            'ROOM DOJO',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Color(0xFF111111),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade500,
        labelStyle: GoogleFonts.orbitron(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        tabs: [
          Tab(text: 'CREATE'),
          Tab(text: 'MANAGE'),
          Tab(text: 'MODERATE'),
        ],
      ),
    );
  }

  Widget _buildCreateRoomTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NinjaAnimatedText(
            text: 'CREATE NEW ROOM',
            textStyle: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 30),
          
          // Room name
          _buildInputField(
            controller: _roomNameController,
            label: 'Room Name',
            hint: 'Enter your ninja room name...',
            icon: Icons.meeting_room,
          ),
          SizedBox(height: 20),
          
          // Room description
          _buildInputField(
            controller: _roomDescriptionController,
            label: 'Room Description',
            hint: 'Describe your room\'s purpose...',
            icon: Icons.description,
            maxLines: 3,
          ),
          SizedBox(height: 20),
          
          // Category selector
          Text(
            'CATEGORY',
            style: GoogleFonts.orbitron(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: roomCategories.length,
              itemBuilder: (context, index) {
                final category = roomCategories[index];
                final isSelected = selectedCategory == category;
                
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: NinjaCard(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      decoration: isSelected ? BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ) : null,
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          category,
                          style: GoogleFonts.rajdhani(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey.shade400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30),
          
          // Room settings
          NinjaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ROOM SETTINGS',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 20),
                
                // Private room toggle
                Row(
                  children: [
                    Icon(Icons.lock, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Private Room',
                        style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Switch(
                      value: isPrivateRoom,
                      onChanged: (value) {
                        setState(() {
                          isPrivateRoom = value;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade700),
                
                // Password protection toggle
                Row(
                  children: [
                    Icon(Icons.password, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Password Protection',
                        style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Switch(
                      value: requiresPassword,
                      onChanged: (value) {
                        setState(() {
                          requiresPassword = value;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ],
                ),
                
                if (requiresPassword) ...[
                  SizedBox(height: 16),
                  _buildInputField(
                    controller: _roomPasswordController,
                    label: 'Password',
                    hint: 'Enter room password...',
                    icon: Icons.key,
                    obscureText: true,
                  ),
                ],
                
                Divider(color: Colors.grey.shade700),
                
                // Max participants slider
                Text(
                  'Max Participants: $maxParticipants',
                  style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 16),
                ),
                Slider(
                  value: maxParticipants.toDouble(),
                  min: 2,
                  max: 100,
                  divisions: 98,
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey.shade600,
                  onChanged: (value) {
                    setState(() {
                      maxParticipants = value.round();
                    });
                  },
                ),
                
                Divider(color: Colors.grey.shade700),
                
                // Feature toggles
                _buildFeatureToggle(
                  'Allow Voice Messages',
                  Icons.record_voice_over,
                  allowVoiceMessages,
                  (value) => setState(() => allowVoiceMessages = value),
                ),
                _buildFeatureToggle(
                  'Allow File Sharing',
                  Icons.attach_file,
                  allowFileSharing,
                  (value) => setState(() => allowFileSharing = value),
                ),
                _buildFeatureToggle(
                  'Auto Moderation',
                  Icons.security,
                  autoModerationEnabled,
                  (value) => setState(() => autoModerationEnabled = value),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          
          // Create button
          Center(
            child: NinjaGradientButton(
              text: 'CREATE NINJA ROOM',
              icon: Icons.add_circle,
              width: double.infinity,
              height: 60,
              onPressed: _createRoom,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageRoomsTab() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        NinjaAnimatedText(
          text: 'YOUR ROOMS',
          textStyle: GoogleFonts.orbitron(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: 30),
        
        // Room list
        ...List.generate(3, (index) {
          final rooms = [
            {
              'name': 'Ninja Training Dojo',
              'participants': 25,
              'category': 'Training',
              'isActive': true,
              'isPrivate': false,
            },
            {
              'name': 'Shadow Council',
              'participants': 8,
              'category': 'Business',
              'isActive': true,
              'isPrivate': true,
            },
            {
              'name': 'Meditation Chamber',
              'participants': 12,
              'category': 'Wellness',
              'isActive': false,
              'isPrivate': false,
            },
          ];
          
          final room = rooms[index];
          
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: NinjaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      NinjaPulseEffect(
                        child: CircleAvatar(
                          backgroundColor: (room['isActive'] as bool) ? Colors.green : Colors.grey,
                          radius: 6,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          room['name'] as String,
                          style: GoogleFonts.orbitron(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (room['isPrivate'] as bool)
                        Icon(Icons.lock, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        color: Color(0xFF111111),
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(color: Colors.white))),
                          PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.white))),
                          PopupMenuItem(value: 'share', child: Text('Share', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.grey.shade400, size: 16),
                      SizedBox(width: 8),
                      Text(
                        room['category'] as String,
                        style: GoogleFonts.rajdhani(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.people, color: Colors.grey.shade400, size: 16),
                      SizedBox(width: 8),
                      Text(
                        '${room['participants']} users',
                        style: GoogleFonts.rajdhani(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildModerationTab() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        NinjaAnimatedText(
          text: 'MODERATION TOOLS',
          textStyle: GoogleFonts.orbitron(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: 30),
        
        // Quick actions
        Text(
          'QUICK ACTIONS',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 16),
        
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2,
          ),
          itemCount: moderationActions.length,
          itemBuilder: (context, index) {
            final action = moderationActions[index];
            return NinjaCard(
              onTap: () => _handleModerationAction(action['action']),
              child: Row(
                children: [
                  Icon(
                    action['icon'],
                    color: action['color'],
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      action['title'],
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        SizedBox(height: 30),
        
        // Active users list
        Text(
          'ACTIVE USERS',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 16),
        
        ...List.generate(5, (index) {
          final users = [
            {'name': 'ShadowNinja', 'status': 'Speaking', 'role': 'Member'},
            {'name': 'StealthMaster', 'status': 'Listening', 'role': 'Moderator'},
            {'name': 'DarkWarrior', 'status': 'Muted', 'role': 'Member'},
            {'name': 'NightCrawler', 'status': 'Speaking', 'role': 'Member'},
            {'name': 'MoonShadow', 'status': 'Listening', 'role': 'VIP'},
          ];
          
          final user = users[index];
          
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: NinjaCard(
              child: ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade700,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    if (user['status'] == 'Speaking')
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
                title: Text(
                  user['name'] as String,
                  style: GoogleFonts.orbitron(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  '${user['status']} • ${user['role']}',
                  style: GoogleFonts.rajdhani(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  color: Color(0xFF111111),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'mute', child: Text('Mute', style: TextStyle(color: Colors.white))),
                    PopupMenuItem(value: 'kick', child: Text('Kick', style: TextStyle(color: Colors.white))),
                    PopupMenuItem(value: 'ban', child: Text('Ban', style: TextStyle(color: Colors.white))),
                    PopupMenuItem(value: 'promote', child: Text('Promote', style: TextStyle(color: Colors.white))),
                  ],
                  onSelected: (value) => _handleUserAction(user['name'] as String, value!),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF111111),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade700),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            obscureText: obscureText,
            style: GoogleFonts.rajdhani(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white),
              hintText: hint,
              hintStyle: GoogleFonts.rajdhani(color: Colors.grey.shade500),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureToggle(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 16),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void _createRoom() {
    if (_roomNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a room name',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Create room logic here
    Get.snackbar(
      '⚡ ROOM CREATED',
      'Your ninja room "${_roomNameController.text}" is now active!',
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(Icons.check_circle, color: Colors.white),
      duration: Duration(seconds: 3),
    );
    
    // Clear form
    _roomNameController.clear();
    _roomDescriptionController.clear();
    _roomPasswordController.clear();
    setState(() {
      selectedCategory = 'General';
      isPrivateRoom = false;
      requiresPassword = false;
      maxParticipants = 50;
    });
  }

  void _handleModerationAction(String action) {
    Get.snackbar(
      'Moderation Action',
      'Executed $action action',
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _handleUserAction(String username, String action) {
    Get.snackbar(
      'User Action',
      'Applied $action to $username',
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _roomNameController.dispose();
    _roomDescriptionController.dispose();
    _roomPasswordController.dispose();
    super.dispose();
  }
}