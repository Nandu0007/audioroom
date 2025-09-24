import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/soundboard_controller.dart';

class SoundboardScreen extends StatelessWidget {
  final SoundboardController controller = Get.put(SoundboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1421),
      appBar: AppBar(
        title: Text(
          'Soundboard',
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
          Obx(() => IconButton(
            icon: Icon(
              controller.isMuted.value ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: controller.toggleMute,
          )),
        ],
      ),
      body: DefaultTabController(
        length: 6,
        child: Column(
          children: [
            // Background Music Section
            _buildBackgroundMusicSection(),
            
            // Category Tabs
            Container(
              color: Color(0xFF1E293B),
              child: TabBar(
                isScrollable: true,
                indicatorColor: Color(0xFF03DAC6),
                labelColor: Color(0xFF03DAC6),
                unselectedLabelColor: Colors.white60,
                tabs: SoundCategory.values.map((category) {
                  return Tab(
                    icon: Text(
                      controller.getCategoryIcon(category),
                      style: TextStyle(fontSize: 16),
                    ),
                    text: controller.getCategoryDisplayName(category),
                  );
                }).toList(),
              ),
            ),
            
            // Sound Effects Grid
            Expanded(
              child: TabBarView(
                children: SoundCategory.values.map((category) {
                  return _buildSoundGrid(category);
                }).toList(),
              ),
            ),
            
            // Queue Section
            _buildQueueSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundMusicSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.music_note, color: Color(0xFF03DAC6)),
              SizedBox(width: 8),
              Text(
                'Background Music',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Obx(() => Switch(
                value: controller.isBackgroundMusicEnabled.value,
                onChanged: (_) => controller.toggleBackgroundMusic(),
                activeColor: Color(0xFF03DAC6),
              )),
            ],
          ),
          SizedBox(height: 12),
          Obx(() => controller.currentBackgroundMusic.value != null
              ? Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF334155),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        controller.currentBackgroundMusic.value!.icon,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.currentBackgroundMusic.value!.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              controller.currentBackgroundMusic.value!.description,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.stop, color: Colors.white),
                        onPressed: () => controller.setBackgroundMusic(null),
                      ),
                    ],
                  ),
                )
              : Text(
                  'No background music selected',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                )),
          SizedBox(height: 12),
          
          // Volume Controls
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Music Volume',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    Obx(() => Slider(
                      value: controller.backgroundMusicVolume.value,
                      onChanged: controller.setBackgroundMusicVolume,
                      activeColor: Color(0xFF03DAC6),
                      inactiveColor: Colors.white24,
                    )),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Effects Volume',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    Obx(() => Slider(
                      value: controller.soundEffectVolume.value,
                      onChanged: controller.setSoundEffectVolume,
                      activeColor: Color(0xFF03DAC6),
                      inactiveColor: Colors.white24,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundGrid(SoundCategory category) {
    final sounds = controller.getSoundsByCategory(category);
    
    return Padding(
      padding: EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: sounds.length,
        itemBuilder: (context, index) {
          final sound = sounds[index];
          return _buildSoundCard(sound);
        },
      ),
    );
  }

  Widget _buildSoundCard(SoundItem sound) {
    return Obx(() {
      final isPlaying = controller.isSoundPlaying(sound.id);
      
      return GestureDetector(
        onTap: () {
          if (sound.category == SoundCategory.music || 
              sound.category == SoundCategory.ambient) {
            controller.setBackgroundMusic(sound);
          } else {
            controller.playSound(sound);
          }
        },
        onLongPress: () => _showSoundOptions(sound),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPlaying 
                ? Color(0xFF1976D2).withOpacity(0.3)
                : Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPlaying ? Color(0xFF1976D2) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sound.icon,
                style: TextStyle(fontSize: 32),
              ),
              SizedBox(height: 8),
              Text(
                sound.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPlaying ? Color(0xFF03DAC6) : Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                sound.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.white60,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _formatDuration(sound.duration),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Color(0xFF03DAC6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildQueueSection() {
    return Obx(() => controller.soundQueue.isNotEmpty
        ? Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E293B),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.queue_music, color: Color(0xFF03DAC6)),
                    SizedBox(width: 8),
                    Text(
                      'Sound Queue (${controller.soundQueue.length})',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.play_arrow, color: Color(0xFF03DAC6)),
                      onPressed: controller.playQueue,
                    ),
                    IconButton(
                      icon: Icon(Icons.clear_all, color: Colors.white60),
                      onPressed: controller.clearQueue,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.soundQueue.length,
                    itemBuilder: (context, index) {
                      final sound = controller.soundQueue[index];
                      return Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFF334155),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              sound.icon,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              sound.name,
                              style: GoogleFonts.inter(
                                fontSize: 8,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink());
  }

  void _showSoundOptions(SoundItem sound) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF1E293B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  sound.icon,
                  style: TextStyle(fontSize: 32),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sound.name,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        sound.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.playSound(sound);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Play Now'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.addToQueue(sound);
                      Get.back();
                      Get.snackbar(
                        'Added to Queue',
                        '${sound.name} added to sound queue',
                        backgroundColor: Color(0xFF03DAC6),
                        colorText: Colors.black,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF03DAC6),
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Add to Queue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}