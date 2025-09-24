import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final Function(String, String) onProfileUpdated;

  const EditProfileScreen({
    Key? key,
    required this.currentName,
    required this.currentEmail,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  
  String selectedAvatar = 'account_circle';
  bool _isLoading = false;

  final List<Map<String, dynamic>> avatarOptions = [
    {'icon': Icons.account_circle, 'name': 'account_circle'},
    {'icon': Icons.person, 'name': 'person'},
    {'icon': Icons.face, 'name': 'face'},
    {'icon': Icons.emoji_emotions, 'name': 'emoji_emotions'},
    {'icon': Icons.music_note, 'name': 'music_note'},
    {'icon': Icons.audiotrack, 'name': 'audiotrack'},
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
    bioController = TextEditingController(text: "Music lover and tech enthusiast");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar Selection
                  Text(
                    'Profile Picture',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      avatarOptions.firstWhere((avatar) => avatar['name'] == selectedAvatar)['icon'],
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  
                  // Avatar Options
                  Wrap(
                    spacing: 10,
                    children: avatarOptions.map((avatar) {
                      final isSelected = selectedAvatar == avatar['name'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatar = avatar['name'];
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.amber : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            avatar['icon'],
                            size: 30,
                            color: isSelected ? Colors.black : Colors.grey.shade600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Name Field
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: GoogleFonts.poppins(),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Email Field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: GoogleFonts.poppins(),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Bio Field
                  TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      prefixIcon: Icon(Icons.info_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: GoogleFonts.poppins(),
                    maxLines: 3,
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Additional Options
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.notifications, color: Colors.amber),
                          title: Text(
                            'Notifications',
                            style: GoogleFonts.poppins(),
                          ),
                          trailing: Switch(
                            value: true,
                            onChanged: (value) {
                              Get.snackbar(
                                "Notifications",
                                value ? "Notifications enabled" : "Notifications disabled",
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                              );
                            },
                          ),
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.volume_up, color: Colors.amber),
                          title: Text(
                            'Sound Effects',
                            style: GoogleFonts.poppins(),
                          ),
                          trailing: Switch(
                            value: true,
                            onChanged: (value) {
                              Get.snackbar(
                                "Sound Effects",
                                value ? "Sound effects enabled" : "Sound effects disabled",
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                              );
                            },
                          ),
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.dark_mode, color: Colors.amber),
                          title: Text(
                            'Dark Mode',
                            style: GoogleFonts.poppins(),
                          ),
                          trailing: Switch(
                            value: true,
                            onChanged: (value) {
                              Get.snackbar(
                                "Theme",
                                value ? "Dark mode enabled" : "Light mode enabled",
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _saveProfile() async {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a name",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      Get.snackbar(
        "Error",
        "Please enter a valid email",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 1));

    // Call the callback to update profile
    widget.onProfileUpdated(nameController.text, emailController.text);

    setState(() {
      _isLoading = false;
    });

    Get.back(); // Go back to profile screen
    Get.snackbar(
      "Success",
      "Profile updated successfully!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}