import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/screen_sharing_controller.dart';

class ScreenSharingScreen extends StatelessWidget {
  final ScreenSharingController controller = Get.put(ScreenSharingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1421),
      appBar: AppBar(
        title: Text(
          'Screen Sharing',
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
      body: Obx(() => controller.isViewingSharedScreen.value 
          ? _buildViewerInterface() 
          : _buildSharingInterface()),
    );
  }

  Widget _buildSharingInterface() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(),
          SizedBox(height: 24),
          if (!controller.isSharing) ...[
            _buildStartSharingSection(),
            SizedBox(height: 24),
          ],
          if (controller.isSharing) ...[
            _buildActiveShareControls(),
            SizedBox(height: 24),
            _buildShareStatistics(),
            SizedBox(height: 24),
          ],
          _buildAvailableShares(),
        ],
      ),
    );
  }

  Widget _buildViewerInterface() {
    return Column(
      children: [
        // Viewer Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: Color(0xFF1E293B),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.screen_share, color: Color(0xFF03DAC6), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Viewing ${controller.sharerName.value}\'s screen',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          controller.sharedScreenTitle.value.isNotEmpty 
                              ? controller.sharedScreenTitle.value 
                              : 'Screen Share',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.leaveScreenShare,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Leave', style: GoogleFonts.inter()),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Shared Screen Display
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.black,
            child: _buildSharedScreenPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: _getStatusColor(), width: 2),
                  ),
                  child: Icon(
                    _getStatusIcon(),
                    color: _getStatusColor(),
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Screen Share Status',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        controller.getStateDisplayName(),
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.isSharing)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF03DAC6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFF03DAC6)),
                    ),
                    child: Text(
                      '${controller.viewerCount.value} viewers',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF03DAC6),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartSharingSection() {
    return Card(
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Start Screen Sharing',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            
            // Quality Selection
            Text(
              'Quality',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: ScreenShareQuality.values.map((quality) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Obx(() => _buildQualityOption(quality)),
                  ),
                );
              }).toList(),
            ),
            
            SizedBox(height: 20),
            
            // Audio sharing toggle
            Row(
              children: [
                Obx(() => Checkbox(
                  value: controller.isAudioShared.value,
                  onChanged: (value) => controller.isAudioShared.value = value ?? false,
                  activeColor: Color(0xFF03DAC6),
                )),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Share system audio',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Start button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.canStartSharing 
                    ? () => controller.startScreenShare(
                        quality: controller.shareQuality.value,
                        shareAudio: controller.isAudioShared.value,
                      )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isRequesting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Starting...', style: GoogleFonts.inter()),
                        ],
                      )
                    : Text(
                        'Start Screen Share',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveShareControls() {
    return Card(
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share Controls',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildControlButton(
                    'Change Quality',
                    Icons.high_quality,
                    () => _showQualityDialog(),
                    Color(0xFF03DAC6),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildControlButton(
                    controller.isAudioShared.value ? 'Audio: On' : 'Audio: Off',
                    controller.isAudioShared.value ? Icons.volume_up : Icons.volume_off,
                    controller.toggleAudioShare,
                    controller.isAudioShared.value ? Color(0xFF4CAF50) : Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.stopScreenShare,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Stop Sharing',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareStatistics() {
    return Card(
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share Statistics',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatItem('Resolution', controller.resolution.value)),
                Expanded(child: _buildStatItem('Frame Rate', '${controller.frameRate.value} fps')),
                Expanded(child: _buildStatItem('Bitrate', '${controller.bitrate.value} kbps')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableShares() {
    return Card(
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Shares',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            
            // Demo available shares
            _buildShareItem('Alice Johnson', 'Presentation: Project Updates', true),
            _buildShareItem('Mike Davis', 'Screen Recording', false),
            _buildShareItem('Sarah Wilson', 'Code Review Session', false),
            
            SizedBox(height: 16),
            Text(
              'Tap on any active share to join',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white60,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityOption(ScreenShareQuality quality) {
    bool isSelected = controller.shareQuality.value == quality;
    
    return GestureDetector(
      onTap: () => controller.shareQuality.value = quality,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF1976D2).withOpacity(0.3) : Color(0xFF334155),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Color(0xFF1976D2) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            controller.getQualityDisplayName(quality),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Color(0xFF03DAC6) : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(String label, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF03DAC6),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildShareItem(String sharerName, String title, bool isActive) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isActive ? Color(0xFF03DAC6) : Color(0xFF666666),
        child: Icon(
          isActive ? Icons.screen_share : Icons.stop_screen_share,
          color: isActive ? Colors.black : Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        sharerName,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.white60,
        ),
      ),
      trailing: isActive
          ? ElevatedButton(
              onPressed: () => controller.joinScreenShare(sharerName, title),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1976D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Join', style: GoogleFonts.inter(fontSize: 12)),
            )
          : Text(
              'Offline',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
    );
  }

  Widget _buildSharedScreenPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFF1976D2).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF1976D2), width: 2),
            ),
            child: Icon(
              Icons.desktop_windows,
              size: 50,
              color: Color(0xFF03DAC6),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Shared Screen Content',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This is a placeholder for the actual shared screen content',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  void _showQualityDialog() {
    Get.defaultDialog(
      title: 'Change Quality',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ScreenShareQuality.values.map((quality) {
          return Obx(() => RadioListTile<ScreenShareQuality>(
            title: Text(
              controller.getQualityDisplayName(quality),
              style: GoogleFonts.inter(),
            ),
            value: quality,
            groupValue: controller.shareQuality.value,
            onChanged: (value) {
              if (value != null) {
                controller.changeQuality(value);
                Get.back();
              }
            },
            activeColor: Color(0xFF1976D2),
          ));
        }).toList(),
      ),
    );
  }

  Color _getStatusColor() {
    switch (controller.shareState.value) {
      case ScreenShareState.idle:
        return Color(0xFF9E9E9E);
      case ScreenShareState.requesting:
        return Color(0xFFFF9800);
      case ScreenShareState.sharing:
        return Color(0xFF03DAC6);
      case ScreenShareState.error:
        return Color(0xFFFF5722);
    }
  }

  IconData _getStatusIcon() {
    switch (controller.shareState.value) {
      case ScreenShareState.idle:
        return Icons.screen_share_outlined;
      case ScreenShareState.requesting:
        return Icons.hourglass_empty;
      case ScreenShareState.sharing:
        return Icons.screen_share;
      case ScreenShareState.error:
        return Icons.error_outline;
    }
  }
}