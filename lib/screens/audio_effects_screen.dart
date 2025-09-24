import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/audio_effects_controller.dart';

class AudioEffectsScreen extends StatelessWidget {
  final AudioEffectsController controller = Get.put(AudioEffectsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1421),
      appBar: AppBar(
        title: Text(
          'Audio Effects',
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
            icon: Icon(Icons.restore, color: Colors.white),
            onPressed: () {
              controller.applyEffect(AudioEffect.none);
              Get.snackbar(
                'Reset',
                'All effects have been reset',
                backgroundColor: Color(0xFF03DAC6),
                colorText: Colors.black,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentEffectCard(),
            SizedBox(height: 24),
            _buildEffectGrid(),
            SizedBox(height: 24),
            _buildControlsSection(),
            SizedBox(height: 24),
            _buildAdvancedSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentEffectCard() {
    return Obx(() => Card(
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
                    color: Color(0xFF1976D2).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF1976D2), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      controller.getEffectIcon(controller.currentEffect.value),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Effect',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        controller.getEffectDisplayName(controller.currentEffect.value),
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: controller.currentEffect.value != AudioEffect.none 
                        ? Color(0xFF03DAC6).withOpacity(0.2) 
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: controller.currentEffect.value != AudioEffect.none 
                          ? Color(0xFF03DAC6) 
                          : Colors.grey,
                    ),
                  ),
                  child: Text(
                    controller.currentEffect.value != AudioEffect.none ? 'ACTIVE' : 'INACTIVE',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: controller.currentEffect.value != AudioEffect.none 
                          ? Color(0xFF03DAC6) 
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            if (controller.currentEffect.value != AudioEffect.none) ...[
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.tune, color: Colors.white60, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Effect Strength',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${(controller.effectStrength.value * 100).round()}%',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Color(0xFF03DAC6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(Get.context!).copyWith(
                  activeTrackColor: Color(0xFF03DAC6),
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Color(0xFF03DAC6),
                ),
                child: Slider(
                  value: controller.effectStrength.value,
                  onChanged: controller.setEffectStrength,
                  min: 0.0,
                  max: 1.0,
                ),
              ),
            ],
          ],
        ),
      ),
    ));
  }

  Widget _buildEffectGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voice Effects',
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
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: AudioEffect.values.length,
          itemBuilder: (context, index) {
            final effect = AudioEffect.values[index];
            return _buildEffectCard(effect);
          },
        ),
      ],
    );
  }

  Widget _buildEffectCard(AudioEffect effect) {
    return Obx(() => GestureDetector(
      onTap: () {
        controller.applyEffect(effect);
        Get.snackbar(
          'Effect Applied',
          controller.getEffectDisplayName(effect),
          backgroundColor: Color(0xFF1976D2),
          colorText: Colors.white,
          duration: Duration(seconds: 1),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: controller.currentEffect.value == effect 
              ? Color(0xFF1976D2).withOpacity(0.3)
              : Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.currentEffect.value == effect 
                ? Color(0xFF1976D2) 
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.getEffectIcon(effect),
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 8),
            Text(
              controller.getEffectDisplayName(effect),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: controller.currentEffect.value == effect 
                    ? Color(0xFF03DAC6) 
                    : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildControlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Audio Controls',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        _buildControlCard(
          title: 'Noise Reduction',
          subtitle: 'Reduce background noise',
          icon: Icons.noise_control_off,
          isToggle: true,
        ),
        SizedBox(height: 12),
        _buildVolumeControls(),
      ],
    );
  }

  Widget _buildControlCard({
    required String title,
    required String subtitle,
    required IconData icon,
    bool isToggle = false,
  }) {
    return Card(
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF1976D2).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF03DAC6), size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
        trailing: isToggle 
            ? Obx(() => Switch(
                value: controller.isNoiseReductionEnabled.value,
                onChanged: (_) => controller.toggleNoiseReduction(),
                activeColor: Color(0xFF03DAC6),
              ))
            : null,
      ),
    );
  }

  Widget _buildVolumeControls() {
    return Card(
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildVolumeSlider(
              'Microphone Gain',
              Icons.mic,
              controller.micGain,
              controller.setMicGain,
              0.0,
              2.0,
            ),
            SizedBox(height: 16),
            _buildVolumeSlider(
              'Output Volume',
              Icons.volume_up,
              controller.outputVolume,
              controller.setOutputVolume,
              0.0,
              1.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeSlider(
    String label,
    IconData icon,
    RxDouble value,
    Function(double) onChanged,
    double min,
    double max,
  ) {
    return Obx(() => Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFF03DAC6), size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${(value.value * 100).round()}%',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Color(0xFF03DAC6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(Get.context!).copyWith(
            activeTrackColor: Color(0xFF03DAC6),
            inactiveTrackColor: Colors.white24,
            thumbColor: Color(0xFF03DAC6),
          ),
          child: Slider(
            value: value.value,
            onChanged: onChanged,
            min: min,
            max: max,
          ),
        ),
      ],
    ));
  }

  Widget _buildAdvancedSettings() {
    return Card(
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          'Advanced Settings',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconColor: Color(0xFF03DAC6),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Fine-tune your audio effects with advanced parameters. These settings provide professional-level control over your voice processing.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                SizedBox(height: 16),
                _buildAdvancedSlider('Reverb Wetness', controller.reverbWetness),
                _buildAdvancedSlider('Echo Delay', controller.echoDelay),
                _buildAdvancedSlider('Pitch Shift', controller.pitchShift, min: 0.5, max: 2.0),
                _buildAdvancedSlider('Bass Gain', controller.bassGain, min: -5.0, max: 5.0),
                _buildAdvancedSlider('Treble Gain', controller.trebleGain, min: -5.0, max: 5.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSlider(String label, RxDouble value, {double min = 0.0, double max = 1.0}) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                value.value.toStringAsFixed(2),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Color(0xFF03DAC6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(Get.context!).copyWith(
              activeTrackColor: Color(0xFF03DAC6),
              inactiveTrackColor: Colors.white24,
              thumbColor: Color(0xFF03DAC6),
              trackHeight: 2,
            ),
            child: Slider(
              value: value.value,
              onChanged: (newValue) => value.value = newValue,
              min: min,
              max: max,
            ),
          ),
        ],
      ),
    ));
  }
}