import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/transcription_controller.dart';

class TranscriptionScreen extends StatelessWidget {
  final TranscriptionController controller = Get.put(TranscriptionController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1421),
      appBar: AppBar(
        title: Text(
          'Live Transcription',
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: _showSettingsDialog,
          ),
          IconButton(
            icon: Icon(Icons.download, color: Colors.white),
            onPressed: controller.exportTranscription,
          ),
        ],
      ),
      body: Column(
        children: [
          // Control Panel
          _buildControlPanel(),
          
          // Language Selection
          _buildLanguageSelector(),
          
          // Statistics Bar
          _buildStatisticsBar(),
          
          // Transcription Messages
          Expanded(
            child: _buildTranscriptionList(),
          ),
        ],
      ),
      floatingActionButton: Obx(() => FloatingActionButton(
        onPressed: controller.toggleTranscription,
        backgroundColor: controller.isListening.value 
            ? Colors.red 
            : Color(0xFF1976D2),
        child: Icon(
          controller.isListening.value 
              ? Icons.stop 
              : Icons.mic,
          color: Colors.white,
        ),
      )),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          // Transcription Toggle
          Expanded(
            child: Obx(() => SwitchListTile(
              title: Text(
                'Transcription',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                controller.isListening.value ? 'Listening...' : 'Stopped',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: controller.isListening.value ? Color(0xFF03DAC6) : Colors.white60,
                ),
              ),
              value: controller.isTranscriptionEnabled.value,
              onChanged: (_) => controller.toggleTranscription(),
              activeColor: Color(0xFF03DAC6),
              dense: true,
            )),
          ),
          
          // Translation Toggle
          Expanded(
            child: Obx(() => SwitchListTile(
              title: Text(
                'Translation',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                controller.isTranslationEnabled.value ? 'Active' : 'Disabled',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: controller.isTranslationEnabled.value ? Color(0xFF03DAC6) : Colors.white60,
                ),
              ),
              value: controller.isTranslationEnabled.value,
              onChanged: (_) => controller.toggleTranslation(),
              activeColor: Color(0xFF03DAC6),
              dense: true,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          // Input Language
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Input Language',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                SizedBox(height: 8),
                Obx(() => GestureDetector(
                  onTap: () => _showLanguageDialog(true),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF334155),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          controller.getLanguageFlag(controller.currentLanguage.value),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 8),
                        Text(
                          controller.getLanguageDisplayName(controller.currentLanguage.value),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_drop_down, color: Colors.white60),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          
          SizedBox(width: 16),
          
          // Arrow
          Icon(Icons.arrow_forward, color: Color(0xFF03DAC6)),
          
          SizedBox(width: 16),
          
          // Output Language
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Translation Language',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                SizedBox(height: 8),
                Obx(() => GestureDetector(
                  onTap: () => _showLanguageDialog(false),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: controller.isTranslationEnabled.value 
                          ? Color(0xFF334155) 
                          : Color(0xFF334155).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          controller.getLanguageFlag(controller.targetLanguage.value),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 8),
                        Text(
                          controller.getLanguageDisplayName(controller.targetLanguage.value),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: controller.isTranslationEnabled.value 
                                ? Colors.white 
                                : Colors.white60,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_drop_down, color: Colors.white60),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsBar() {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF334155),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          _buildStatItem(
            'Messages',
            '${controller.transcriptionMessages.length}',
            Icons.message,
          ),
          SizedBox(width: 16),
          _buildStatItem(
            'Words',
            '${controller.totalWordsTranscribed.value}',
            Icons.text_fields,
          ),
          SizedBox(width: 16),
          _buildStatItem(
            'Accuracy',
            '${(controller.averageConfidence.value * 100).toStringAsFixed(0)}%',
            Icons.verified,
          ),
          Spacer(),
          if (controller.transcriptionMessages.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear_all, color: Colors.white60),
              onPressed: () {
                Get.defaultDialog(
                  title: 'Clear Transcription',
                  middleText: 'Are you sure you want to clear all transcriptions?',
                  textConfirm: 'Clear',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () {
                    controller.clearTranscriptions();
                    Get.back();
                  },
                );
              },
            ),
        ],
      ),
    ));
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF03DAC6), size: 16),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTranscriptionList() {
    return Obx(() {
      final messages = controller.getFilteredMessages();
      
      if (messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mic_off,
                size: 64,
                color: Colors.white30,
              ),
              SizedBox(height: 16),
              Text(
                controller.isTranscriptionEnabled.value
                    ? 'Listening for speech...'
                    : 'Start transcription to see live text',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        );
      }

      // Auto-scroll to bottom when new messages arrive
      if (controller.isAutoScrollEnabled.value) {
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

      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return _buildMessageCard(message);
        },
      );
    });
  }

  Widget _buildMessageCard(TranscriptionMessage message) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speaker and timestamp
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: message.speaker == 'You' 
                      ? Color(0xFF03DAC6) 
                      : Color(0xFF1976D2),
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.speaker,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (controller.showTimestamps.value)
                        Text(
                          _formatTimestamp(message.timestamp),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                    ],
                  ),
                ),
                if (controller.showConfidenceScores.value)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(message.confidence).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getConfidenceColor(message.confidence)),
                    ),
                    child: Text(
                      '${(message.confidence * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getConfidenceColor(message.confidence),
                      ),
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Original text
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.text,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
            
            // Translation (if available)
            if (controller.isTranslationEnabled.value && 
                message.translations.containsKey(controller.targetLanguage.value)) ...[
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF03DAC6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF03DAC6).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          controller.getLanguageFlag(controller.targetLanguage.value),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Translation',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Color(0xFF03DAC6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      message.translations[controller.targetLanguage.value]!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(bool isInputLanguage) {
    Get.defaultDialog(
      title: isInputLanguage ? 'Select Input Language' : 'Select Translation Language',
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: TranscriptionLanguage.values.length,
          itemBuilder: (context, index) {
            final language = TranscriptionLanguage.values[index];
            final isSelected = isInputLanguage 
                ? controller.currentLanguage.value == language
                : controller.targetLanguage.value == language;
            
            return ListTile(
              leading: Text(
                controller.getLanguageFlag(language),
                style: TextStyle(fontSize: 24),
              ),
              title: Text(
                controller.getLanguageDisplayName(language),
                style: GoogleFonts.inter(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: isSelected ? Icon(Icons.check, color: Color(0xFF03DAC6)) : null,
              onTap: () {
                if (isInputLanguage) {
                  controller.setTranscriptionLanguage(language);
                } else {
                  controller.setTargetLanguage(language);
                }
                Get.back();
              },
            );
          },
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    Get.defaultDialog(
      title: 'Transcription Settings',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => SwitchListTile(
            title: Text('Auto Scroll'),
            subtitle: Text('Automatically scroll to new messages'),
            value: controller.isAutoScrollEnabled.value,
            onChanged: (value) => controller.isAutoScrollEnabled.value = value,
            activeColor: Color(0xFF03DAC6),
          )),
          Obx(() => SwitchListTile(
            title: Text('Show Timestamps'),
            subtitle: Text('Display message timestamps'),
            value: controller.showTimestamps.value,
            onChanged: (value) => controller.showTimestamps.value = value,
            activeColor: Color(0xFF03DAC6),
          )),
          Obx(() => SwitchListTile(
            title: Text('Show Confidence Scores'),
            subtitle: Text('Display transcription accuracy'),
            value: controller.showConfidenceScores.value,
            onChanged: (value) => controller.showConfidenceScores.value = value,
            activeColor: Color(0xFF03DAC6),
          )),
          SizedBox(height: 16),
          Text('Minimum Confidence Threshold'),
          Obx(() => Slider(
            value: controller.minConfidenceThreshold.value,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: '${(controller.minConfidenceThreshold.value * 100).round()}%',
            onChanged: (value) => controller.minConfidenceThreshold.value = value,
            activeColor: Color(0xFF03DAC6),
          )),
        ],
      ),
      textConfirm: 'Done',
      confirmTextColor: Colors.white,
      buttonColor: Color(0xFF1976D2),
      onConfirm: () => Get.back(),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}