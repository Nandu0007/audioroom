import 'package:audioroom/screens/signin_screen.dart';
import 'package:audioroom/screens/edit_profile_screen.dart';
import 'package:audioroom/screens/analytics_screen.dart';
import 'package:audioroom/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String userName = 'Demo User';
  String userEmail = 'demo@audioroom.com';
  String userBio = 'Music lover and tech enthusiast';
  String userStatus = 'Online';
  String memberSince = 'March 2024';
  IconData selectedAvatar = Icons.account_circle;
  bool isOnline = true;
  
  // Enhanced user statistics
  final Map<String, dynamic> userStats = {
    'roomsJoined': 45,
    'totalTimeSpent': 127,
    'averageSessionTime': 35,
    'favoriteCategory': 'Tech Talk',
    'weeklyRank': 15,
    'totalFriends': 28,
    'level': 12,
    'xp': 2450,
    'nextLevelXp': 3000,
  };
  
  // Recent activities
  final List<Map<String, dynamic>> recentActivities = [
    {'action': 'Joined', 'room': 'Tech Talk', 'time': '2 hours ago'},
    {'action': 'Created', 'room': 'Morning Chat', 'time': '1 day ago'},
    {'action': 'Spoke in', 'room': 'Book Club', 'time': '2 days ago'},
    {'action': 'Joined', 'room': 'Music Lounge', 'time': '3 days ago'},
  ];
  
  // Achievements
  final List<Map<String, dynamic>> achievements = [
    {'name': 'Early Bird', 'icon': Icons.wb_sunny, 'unlocked': true},
    {'name': 'Night Owl', 'icon': Icons.nightlight_round, 'unlocked': true},
    {'name': 'Social Butterfly', 'icon': Icons.people, 'unlocked': false},
    {'name': 'Marathon Speaker', 'icon': Icons.mic, 'unlocked': true},
  ];

  void _updateProfile(String newName, String newEmail) {
    setState(() {
      userName = newName;
      userEmail = newEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 260,
                floating: false,
                pinned: true,
                backgroundColor: Color(0xFF1976D2),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProfileHeader(),
                ),
                bottom: TabBar(
                  indicatorColor: Color(0xFF03DAC6),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Activity'),
                    Tab(text: 'Stats'),
                    Tab(text: 'Settings'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildOverviewTab(),
              _buildActivityTab(),
              _buildStatsTab(),
              _buildSettingsTab(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1976D2),
            Color(0xFF1565C0),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0xFF03DAC6), Color(0xFF1976D2)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  selectedAvatar,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    isOnline ? Icons.circle : Icons.circle_outlined,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            userName,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            userEmail,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Color(0xFF03DAC6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              userStatus,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Quick Stats Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard('Rooms', '${userStats['roomsJoined']}', Icons.groups, Color(0xFF03DAC6)),
            _buildStatCard('Hours', '${userStats['totalTimeSpent']}', Icons.schedule, Color(0xFF1976D2)),
            _buildStatCard('Level', '${userStats['level']}', Icons.star, Colors.orange),
            _buildStatCard('Rank', '#${userStats['weeklyRank']}', Icons.leaderboard, Colors.green),
          ],
        ),
        
        SizedBox(height: 20),
        
        // Level Progress
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level Progress',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${userStats['xp']}/${userStats['nextLevelXp']} XP',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: userStats['xp'] / userStats['nextLevelXp'],
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF03DAC6)),
                ),
                SizedBox(height: 8),
                Text(
                  '${userStats['nextLevelXp'] - userStats['xp']} XP to level ${userStats['level'] + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 20),
        
        // Quick Actions
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => EditProfileScreen(
                            currentName: userName,
                            currentEmail: userEmail,
                            onProfileUpdated: _updateProfile,
                          ));
                        },
                        icon: Icon(Icons.edit),
                        label: Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Get.to(() => AnalyticsScreen()),
                        icon: Icon(Icons.analytics),
                        label: Text('Analytics'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF1976D2),
                          side: BorderSide(color: Color(0xFF1976D2)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Recent Activities
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activities',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                ...recentActivities.map((activity) => _buildActivityItem(activity)),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Achievements
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievements',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = achievements[index];
                    final bool unlocked = achievement['unlocked'] as bool;
                    return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: unlocked ? Color(0xFF1976D2).withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: unlocked ? Color(0xFF03DAC6) : Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            achievement['icon'] as IconData,
                            color: unlocked ? Color(0xFF03DAC6) : Colors.grey,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              achievement['name'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: unlocked ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Detailed Statistics
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detailed Statistics',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                _buildStatRow('Total Time Spent', '${userStats['totalTimeSpent']} hours', Icons.schedule),
                _buildStatRow('Average Session', '${userStats['averageSessionTime']} minutes', Icons.timer),
                _buildStatRow('Favorite Category', userStats['favoriteCategory'], Icons.favorite),
                _buildStatRow('Total Friends', '${userStats['totalFriends']}', Icons.people),
                _buildStatRow('Member Since', memberSince, Icons.calendar_today),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 16),
        
        // View Full Analytics Button
        Card(
          child: ListTile(
            leading: Icon(Icons.analytics, color: Color(0xFF1976D2)),
            title: Text(
              'View Full Analytics',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Detailed usage statistics and insights',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
            onTap: () => Get.to(() => AnalyticsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Account Settings
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.settings, color: Color(0xFF1976D2)),
                title: Text('App Settings', style: GoogleFonts.inter(color: Colors.white)),
                subtitle: Text('Audio, notifications, and preferences', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
                onTap: () => Get.to(() => SettingsScreen()),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.privacy_tip, color: Color(0xFF1976D2)),
                title: Text('Privacy', style: GoogleFonts.inter(color: Colors.white)),
                subtitle: Text('Manage your privacy settings', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
                onTap: () {
                  Get.snackbar('Coming Soon', 'Privacy settings will be available soon', backgroundColor: Colors.blue, colorText: Colors.white);
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.help_outline, color: Color(0xFF1976D2)),
                title: Text('Help & Support', style: GoogleFonts.inter(color: Colors.white)),
                subtitle: Text('Get help and contact support', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
                onTap: () {
                  Get.defaultDialog(
                    title: 'Help & Support',
                    middleText: 'Contact us at support@audioroom.com\nor visit our help center for assistance.',
                    textConfirm: 'OK',
                    confirmTextColor: Colors.white,
                    buttonColor: Color(0xFF1976D2),
                    onConfirm: () => Get.back(),
                  );
                },
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16),
        
        // Danger Zone
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Sign Out', style: GoogleFonts.inter(color: Colors.red)),
                subtitle: Text('Sign out of your account', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                onTap: () => _showSignOutDialog(),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: Text('Delete Account', style: GoogleFonts.inter(color: Colors.red)),
                subtitle: Text('Permanently delete your account', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                onTap: () => _showDeleteAccountDialog(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1976D2).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getActivityIcon(activity['action']),
              size: 16,
              color: Color(0xFF03DAC6),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity['action']} ${activity['room']}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  activity['time'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF1976D2), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String action) {
    switch (action) {
      case 'Joined':
        return Icons.login;
      case 'Created':
        return Icons.add_circle;
      case 'Spoke in':
        return Icons.mic;
      default:
        return Icons.circle;
    }
  }

  void _showSignOutDialog() {
    Get.defaultDialog(
      title: "Sign Out",
      middleText: "Are you sure you want to sign out?",
      textConfirm: "Sign Out",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        Get.offAll(() => SignInPage());
        Get.snackbar(
          "Signed Out",
          "You have been successfully signed out",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    Get.defaultDialog(
      title: "Delete Account",
      middleText: "This action cannot be undone. All your data will be permanently deleted.",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        Get.snackbar(
          "Account Deletion",
          "Account deletion request submitted. You will receive a confirmation email.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }
}
