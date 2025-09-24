import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEffectsEnabled = true;
  bool _autoJoinEnabled = false;
  bool _backgroundModeEnabled = true;
  bool _pushToTalkEnabled = false;
  double _micSensitivity = 0.7;
  double _outputVolume = 0.8;
  String _audioQuality = 'High';
  String _theme = 'Dark';
  
  final List<String> _audioQualities = ['Low', 'Medium', 'High', 'Ultra'];
  final List<String> _themes = ['Dark', 'Light', 'Auto'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1976D2),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Audio Settings
          _buildSectionHeader('Audio Settings'),
          Card(
            child: Column(
              children: [
                _buildSliderTile(
                  'Microphone Sensitivity',
                  Icons.mic,
                  _micSensitivity,
                  (value) => setState(() => _micSensitivity = value),
                ),
                _buildDivider(),
                _buildSliderTile(
                  'Output Volume',
                  Icons.volume_up,
                  _outputVolume,
                  (value) => setState(() => _outputVolume = value),
                ),
                _buildDivider(),
                _buildDropdownTile(
                  'Audio Quality',
                  Icons.high_quality,
                  _audioQuality,
                  _audioQualities,
                  (value) => setState(() => _audioQuality = value!),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  'Push to Talk',
                  Icons.push_pin,
                  _pushToTalkEnabled,
                  (value) => setState(() => _pushToTalkEnabled = value),
                  subtitle: 'Hold spacebar to speak',
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          // Notifications & Behavior
          _buildSectionHeader('Notifications & Behavior'),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  'Notifications',
                  Icons.notifications,
                  _notificationsEnabled,
                  (value) => setState(() => _notificationsEnabled = value),
                  subtitle: 'Get notified about room activities',
                ),
                _buildDivider(),
                _buildSwitchTile(
                  'Sound Effects',
                  Icons.music_note,
                  _soundEffectsEnabled,
                  (value) => setState(() => _soundEffectsEnabled = value),
                  subtitle: 'Play sounds for join/leave events',
                ),
                _buildDivider(),
                _buildSwitchTile(
                  'Auto-join last room',
                  Icons.auto_awesome,
                  _autoJoinEnabled,
                  (value) => setState(() => _autoJoinEnabled = value),
                  subtitle: 'Automatically rejoin your last room',
                ),
                _buildDivider(),
                _buildSwitchTile(
                  'Background Mode',
                  Icons.apps,
                  _backgroundModeEnabled,
                  (value) => setState(() => _backgroundModeEnabled = value),
                  subtitle: 'Stay connected when app is minimized',
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          // Appearance
          _buildSectionHeader('Appearance'),
          Card(
            child: Column(
              children: [
                _buildDropdownTile(
                  'Theme',
                  Icons.palette,
                  _theme,
                  _themes,
                  (value) => setState(() => _theme = value!),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          // Advanced
          _buildSectionHeader('Advanced'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.bug_report, color: Color(0xFF1976D2)),
                  title: Text('Send Feedback', style: GoogleFonts.inter()),
                  subtitle: Text('Report bugs or suggest features', style: GoogleFonts.inter(fontSize: 12)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showFeedbackDialog(),
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.info, color: Color(0xFF1976D2)),
                  title: Text('About', style: GoogleFonts.inter()),
                  subtitle: Text('App version and information', style: GoogleFonts.inter(fontSize: 12)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showAboutDialog(),
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.restore, color: Color(0xFF1976D2)),
                  title: Text('Reset Settings', style: GoogleFonts.inter()),
                  subtitle: Text('Restore default settings', style: GoogleFonts.inter(fontSize: 12)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showResetDialog(),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 40),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF03DAC6),
        ),
      ),
    );
  }
  
  Widget _buildSwitchTile(String title, IconData icon, bool value, Function(bool) onChanged, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF1976D2)),
      title: Text(title, style: GoogleFonts.inter()),
      subtitle: subtitle != null ? Text(subtitle, style: GoogleFonts.inter(fontSize: 12)) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFF03DAC6),
      ),
    );
  }
  
  Widget _buildSliderTile(String title, IconData icon, double value, Function(double) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF1976D2)),
      title: Text(title, style: GoogleFonts.inter()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF03DAC6),
            inactiveColor: Colors.grey.shade300,
          ),
          Text('${(value * 100).round()}%', style: GoogleFonts.inter(fontSize: 12)),
        ],
      ),
    );
  }
  
  Widget _buildDropdownTile(String title, IconData icon, String value, List<String> items, Function(String?) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF1976D2)),
      title: Text(title, style: GoogleFonts.inter()),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        underline: Container(),
      ),
    );
  }
  
  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.shade300);
  }
  
  void _showFeedbackDialog() {
    Get.defaultDialog(
      title: 'Send Feedback',
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your feedback...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
        ],
      ),
      textConfirm: 'Send',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
        Get.snackbar('Feedback Sent', 'Thank you for your feedback!', backgroundColor: Colors.green, colorText: Colors.white);
      },
    );
  }
  
  void _showAboutDialog() {
    Get.defaultDialog(
      title: 'About AudioRoom',
      middleText: 'AudioRoom v1.0.0\n\nA modern audio chat application built with Flutter.\n\n© 2024 AudioRoom Team',
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Color(0xFF1976D2),
      onConfirm: () => Get.back(),
    );
  }
  
  void _showResetDialog() {
    Get.defaultDialog(
      title: 'Reset Settings',
      middleText: 'Are you sure you want to reset all settings to default values?',
      textConfirm: 'Reset',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        setState(() {
          _notificationsEnabled = true;
          _soundEffectsEnabled = true;
          _autoJoinEnabled = false;
          _backgroundModeEnabled = true;
          _pushToTalkEnabled = false;
          _micSensitivity = 0.7;
          _outputVolume = 0.8;
          _audioQuality = 'High';
          _theme = 'Dark';
        });
        Get.back();
        Get.snackbar('Settings Reset', 'All settings have been reset to default', backgroundColor: Colors.orange, colorText: Colors.white);
      },
    );
  }
}