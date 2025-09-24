import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class AnalyticsScreen extends StatelessWidget {
  // Demo data - in a real app, this would come from your backend
  final Map<String, dynamic> analytics = {
    'totalRoomsJoined': 45,
    'totalTimeSpent': 127, // in hours
    'averageSessionTime': 35, // in minutes
    'favoriteCategory': 'Tech Talk',
    'peakUsageHour': '8 PM',
    'weeklyGrowth': 12.5,
    'monthlyStats': [
      {'week': 'Week 1', 'hours': 25},
      {'week': 'Week 2', 'hours': 32},
      {'week': 'Week 3', 'hours': 28},
      {'week': 'Week 4', 'hours': 42},
    ],
    'categoryBreakdown': [
      {'category': 'Tech Talk', 'percentage': 35, 'hours': 44},
      {'category': 'Music Chat', 'percentage': 25, 'hours': 32},
      {'category': 'General Discussion', 'percentage': 20, 'hours': 25},
      {'category': 'Study Group', 'percentage': 15, 'hours': 19},
      {'category': 'Book Club', 'percentage': 5, 'hours': 7},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Analytics',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1976D2),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Get.snackbar(
                'Analytics Updated',
                'Your latest statistics have been refreshed',
                backgroundColor: Color(0xFF03DAC6),
                colorText: Colors.black,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Quick Stats Overview
          _buildQuickStatsGrid(),
          
          SizedBox(height: 20),
          
          // Weekly Usage Chart
          _buildWeeklyUsageChart(),
          
          SizedBox(height: 20),
          
          // Category Breakdown
          _buildCategoryBreakdown(),
          
          SizedBox(height: 20),
          
          // Achievements
          _buildAchievements(),
          
          SizedBox(height: 20),
          
          // Usage Insights
          _buildUsageInsights(),
        ],
      ),
    );
  }

  Widget _buildQuickStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard(
          'Total Rooms',
          '${analytics['totalRoomsJoined']}',
          Icons.groups,
          Color(0xFF03DAC6),
        ),
        _buildStatCard(
          'Time Spent',
          '${analytics['totalTimeSpent']}h',
          Icons.schedule,
          Color(0xFF1976D2),
        ),
        _buildStatCard(
          'Avg. Session',
          '${analytics['averageSessionTime']}m',
          Icons.timer,
          Colors.orange,
        ),
        _buildStatCard(
          'Growth',
          '+${analytics['weeklyGrowth']}%',
          Icons.trending_up,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
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

  Widget _buildWeeklyUsageChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Usage',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: analytics['monthlyStats'].map<Widget>((week) {
                  double height = (week['hours'] / 50.0) * 150; // Max height 150
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 40,
                        height: height,
                        decoration: BoxDecoration(
                          color: Color(0xFF03DAC6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        week['week'],
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '${week['hours']}h',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            ...analytics['categoryBreakdown'].map<Widget>((category) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category['category'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${category['hours']}h (${category['percentage']}%)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: category['percentage'] / 100.0,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {'title': 'Early Bird', 'description': 'Joined 5 morning sessions', 'icon': Icons.wb_sunny, 'unlocked': true},
      {'title': 'Night Owl', 'description': 'Active after 10 PM', 'icon': Icons.nightlight_round, 'unlocked': true},
      {'title': 'Social Butterfly', 'description': 'Joined 50+ rooms', 'icon': Icons.people, 'unlocked': false},
      {'title': 'Marathon Speaker', 'description': 'Spoke for 2+ hours straight', 'icon': Icons.mic, 'unlocked': true},
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
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
                final bool isUnlocked = achievement['unlocked'] as bool;
                final IconData icon = achievement['icon'] as IconData;
                final String title = achievement['title'] as String;
                final String description = achievement['description'] as String;
                
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isUnlocked ? Color(0xFF1976D2).withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isUnlocked ? Color(0xFF03DAC6) : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: isUnlocked ? Color(0xFF03DAC6) : Colors.grey,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isUnlocked ? Colors.white : Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              description,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: isUnlocked ? Colors.white70 : Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
    );
  }

  Widget _buildUsageInsights() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Insights',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            _buildInsightRow(
              Icons.favorite,
              'Favorite Category',
              analytics['favoriteCategory'],
              Color(0xFF03DAC6),
            ),
            _buildInsightRow(
              Icons.access_time,
              'Peak Usage Time',
              analytics['peakUsageHour'],
              Colors.orange,
            ),
            _buildInsightRow(
              Icons.trending_up,
              'Weekly Growth',
              '+${analytics['weeklyGrowth']}%',
              Colors.green,
            ),
            _buildInsightRow(
              Icons.schedule,
              'Average Session',
              '${analytics['averageSessionTime']} minutes',
              Color(0xFF1976D2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(IconData icon, String title, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}